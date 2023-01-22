⟨_line, NsGet⟩ ← •Import "util.bqn"
poly ← •Import "../polynomial.bqn"
rfns ← poly NsGet⟜(∾⟜"Roots")¨ roots ← "Laguerre"‿"Aberth"‿"Weierstrass"
sizes ← 10‿20‿40‿100

FmtErr ← {(∨`𝕩='e')∨(∧`𝕩≠'.')∨3≥+`(𝕩='.')<∨`¬𝕩∊"0."}⊸/ •Repr

L ← 42 _line
{
  p ← -⟜¬ 𝕩 •rand.Range 0
  m ← ∾ "Roots of random real "‿(¯3↑•Repr𝕩)‿" by "
  Err ← {"(±"∾")"∾˜FmtErr+´⌾(×˜)∾p poly._fn¨𝕏p}⎊"!"
  (m⊸∾¨ roots) •Out∘(Err∾˜52↑L⟜({𝕏•_timed p}⎊"!"))¨ rfns
}¨ sizes
