# Return all complex roots of little-endian polynomial 𝕩
# 𝕨 gives the number of iterations
# Result is a list of real‿imag pairs
WeierstrassRoots ← {
  M ← -´∘×⋈+´∘×⟜⌽
  D ← (-⌾(1⊸⊑) ÷ +˝∘(×˜)){𝔽⊘(M⟜𝔽)}
  F ← (M¨⟜(D¨¯1⊸⊏)⋈⟜0⍟(0==)¨𝕩){+⟜(𝕩⊸M)´𝕗}
  n ← ≠𝕩
  r0← <˘⍉> 1‿0 M⍟(↕n-1)˜ 4‿9÷10  # Initial roots: 0.4i0.9⋆↕n-1
  r ← -⟜(F D ·M˝·⍉0(⊢+1‿0×⌜∧˝∘=)·><⊸-¨)⍟(𝕨⊣50) r0
  <˘⍉> (1e¯16<|)⊸× r
}
