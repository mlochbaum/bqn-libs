⟨
  _join
  Split, Locate
  tab,lf,cr,crlf, JoinLines
  Trim
  ToBytes, FromBytes
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
  ≍○<⟜¬ (⟨⟩⥊𝕨)=𝕩
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
  ≍○<⊢
  (1+`⊢)⊸((1-˜×)∾¯1⊏⊣)´∘MarkSplit⍟(0<≠∘⊢) ⊔ ⊢
⟩

ToBytes ← ∾ (2⋆7)⊸(⊣+(2⋆6){𝕨 ≤◶⟨⥊⊢-2×-⟜𝕗 ⋄ 𝕗(|∾˜(2÷˜⌊⟜𝕨)𝕊⌊∘÷˜)⊢⟩ 𝕩}¨)⌾(-⟜@)
FromBytes ← (+`2⋆7-↕5){
  t←𝕗⍋𝕩
  !((/¬⍟(<⟜2)¨)≡·⌈`1⊸≠×↕∘≠)t
  !(↕∘≠≡·⊒⊸+∘/¬⍟(<⟜2)¨)t
  r←(2⋆6)⊸×⊸+˜´∘⌽¨(¯1+`t≠1)⊔𝕩-t⊏»𝕗
  r
}⌾(-⟜@)
