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

Se←≠(>/⊢)∾⟜≠{(⊏˜𝕨)𝕊⍟(≠○(¯1⊸⊑))𝕩∾𝕩⊏𝕨}⟨0⟩˙
Trace←{𝕨(Se∘⍋⊏≍˘)○((⍋𝕨)⊸⊏)𝕩}○∾

# Format error with message 𝕨 at locations 𝕩 in 𝕗
_fmtErr ← { msg src _𝕣 pos:
  lf ← @+10
  s ← 0∾1+ b←/src=lf                # Line start and break positions
  l ← (1↓s) ⍋ pos                   # Error line numbers
  c ← pos - l⊏s                     # Error column numbers
  d ← ⊑l                            # First line only
  1↓∾lf⊸∾¨ ⟨
    msg
    (d⊑s)↓(d⊑b∾≠src)↑src            # Display first line
    " ^" ⊏˜ /⁼ (d=l)/c              # And carets under errors
  ⟩∾{
    n ← ≠ a ← d⊸≠⊸/l                # 1-indexed numbers of other lines
    0<n ? ⋈((-1=n)↓"Also lines")∾1↓∾⥊(<", ")≍˘•Repr¨1+a
    ; ⟨⟩
  }
}

Parse ← {
  FE ← 𝕩_fmtErr ⋄ _err ← {(! 𝕗 FE /)⍟(∨´)}
  # Resolve special tags not closed by plain >
  Tr ← (≠𝕩)↑·/⁼·⥊Trace
  Match ← (0∾+`)⊸(-⟜»∘⊏˜/⊢)⟜(/∾≠)
  [sm,sn] ← 1‿¯1(×⟜(≠𝕩)↑⊢⍷𝕩˙)¨["<!--"‿"<![CDATA[","-->"‿"]]>"]
  ex ← ≠`⊸> sb ← Tr´ ⟨/¨sm, sm Match¨ sn⟩
  # And quotes/brackets
  # Treat >< as a kind of quote since quotes inside are just text
  qs‿qd‿ee‿es ← (ex<𝕩⊸=)¨"'""><"
  qa ← Tr˝ (¯1‿1↓⌜/¨qs‿qd) ∾˘ ⟨/ee, ee Match es⟩
  eq ← ≠` qb ← qa ∧ qs∨qd
  # Extract strings and group into tags
  es‿ee (≠`⊸>qa)⊸<¨↩                 # Tag start and end including special
  "Unclosed tag bracket"_err es>(∨`⌾⌽∧qa≥∨`)ee
  os ← 1⌾⊑es∨»ee                     # Start of any object
  ts ← (sb∨«𝕩∊"!?")<es               # Tag start < (non-special)
  te ← ee∧ts⊏˜⌈`es×↕≠𝕩               # Tag end   >
  td ← (»⊸∧eq) < ≠` tb ← ts∨te       # Non-quote tag interior
  tw ← td∧𝕩∊ws∾"=" ⋄ sl ← 𝕩='/'
  rb ← os∨td∧sl<»⊸>tw                # String boundaries (starts with 1)
  rs ← 𝕩 ⊔˜ 1-˜(+`rb)×¬tb∨td∧qb∨tw∨sl# Extracted strings
  fr‿ta ← (⊑⋈1⊸↓) (rb/td×+`ts) ⊔ rs  # Group attributes into their tags
  pt ← (2×ts»⊸/sl)-˜¬te«⊸/sl         # Tag type: ¯1 close, 0 void, 1 open
  ! ∧´≡○⊑¨˝ ta ⊏˜ (⍋⊏⟜(+`pt))⊸⊏∘/˘ ¯1‿1=⌜pt  # Tag matching
  op‿v ← (⊑⋈·⍉∘‿2⥊1↓⊢)¨¨ ⌽ (pt∾2)⊔ta # Build tag data
  # Build result
  tag ← os/ts
  tt ← pt⌾(tag⊸/) tag
  [c,n,o]←¯1‿0‿1=⌜tt                 # Close, neither, open
  l ← +`⌾((⍋+`tt)⊸⊏) o               # Parent index
  nv← ≠vals ← (<¨fr) ∾ v             # Initial set of values
  vi← ⍋⍋(f←¬o)/c                     # Value indices
  i ← vi ⊏ (⍋⍋n/tag) ∾ nv+≠⊸-c/»l    # Adjust for collection ordering
  (⟨⟩⋈⊸∾op) {vals∾↩⟨𝕨∾⟨𝕩⊏vals⟩⟩⋄@}¨○⌽ ((1+´c)∾˜f/l)⊔i
  ⊑¯1⊑vals
}
