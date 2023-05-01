# Format number
# Expected to be in the range 1e¯6 to 1
# Use 3 sig figs and no scientific notation
Fmt ⇐ {
  s ← 3
  d ← s¬⌊•math.Log10𝕩   # Digits after decimal point
  t ← •Repr ⌊0.5+𝕩×10⋆d # Nonzero trailing digits
  (•Repr ⌊𝕩)∾"."∾(0⌊s-≠t)↓t«d⥊'0'
}

# Format error margin
# Hopefully very small (~1e¯10) but could be very large
# Two digits; always use scientific notation
FmtErr ⇐ {
  ¬∞>|𝕩? •Repr𝕩 ;
  e ← ⌊•math.Log10𝕩
  r ← 0.5+𝕩×10⋆1-e
  {r≥100? r÷↩10 ⋄ e+↩1 ; @}
  (1(↑∾"."∾↓)'0'+10(⌊∘÷˜⋈|)⌊r)∾"e"∾•Repr e
}

# Format line, expecting (2+≠𝕨)≤𝕗
_line ⇐ {((𝕗⌈≠)⊸↑ 𝕨∾": ") ∾ Fmt⍟(1=•Type) 𝕩}

_lineErr ⇐ {
  (((10+𝕗)⌈≠)⊸↑∾⟜" " 𝕨 𝕗_line ⊑𝕩) ∾ ("(±"∾FmtErr∾")"˙)⍟(1=•Type) 1⊑𝕩
}
