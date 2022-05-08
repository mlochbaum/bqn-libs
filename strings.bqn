⟨
  _join
  Split, Locate
  ReplaceAll
  _template
  tab,lf,cr,crlf, JoinLines
  Trim
  CEscape
  ToBytes, FromBytes
  ToBase64, FromBase64
  ToNats, ToNums
  Lcs, LcsLen, Levenshtein
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
  "ReplaceAll: Can't replace empty" ! ∧´0<≠¨old
  match ← 1-˜ (l+1)|⌊´ (↕⊸-l) × old (1<≠∘⊣)◶⟨⊑⊸=,≠∘⊢↑⍷⟩¨ <str
  cont ← (-⟜1⌈≤⟜1×⊢)` match ⊏ (≠¨old)∾0
  keep ← ⋈⟜(⊏⟜str) / 0=cont
  insert ← (new⊏˜⊏⟜match)⊸(≠¨⊸/⋈∾∘⊣) / (0⊸<∧»⊸≤) cont
  ⍋⊸⊏´ keep ∾¨ insert
}

# Replace instances of 𝕗 in 𝕨 with successive elements of 𝕩
_template ← { ∾ 1 (↑∾·⥊𝕩≍˘↓) 𝕗 Split 𝕨 }

# String escaping
⟨CEscape⟩ ← {
  basic ← """'?\abefnrtv"
  comp  ← (hex←"uUx")∾(oct←'0'+↕8)
  in  ← basic∾comp
  out ← ∾⟨4↑in, @+7‿8‿27‿12‿10‿13‿9‿11, @¨comp⟩
  c_hex ← (≠hex) + c_basic ← ≠basic
  c_fix ← 2 + c_basic
  len ← ∾⟨0¨basic, 4‿8‿∞, 3¨oct⟩
  CEscape ⇐ { 𝕊s:
    m ← » bs ← <`s='\'
    max ← ⌈´ i ← in ⊐ m/s
    "Unsupported escape sequence" ! max<≠in
    keep ← ¬bs
    o ← i⊏out
    { max < c_basic ?@; # If compound escapes
      f ← i ≥ c_basic
      ic ← f/i ⋄  im ← f//m
      d ← ic<c_hex
      l ← (ic⊏len) ⌊ (1+d) -˜ (≠m)(«-⊢)im
      ld ← l/d
      sel ← s ⊏˜ ia ← (l/im+d)+li←⊒/l
      dig ← ("Aa"-'0')⊸(⊢+(0∾10-⊣)⊏˜⍋)⌾(ld⊸/) '0'-˜sel
      isdig ← (0⊸≤ ∧ <⟜(8×1+ld)) dig
      lm ← 0=li
      n‿ku ← { max < c_fix ?
        "Numeric code ends early" ! ∧´ isdig
        ⟨ {0 16⊸×⊸+˜´⌽𝕩}¨(¯1+`lm)⊔dig , 0¨ ⟩
      ; # If variable-length escapes
        k ← lm >○(⌈`(1+↕∘≠)⊸×)⟜¬ isdig
        bm ← l/ic<c_fix
        "Numeric code ends early" ! ∧´ bm≤k
        "\x must be followed by at least one digit" ! ∧´ lm≤k
        ⟨ (8×1+d){0𝕨⊸×⊸+˜´⌽𝕩}¨(1-˜k×+`lm)⊔dig , k≤ld<lm ⟩
      }
      keep ku⌾(ia⊸⊏)↩
      o (@+n)⌾(f⊸/)↩
    }
    keep / o⌾(m⊸/) s
  }
}

# UTF-8 conversions
ToBytes ← ∾ (2⋆7)⊸(⊣+(2⋆6){𝕨 ≤◶⟨⥊⊢-2×-⟜𝕗 ⋄ 𝕗(|∾˜(2÷˜⌊⟜𝕨)𝕊⌊∘÷˜)⊢⟩ 𝕩}¨)⌾(-⟜@)
FromBytes ← (+`2⋆7-↕5){
  t←𝕗⍋𝕩
  !((/¬⍟(<⟜2)¨)≡·⌈`1⊸≠×↕∘≠)t
  !(↕∘≠≡·⊒⊸+∘/¬⍟(<⟜2)¨)t
  r←(2⋆6)⊸×⊸+˜´∘⌽¨(¯1+`t≠1)⊔𝕩-t⊏»𝕗
  r
}⌾(-⟜@)

# Base64
b64 ← ∾ (⊣+↕∘¬˜)¨˝˘ ∘‿2⥊"AZaz09++//"
K64 ← ⥊¨⟜(4⋆⟨1+↕3,2-↕3⟩) # Bytes split as 6/2-4/4-2/6
ToBase64 ← {𝕊⁼𝕩: FromBase64𝕩;
  l←≠i←𝕩-@ ⋄ "Base64 input must consist of bytes (<@+256)" ! ∧´256>i
  f←l⥊1+0=↕3
  M←((+´f)⥊0<↕4) × f⊸/
  a‿b←K64 l
  v←a (⌊∘÷˜ «⊸+○M b×|) i
  (v⊏b64)∾(3|-l)⥊'='
}
FromBase64 ← {𝕊⁼𝕩: ToBase64𝕩;
  p←64>i←b64⊐𝕩
  "Invalid Base64 characters" ! ∧`⊸≡ p
  i↑˜↩l←+´p
  a‿b←K64 +´f←l⥊0<↕4
  @ + (256|a×(«f)/i) + b⌊∘÷˜f/i
}

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

# String similarity
LcsLen ← ∧○(0<≠)◶⟨0, ¯1 ⊑ 0¨∘⊢ {𝕩⌈⌈`𝕨+»𝕩}˝ =⌜⟜⌽⟩
Lcs ← ¯1 ⊑ "" <⊸∾ ""¨∘⊢ ⊣⍟(>○≠){𝕩𝔽¨𝔽`𝕨∾¨""<⊸»𝕩}˝ (=⌜⥊¨⊣)⟜⌽
Levenshtein ← ¯1⊑{𝕨((1⊸+⥊+)○≠(⌊`⊢⌊⊏⊸»∘⊢-0∾1+=⟜𝕩)´⌽∘⊣)𝕩}
