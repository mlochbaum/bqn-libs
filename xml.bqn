# XML: Extensible Markup Language
⟨
  Parse   # XML string to BQN
⟩⇐

# XML, and tag contents, are parsed to give a list of objects.
# Objects may be tags or text.
# Text is represented as an enclosed string.
# Tags are a list of:
# - Tag name
# - Attributes, as names≍values
# - (unless void) Contents: list of text and tags

E ← +`⊸×⟜¬-⊢
Se←≠(>/⊢)∾⟜≠{(⊏˜𝕨)𝕊⍟(≠○(¯1⊸⊑))𝕩∾𝕩⊏𝕨}⟨0⟩˙
Trace←{𝕨(Se∘⍋⊏≍˘)○((⍋𝕨)⊸⊏)𝕩}○∾

Parse ← {
  # Resolve special tags
  Tr ← ≠`⊸>(≠𝕩)↑·/⁼·⥊Trace
  [sm,sn] ← (≠∘⊢↑⍷)⟜𝕩¨["<!--"‿"<![CDATA[","-->"‿"]]>"]
  excl ← Tr´ ⟨/¨sm, sm(0∾+`)⊸(-⟜»∘⊏˜/⊢)⟜(/∾⟜1)¨sn⟩
  # And quotes
  excl∨↩ Tr˝ ¯1‿1↓⌜(/excl<𝕩⊸=)¨"'"""
  # Extract tags
  obj ← ((+⟜»E∨)˝excl⊸<˘"<>"=⌜𝕩)⊔𝕩
  tag ← (↕2)⥊˜≠obj
  tag‿obj (tag∨0<≠¨obj)⊸/¨↩
  GT← (∧´"!?"≠⊑)×1-·+˜⊸+´'/'=0‿¯1⊸⊏
  d ← +`tt←obj GT∘⊣¨⌾(tag⊸/) tag     # Tag type: ¯1 close, 0 void, 1 open
  [c,n,o]←¯1‿0‿1=⌜tt
  tp← (⍋⊏⟜d)⊸⊏∘/˘ o≍c                # Tag pairs
  ! (∧`' '⊸≠)⊸/¨⊸≡⟜(1⊸↓¨)˝tp⊏obj     # Tag matching
  to← c<tag                          # Tag objects, open or void
  op‿v ← (to/n) ∾⟜2⊸⊔ ParseAttr¨ (-to/n)↓¨ to/obj
  l ← +`⌾((⍋d)⊸⊏) o                  # Parent index
  nv← ≠vals ← (<¨obj/˜to<n) ∾ v      # Initial set of values
  vi← ⍋⍋(f←¬o)/c                     # Value indices
  i ← vi ⊏ (⍋⍋n/to) ∾ nv+≠⊸-c/»l     # Adjust for collection ordering
  (⟨⟩⋈⊸∾op) {vals∾↩⟨𝕨∾⟨𝕩⊏vals⟩⟩⋄@}¨○⌽ ((1+´c)∾˜f/l)⊔i
  ⊑¯1⊑vals
}
ParseAttr ← {
  q ← (≠𝕩)↑/⁼⥊Trace˝ ¯1‿1↓⌜(/𝕩⊸=)¨"'""" # Duplicates work from Parse
  name‿a ← (⊑⋈1⊸↓) (g←E˜(≠`q)<' '=𝕩)⊸⊔ 𝕩
  ⟨name, {0=≠a?2‿0⥊0;⍉>(1↓g⊔q)((E˝·∨`'='⊸=≍⊣)⊔⊢)¨a}⟩
}
