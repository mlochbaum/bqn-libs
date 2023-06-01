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
  os ← ∨⟜»´tm
  tw ← excl<𝕩∊ws∾"=" ⋄ ts ← 𝕩='/'
  rg ← (rb←os∨(ts<tl)∧»⊸>tw) E (»⊸∨excl<tl)∧qb∨tw∨ts∨∨´tm
  tts← (sb∨«𝕩∊"!?")<⊑tm
  tte← (1⊑tm)∧tts⊏˜⌈`(⊑tm)×↕≠𝕩
  pd ← (0∾rb/(≠`tts∨tte)×+`tts) ⊔ rg⊔𝕩
  pt ← (2×'/'=tts»⊸/𝕩)-˜¬'/'=tte«⊸/𝕩
  tag ← os/tsm←⊑tm
  obj ← ((»«os)E∨´tm)⊔𝕩
  st← "!?"∊˜tsc←tsm»⊸/𝕩
  gt← (2×'/'=tsc)-˜¬st∨'/'=𝕩/˜«1⊑tm  # TODO migrate to pt
  d ← +`tt←gt⌾(tag⊸/) tag            # Tag type: ¯1 close, 0 void, 1 open
  [c,n,o]←¯1‿0‿1=⌜tt
  ! ∧´≡○⊑¨˝ pd ⊏˜ 1+(⍋⊏⟜(+`pt))⊸⊏∘/˘ ¯1‿1=⌜pt     # Tag matching
  to← c<(¬st)⌾(tag⊸/) tag            # Tag objects, open or void
  op‿v ← ((0≤pt)/0=pt) ∾⟜2⊸⊔ (⊑⋈·⍉∘‿2⥊1↓⊢)¨ (0≤pt)/1↓pd
  l ← +`⌾((⍋d)⊸⊏) o                  # Parent index
  nv← ≠vals ← (<¨obj/˜to<n) ∾ v      # Initial set of values
  vi← ⍋⍋(f←¬o)/c                     # Value indices
  i ← vi ⊏ (⍋⍋n/to) ∾ nv+≠⊸-c/»l     # Adjust for collection ordering
  (⟨⟩⋈⊸∾op) {vals∾↩⟨𝕨∾⟨𝕩⊏vals⟩⟩⋄@}¨○⌽ ((1+´c)∾˜f/l)⊔i
  ⊑¯1⊑vals
}
