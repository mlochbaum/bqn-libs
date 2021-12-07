⟨
  _join
  Split, Locate
  ReplaceAll
  _template
  tab,lf,cr,crlf, JoinLines
  Trim
  ToBytes, FromBytes
  ToNats, ToNums
⟩⇐

# Whitespace characters: tab, linefeed, carriage return
tab‿lf‿cr ← @+9‿10‿13
crlf ← cr‿lf  # Windows-style line separator

# Convert lines to lf-separated string, including trailing lf
JoinLines ← ∾ ∾⟜lf¨

# "sep"_join is like ∾ but inserts "sep" between any joined strings
_join ← {∾1↓⥊(<𝕗)≍˘𝕩 ; ∾𝕨‿𝕗‿𝕩}

# Remove leading (∧`) and trailing (∧`⌾⌽) spaces
Trim ← ((∨` ∧ ∨`⌾⌽) ' '⊸≠)⊸/

# Given strings ⥊𝕨 and 𝕩, return ⟨start_mask, keep_mask⟩ for split
MarkSplit ← (2⌊≠∘⊣)◶{𝕤
  ! "Split: 𝕨 can't be empty"
}‿{
  ⋈⟜¬ (⟨⟩⥊𝕨)=𝕩
}‿{
  c ← (≠𝕨)-1                  # 𝕨⍷𝕩      011000010011    (c←3)
  i ← 0 (-⟜1⌈c×<)` (≠𝕩)↑𝕨⍷𝕩   # i        032100032103210
  ⟨c=i,1⊸»⊸∧0=i⟩              # 1⊸»⊸∧0=i 100001100000000
}

# Return mask of non-overlapping positions in 𝕩 where 𝕨 is found
# Like 𝕨⍷𝕩 but same length as 𝕩 and suppressing overlaps (leftmost wins)
Locate ← ⊑ MarkSplit

# Split string 𝕩 on occurrences of separator 𝕨, removing the separators
Split ← (0<≠∘⊢)◶⟨
  ⋈⊢
  (1+`⊢)⊸((1-˜×)∾¯1⊏⊣)´∘MarkSplit⍟(0<≠∘⊢) ⊔ ⊢
⟩

# Replace each instance of a string in old with the corresponding
# string in new.
# Instances are non-overlapping, and earlier ones take precedence.
ReplaceAll ← { ⟨old,new⟩ 𝕊 str:
  ! (≠new) ≡ l ← ≠old
  match ← 1-˜ (l+1)|⌊´ (↕⊸-l) × old Locate¨ <str
  cont ← (-⟜1⌈≤⟜1×⊢)` match ⊏ (≠¨old)∾0
  keep ← ⋈⟜(⊏⟜str) / 0=cont
  insert ← (new⊏˜⊏⟜match)⊸(≠¨⊸/⋈∾∘⊣) / (0⊸<∧»⊸≤) cont
  ⍋⊸⊏´ keep ∾¨ insert
}

# Replace instances of 𝕗 in 𝕨 with successive elements of 𝕩
_template ← { ∾ 1 (↑∾·⥊𝕩≍˘↓) 𝕗 Split 𝕨 }

# UTF-8 conversions
ToBytes ← ∾ (2⋆7)⊸(⊣+(2⋆6){𝕨 ≤◶⟨⥊⊢-2×-⟜𝕗 ⋄ 𝕗(|∾˜(2÷˜⌊⟜𝕨)𝕊⌊∘÷˜)⊢⟩ 𝕩}¨)⌾(-⟜@)
FromBytes ← (+`2⋆7-↕5){
  t←𝕗⍋𝕩
  !((/¬⍟(<⟜2)¨)≡·⌈`1⊸≠×↕∘≠)t
  !(↕∘≠≡·⊒⊸+∘/¬⍟(<⟜2)¨)t
  r←(2⋆6)⊸×⊸+˜´∘⌽¨(¯1+`t≠1)⊔𝕩-t⊏»𝕗
  r
}⌾(-⟜@)

# Parse numbers from a string, treating non-numeric characters as
# separators
# Natural numbers recognize digits only
NN ← (>⟜«0⊸≤) / 0(0⊸≤××⟜10⊸+)`⊢
ToNats ← { NN 10⊸≤⊸(¬⊸×-⊣) 𝕩-'0' }

# General numbers recognize digits and eE.¯-π∞ (mild extension of BQN)
ToNums ← {
  T←⌈`× ⋄ I1T←(1+↕∘≠)⊸T
  cd←≠dig←('0'+↕10)∾"π∞" ⋄ val←(↕10)∾π‿1‿¯1 # ∞ as 1 to avoid ∞×0
  e‿d‿n‿p‿i←"e.¯π∞"=<𝕩 ⋄ e‿n∨↩"E-"=<𝕩
  m←d∨cd>j←dig⊐𝕩
  s←d∨c←e∨z←(∧`⌾⌽<»⊸<)zz←¬e∨n∨m
  "Negative sign in the middle of a number"! ∧´n≤1»c
  "Portion of a number is empty"! ∧´¬(1«s)∧n∨s
  "Ill-formed decimal or exponent use"! ∧´(0⊸=∨»⊸<)s/d+2×e
  "π and ∞ must occur alone"! ∧´(p∨i)≤1(»∧(p∧«e)∨«)zz∨n>»e
  f←(17≥¬(⊢-T)+`)⊸∧g←(«≤(d<j≠0)>○I1T¬)⊸∧m   # No leading 0s; max 17 digits
  vs←1‿¯1⊏˜(r←>⟜»m)/»n                      # Negate if ¯
  v←vs×NN val⊏˜(¬d)/(cd×¬f)⌈j               # Numeric values—mantissas and exponents
  vm←c/○(1⌾⊑)z                              # Mask of mantissas in v
  dp←vm/f(--»⊸-(<×⊢)⊏⟜(I1T«d)⊸-)○(/>⟜«)g    # Decimal position
  q←10⋆|ee←dp-˜vm/«v×¬vm                    # Power of 10
  q÷˜⌾((0>ee)⊸/)q×⌾((0<ee)⊸/)vm/v×(r/i)⊏1‿∞ # Correct ∞ then ×10⋆ee
}
