⟨_line⟩ ← •Import "util.bqn"
mat ← •Import "../matrix.bqn"

decomps ← ⟨
  "LUp "‿mat.lup, "QR "‿mat.qr, "SVD"‿mat.svd
  "Cholesky "‿mat.cholesky, "Symmetric eigen"‿mat.symmetric_eigen
⟩
ops ← ⟨
  "Trace of"                    ‿mat.Trace
  "Determinant of"              ‿mat.Determinant
  "Invert"                      ‿mat.Inverse
  "Characteristic polynomial of"‿mat.CharPoly
  "Eigenvalues of"              ‿mat.Eigenvalues
⟩
ops ∾↩ (⟨∾⟜" of"∾⟜"decomposition"⍟('D'≠⊢´),{𝕩.Decompose}⟩{𝕎𝕩}¨⊢)¨ decomps
opid ← (+⟜(32×1="A["⊸⍋)3↑⊑)¨ ops
[mid,mats] ← ⍉[
  "r100"‿⟨"random 100×100",   -⟜¬ 100 ⋈˜⊸•rand.Range 0⟩
  "s100"‿⟨"100×100", ⍉⊸mat.MP -⟜¬ 100 ⋈˜⊸•rand.Range 0⟩
  "r50" ‿⟨"random 50×50",     -⟜¬  50 ⋈˜⊸•rand.Range 0⟩
  "s50" ‿⟨"50×50",   ⍉⊸mat.MP -⟜¬  50 ⋈˜⊸•rand.Range 0⟩
  "e50" ‿⟨"diagonal-ish 50×50", {((2⊸+×=⌜˜)↕𝕩)+2+⥊⟜(↕×´)⋈˜𝕩} 50⟩
]

I ← <˘⍉∘>
Bench ← { •Out (∾⟜" "⊸∾´𝕨) 44 _line {10 𝕎•_timed 𝕩}´𝕩 }
Bench´∘I¨ (ops‿mats⊏˜¨opid‿mid⊐¨⊢)⌾I ⟨
  "tra"‿"r100"
  "det"‿"r100"
  "inv"‿"r100"
  "lup"‿"r100"
  "qr "‿"r100"
  "cho"‿"s100"
  "svd"‿"r50"
  "cha"‿"r50"
  "eig"‿"e50"
  "sym"‿"s50"
⟩
