m ← •Import "../matrix.bqn"
MP‿qr‿lup‿cholesky‿symmetric_eigen‿svd‿real_schur‿Determinant‿Eigenvalues‿CharPoly ← m

TestDecomp ← {⟨Decompose,Verify,Compose,Inverse,Solve⟩ 𝕊 m:
  tol ← 1e¯12
  Verify d ← Decompose m
  ! tol ≥ ⌈´⥊ | m - Compose d
  ! tol ≥ ⌈´⥊ | (=⌜˜↕⊢´≢m) - (Inverse d) MP m
  ! tol ≥ ⌈´⥊ | (⊢ - m MP d Solve ⊢) ⌽↕≠m
}
qr  TestDecomp 6‿6⥊4‿1‿2‿5‿0‿3‿6
lup TestDecomp 6‿6⥊4‿1‿2‿5‿0‿3‿6
cholesky TestDecomp [4‿12‿¯16,12‿37‿¯43,¯16‿¯43‿98]
symmetric_eigen TestDecomp ⍉⊸+ 6‿6⥊4‿1‿2‿5‿0‿3‿6
svd TestDecomp 6‿6⥊4‿1‿2‿5‿0‿3‿6

TestNoInv ← {⟨Decompose,Verify,Compose⟩ 𝕊 m:
  Verify d ← Decompose m
  ! 1e¯12 ≥ ⌈´⥊ | m - Compose d
}
real_schur TestNoInv 6‿6⥊4‿1‿2‿5‿0‿3‿6

! 0 ≡ Determinant ⥊⟜(↕×´)9‿9
! ∧´ 1e¯10 > | 1‿2‿3 - ∧ Eigenvalues [¯149‿¯50‿¯154,537‿180‿546,¯27‿¯9‿¯25]
! 1‿¯10‿4‿¯40 ≡ CharPoly [3‿1‿5,3‿3‿1,4‿6‿4]

•Out "All passed!"
