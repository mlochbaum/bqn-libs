# XML: Extensible Markup Language
⟨
  Parse   # XML string to BQN
⟩⇐

# XML, and tag contents, are parsed to give a list of objects.
# Objects may be tags, special tags or text.
# Text is represented as an enclosed string.
# A special tag is also an enclosed string but starts and ends with <>.
# Tags are a list of:
# - Tag name
# - Attributes, as names≍values
# - (unless void) Contents: list of text and tags

# The following open/close pairs form special tags:
# <!--       -->
# <![CDATA[  ]]>
# <!           >
# <?           >

ws ← @+9‿10‿13‿32                       # Tab, LF, CR, space
namestart ← ∧(⥊"Aa"+⌜↕26)∾"_:"
namechar  ← ∧namestart∾('0'+↕10)∾".-"   # (ASCII only)

E ← +`⊸×⟜¬-⊢
Se←≠(>/⊢)∾⟜≠{(⊏˜𝕨)𝕊⍟(≠○(¯1⊸⊑))𝕩∾𝕩⊏𝕨}⟨0⟩˙
Trace←{𝕨(Se∘⍋⊏≍˘)○((⍋𝕨)⊸⊏)𝕩}○∾

Parse ← {
  # Resolve special tags not closed by plain >
  Tr ← (≠𝕩)↑·/⁼·⥊Trace
  [sm,sn] ← 1‿¯1(×⟜(≠𝕩)↑⊢⍷𝕩˙)¨["<!--"‿"<![CDATA[","-->"‿"]]>"]
  excl ← ≠`sb←Tr´ ⟨/¨sm, sm(0∾+`)⊸(-⟜»∘⊏˜/⊢)⟜(/∾⟜1)¨sn⟩
  # And quotes
  excl∨↩ ≠`qb←Tr˝ ¯1‿1↓⌜(/excl<𝕩⊸=)¨"'"""
  # Extract tags
  tl ← ≠`∨´tm←((sb<excl)<𝕩⊸=)¨"<>"
  "Ill-formed tag" ! (tm≡»⊸(<⋈>)tl) ∧ 0=⊢´tl
  tw ← excl<𝕩∊ws∾"=" ⋄ sl ← 𝕩='/'
  ts ← (sb∨«𝕩∊"!?")<⊑tm
  te ← (1⊑tm)∧ts⊏˜⌈`(⊑tm)×↕≠𝕩
  os ← ts ∨ »te ⋄ tse ← ts ∨ te
  rg ← (rb←os∨(sl<tl)∧»⊸>tw) E (»⊸∨excl<tl)∧qb∨tw∨sl∨tse
  pd ← (0∾rb/(≠`tse)×+`ts) ⊔ rg⊔𝕩
  pt ← (2×ts»⊸/sl)-˜¬te«⊸/sl         # Tag type: ¯1 close, 0 void, 1 open
  ! ∧´≡○⊑¨˝ pd ⊏˜ 1+(⍋⊏⟜(+`pt))⊸⊏∘/˘ ¯1‿1=⌜pt  # Tag matching
  tag ← os/ts
  tt ← pt⌾(tag⊸/) tag
  [c,n,o]←¯1‿0‿1=⌜tt
  op‿v ← ((0≤pt)/0=pt) ∾⟜2⊸⊔ (⊑⋈·⍉∘‿2⥊1↓⊢)¨ (0≤pt)/1↓pd
  l ← +`⌾((⍋+`tt)⊸⊏) o               # Parent index
  nv← ≠vals ← (<¨1↓⊑pd) ∾ v          # Initial set of values
  vi← ⍋⍋(f←¬o)/c                     # Value indices
  i ← vi ⊏ (⍋⍋n/tag) ∾ nv+≠⊸-c/»l    # Adjust for collection ordering
  (⟨⟩⋈⊸∾op) {vals∾↩⟨𝕨∾⟨𝕩⊏vals⟩⟩⋄@}¨○⌽ ((1+´c)∾˜f/l)⊔i
  ⊑¯1⊑vals
}
