# Perlin noise generators in 1 and n dimensions

S ← ×˜ × 3-2⊸×

Noise1 ← { ⟨bk,g1p⟩𝕊𝕩:
  (¬⊸≍ S 1|𝕩) +˝∘× g1p ⊏˜ bk | 0‿1+⌜⌊𝕩
}

# n-dimensional noise, where n is ≠𝕩
NoiseN ← { ⟨bk,p,g⟩𝕊𝕩:
  f‿m ← (⌊⋈1⊸|) 𝕩 ⋄ d←G n←≠𝕩
  b ← +⌜⟜(⊏⟜p¨)˝ bk|f+⌜0‿1
  a ← (↕n⥊2) m⊸-⊸(+´×)⟜(<⊏¨d˙)¨ b
  <⁼ a ¬⊸⋈⊸(+˝×)´ ⌽ S m
}

# Generate random seeding values
MakeData ← {𝕤
  bk ⇐ 16⋆2
  Sh ← (2×1+bk)⊸⥊
  Rand ← -⟜¬ •rand.Range⟜0
  p ⇐ Sh •rand.Deal bk
  gc ← ⟨⟩‿⟨Sh Rand bk⟩
  g1p ⇐ p⊏⊑1⊑gc
  GG ← (Sh¨ <˘÷⎉1·<+˝⌾(×˜)) ·Rand ⋈⟜bk
  G ⇐ {
    (≠gc) {gc ∾↩ GG¨ 𝕨+↕𝕩¬𝕨}⍟≤ 𝕩
    𝕩⊑gc
  }
}
