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
  ex ← ≠`⊸>sb←Tr´ ⟨/¨sm, sm(0∾+`)⊸(-⟜»∘⊏˜/⊢)⟜(/∾⟜1)¨sn⟩
  # And quotes
  eq ← ≠`qb←Tr˝ ¯1‿1↓⌜(/ex<𝕩⊸=)¨"'"""
  # Extract strings and group into tags
  es‿ee ← ((ex∨eq)<𝕩⊸=)¨"<>"         # Tag start and end including special
  "Ill-formed tag" ! {((es/𝕩)∧○(∧´)¬ee/𝕩) ∧ 0=⊢´𝕩} ≠`es∨ee
  ts ← (sb∨«𝕩∊"!?")<es               # Tag start < (non-special)
  te ← ee∧ts⊏˜⌈`es×↕≠𝕩               # Tag end   >
  os ← ts∨»te
  td ← (»⊸∧eq) < ≠` tb ← ts∨te
  tw ← td∧𝕩∊ws∾"=" ⋄ sl ← td∧𝕩='/'
  rg ← (rb←os∨td∧sl<»⊸>tw) E qb∨tb∨tw∨sl
  pd ← (0∾rb/td×+`ts) ⊔ rg⊔𝕩
  pt ← (2×ts»⊸/sl)-˜¬te«⊸/sl         # Tag type: ¯1 close, 0 void, 1 open
  ! ∧´≡○⊑¨˝ pd ⊏˜ 1+(⍋⊏⟜(+`pt))⊸⊏∘/˘ ¯1‿1=⌜pt  # Tag matching
  op‿v ← (⊑⋈·⍉∘‿2⥊1↓⊢)¨¨ ⌽ (pt∾2) ⊔ 1↓pd  # Build tag data
  # Build result
  tag ← os/ts
  tt ← pt⌾(tag⊸/) tag
  [c,n,o]←¯1‿0‿1=⌜tt
  l ← +`⌾((⍋+`tt)⊸⊏) o               # Parent index
  nv← ≠vals ← (<¨1↓⊑pd) ∾ v          # Initial set of values
  vi← ⍋⍋(f←¬o)/c                     # Value indices
  i ← vi ⊏ (⍋⍋n/tag) ∾ nv+≠⊸-c/»l    # Adjust for collection ordering
  (⟨⟩⋈⊸∾op) {vals∾↩⟨𝕨∾⟨𝕩⊏vals⟩⟩⋄@}¨○⌽ ((1+´c)∾˜f/l)⊔i
  ⊑¯1⊑vals
}
