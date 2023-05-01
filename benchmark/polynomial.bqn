⟨_lineErr⟩ ← •Import "util.bqn"
poly ← •Import "../polynomial.bqn"
rfns ← poly •ns.Get⟜(∾⟜"Roots")¨ roots ← "Laguerre"‿"Aberth"‿"Weierstrass"
sizes ← 10‿20‿40‿100

TimeErr ← { p 𝕊 root:
  r ← @
  t ← {r↩𝕩}∘Root•_timed p
  # Reconstruct coefficients
  q ← (⊢´p) × (+´¨ +⌜○(↕≠) ⊔ (-´∘×⋈+´∘×⟜⌽)⌜)´ (-⋈1‿0˙)¨ r
  e ← (+´∘⥊÷≠)⌾(×˜)> (p⋈¨0) - q
  t‿e
}⎊(⋈˜"!")

L ← 42 _lineErr
{
  p ← -⟜¬ 𝕩 •rand.Range 0
  m ← ∾ "Roots of random real "‿(¯3↑•Repr𝕩)‿" by "
  (m⊸∾¨ roots) •Out∘L⟜(p⊸TimeErr)¨ rfns
}¨ sizes
