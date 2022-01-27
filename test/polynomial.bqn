p ← •Import "../polynomial.bqn"
_fn‿LaguerreRoots‿AberthRoots‿WeierstrassRoots ← p

! 27‿0 ≡ 0‿0‿0‿1 _fn 3‿0

TestRoots ← {𝕊 roots:
  tol ← 1e¯8
  ! 0∘Roots⎊1 ⟨⟩
  ! 0∘Roots⎊1 ⟨1⟩
  ! ⟨2‿0,2‿0⟩ ≡ Roots 4‿¯4‿1
  Chk ← { ! (𝕨⊣tol) ≥ ⌈´ +´⌾(×˜)∘(𝕩_fn)¨ Roots 𝕩 }
  Chk 4‿3‿2‿1
  Chk ⟨2‿3,1‿0,5‿9,5‿2,3‿0⟩
  1e¯6 Chk 1|π⋆2+↕10
}
TestRoots¨ LaguerreRoots‿AberthRoots‿WeierstrassRoots

•Out "All passed!"
