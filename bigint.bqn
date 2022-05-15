# Arithmetic on large integers.

nat ← •args •Import "bignat.bqn"

Canon ← 0⌾⊑⍟(0=·≠1⊸⊑)

SubLE ← nat.Sub˜⌾(1⊸⊑)
SubAbs← ≤nat._compare○(1⊸⊑)◶⟨SubLE˜,SubLE⟩
Add ⇐ Canon ≠○⊑◶⟨nat.Add⌾(1⊸⊑),SubAbs⟩

Neg ⇐ ¬⌾⊑⍟(nat.Signum 1⊸⊑)
Abs ⇐ 0⌾⊑
Sub ⇐ Add⟜Neg

Mul ⇐ Canon ≠○⊑ ⋈ nat.Mul○(1⊸⊑)

_compare ⇐ {=○⊑◶⟨𝔽○(¬⊑), ⊑∘⊢◶({𝕏nat._compare○(1⊸⊑)}¨⟨𝔽,𝔽˜⟩)⟩}

Signum ⇐ ⊑◶⟨nat.Signum 1⊸⊑,¯1⟩
Conj ⇐ ⊢
