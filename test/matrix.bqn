m ← •Import "../matrix.bqn"
MP‿qr‿lup‿cholesky ← m

TestDecomp ← {⟨Decompose,Verify,Compose,Inverse,Solve⟩ 𝕊 m:
  tol ← 1e¯12
  Verify d ← Decompose m
  ! tol ≥ ⌈´⥊ | m - Compose d
  ! tol ≥ ⌈´⥊ | (=⌜´↕¨≢𝕩) - (Inverse d) MP m
  ! tol ≥ ⌈´⥊ | (⊢ - m MP d Solve ⊢) ⌽↕≠m
}
qr  TestDecomp 6‿6⥊4‿1‿2‿5‿0‿3‿6
lup TestDecomp 6‿6⥊4‿1‿2‿5‿0‿3‿6
cholesky TestDecomp 4‿12‿¯16∾12‿37‿¯43≍¯16‿¯43‿98

•Out "All passed!"
