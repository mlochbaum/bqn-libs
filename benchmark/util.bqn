# Format number
# Expected to be in the range 1e¯6 to 1
# Use 3 sig figs and no scientific notation
Fmt ⇐ {
  d ← 2-⌊•math.Log10𝕩 # Digits after decimal point
  (•Repr ⌊𝕩)∾"."∾(•Repr ⌊0.5+𝕩×10⋆d)«d⥊'0'
}

# Format line, expecting (2+≠𝕨)≤𝕗
_line ⇐ {((𝕗⌈≠)⊸↑ 𝕨∾": ") ∾ Fmt⍟(1=•Type) 𝕩}

NsGet ⇐ {""‿""‿𝕨⊸•BQN"•args."∾𝕩}
