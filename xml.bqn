# XML: Extensible Markup Language
⟨
  Parse   # XML string to BQN
⟩⇐

# Represent text as a string
# Non-void tags are a list of:
# - Tag name
# - Attributes, as names≍values
# - Contents: list of text and tags
E ← +`⊸×⟜¬-⊢
Parse ← {
  obj ← ((+⟜»E∨)˝"<>"=⌜𝕩)⊔𝕩
  tag ← (↕2)⥊˜≠obj
  d←+`tt←obj (1-·+˜⊸+´'/'=0‿¯1⊏⊣)¨⌾(tag⊸/) tag # Tag type: ¯1 close, 0 void, 1 open
  tp←(⍋⊏⟜d)⊸⊏∘/˘ 1‿¯1=⌜tt            # Tag pairs
  ! (∧`' '⊸≠)⊸/¨⊸≡⟜(1⊸↓¨)˝tp⊏obj     # Tag matching
  o←tt>0 ⋄ c←tt<0
  op ← ParseAttr¨ o/obj
  l ← +`⌾((⍋d)⊸⊏) 0<tt               # Parent index
  nv← ≠vals ← (tt=0)/obj             # Initial set of values
  f ← tt≤0                           # Reduce open/closed pairs to end
  vi← ⍋⍋f/c                          # Value indices
  i ← vi ⊏ (↕nv) ∾ nv+≠⊸-c/»l        # Adjust for collection ordering
  op {vals∾↩⟨𝕨∾⟨𝕩⊏vals⟩⟩⋄@}¨○⌽ ((+´c)∾˜1-˜f/l)⊔i
  ¯1⊑vals
}
ParseAttr ← {
  name‿a ← (⊑⋈1⊸↓) (E˜' '⊸=>·≠`'"'⊸=)⊸⊔𝕩
  ⟨name, ⍉>(E˝·∨`"="""=⌜⊢)⊸⊔¨a⟩
}
