⟨
  MP, H, Trace, Determinant
  Inverse, Solve, Eigenvalues, CharPoly
  lTri, uTri, qr, lup, cholesky
⟩⇐

MP ← +˝∘×⎉1‿∞  # matrix product
H  ← +⍉        # conjugate transpose
Di ← 0‿0⍉⊢     # diagonal

Trace ← +´Di

# Lower (l←1) or upper (l←0) triangular matrix
LUTri ← {𝕊 l:
  Verify ⇐ (l⊑>‿<){
    ! 2==𝕩
    ! ∧´⥊ (𝕩=0) ≥ 𝔽⌜´↕¨≢𝕩
  }
  Determinant ⇐ ×´Di
  # Inverse by recursive blocking
  p‿c ← {𝕏˜}¨⍟l ⋈‿≍
  Inverse ⇐ {
    1≥≠𝕩 ? ÷𝕩 ;
    l ← ≠𝕩
    m ← ⌈l÷2
    ai‿di ← Inverse¨ m‿m(↑P↓)𝕩
    b ← (m P m-l)↑𝕩
    x ← - ai MP b MP di
    z ← 0 ⥊˜ (l-m) P m
    ∾ (ai P x) C (z P di)
  }
  # Forward or backward substitution
  s←¯1⋆¬l ⋄ j←l-1 ⋄ rev ← l⊑{𝔽⌾⌽}‿{𝔽}
  Solve ⇐ { t 𝕊 b:
    ! t=○≠b
    >{
      new←b÷○(j⊸⊏)𝕩
      b↩b-⟜(×⌜⟜new)○(s⊸↓)𝕩
      new
    }¨∘((s×↕∘≠)↓¨⊢)_rev <˘⍉t
  }
}
uTri‿lTri ←  LUTri¨ ↕2

# LU decomposition with pivoting
lup ← {
  Compose ⇐ { 𝕊 p‿l‿u: p⊸⊏˘ l MP u }
  Verify ⇐ { 𝕊 p‿l‿u:
    ! ≤´ m‿n ← ≢u
    ! n‿n ≡ ≢l
    ! (∧p) ≡ ↕n
    uTri.Verify u
    lTri.Verify l
    ! ∧´ 1 = Di l
  }
  Inverse ⇐ { 𝕊 p‿l‿u: (⍋p) ⊏ (uTri.Inverse u) MP lTri.Inverse l }
  Solve ⇐ { p‿l‿u 𝕊 𝕩: (⍋p) ⊏ u uTri.Solve l lTri.Solve 𝕩 }
  Determinant ⇐ { 𝕊 p‿l‿u:
    s ← ¯1⋆+´∾(≠↑↑)⊸>p  # Sign of permutation
    s × uTri.Determinant u
  }

  # Recursive method
  Decompose ⇐ (0<≠)◶{ ⟨↕¯1⊑≢𝕩 , 0‿0⥊0 , 𝕩⟩ }‿{ LU:
    1<m ⊣ m‿n ← ≢𝕩 ?
    m2 ← ⌈m÷2 ⋄ S ← m2(↑⋈↓)⊢
    a1‿a2 ← S𝕩
    p1‿l1‿u1 ← LU a1
    g1‿g2 ← S⍋p1
    fe1← (g1⊸⊏˘ a2) MP uTri.Inverse m2 ↑˘ u1
    g  ← (g2⊸⊏˘ a2) -        fe1 MP m2 ↓˘ u1
    p2‿l2‿u2 ← LU g
    p3 ← m2(↕∘⊣∾+)p2
    h  ← (⍋p3)⊸⊏˘ u1
    z  ← m2‿(m-m2)⥊0
    ⟨ p1⊏p3 , ∾l1‿z≍fe1‿l2 , h∾(-n)↑˘u2 ⟩
  ;
    p ← ((≠v)|+´∧`0=v) {⌽⌾(0‿𝕨⊸⊏)𝕩}⍟(0<⊣) ↕≠v←⥊𝕩
    ⟨p , ≍≍1 , ≍p⊏v⟩
  }
}

# QR decomposition
qr ← {
  Compose ⇐ MP´
  Verify ⇐ { 𝕊 q‿r:
    ! ∧´2==¨𝕩
    ! ∧´≥‿={𝕎´≢𝕩}¨𝕩
    uTri.Verify r
    ! ∧´ ⥊ 5e¯14≥| (=⌜´↕¨∘≢)⊸- H⊸MP q
  }
  Inverse ⇐ uTri.Inverse⊸MP⟜H˜´
  Solve ⇐ { q‿r 𝕊 b: r uTri.Solve (H q) MP b }
  AbsDeterminant ⇐ { 𝕊 q‿r: | uTri.Determinant r }

  # Recursive Gram-Schmidt
  Decompose ⇐ {
    !2==𝕩 ⋄ !≥´≢𝕩
    {QR: 1<n←¯1⊑≢𝕩 ?
      m ←⌈n÷2
      a0←m↑˘𝕩
      a1←m↓˘𝕩
      q0‿r0←QR a0
      q1‿r1←QR a1 - q0 MP t ← q0 H⊸MP a1
      ⟨q0∾˘q1 , (r0∾˘t)∾(-n)↑˘r1⟩
    ;
      𝕩 (÷⟜⊑ ⋈ ⊢) √ H⊸MP 𝕩
    }𝕩
  }

  # Householder reflections: slower; more stable
  DecomposeHH ⇐ { 𝕊 a:
    m‿n←≢a
    q←=⌜˜↕m
    Step ← {𝕊k:
      nz ← +´∘|⌾(×˜) z ← ⟨k+↕m-k,<k⟩⊏a
      v ← -(nz××)⊸+⌾⊏z
      v2 ← 2 × (+v) ÷ nv←+´|×˜v
      nv≥×˜2⋆¯52 ? a‿q -⟜((m-⊸↑v) ×⌜ v2 +˝∘× (-≠v)⊸↑)¨↩ ; @
    }
    Step¨ ↕n
    ⟨H q, a×m≤⌜○↕n⟩
  }
}

# Cholesky decomposition
cholesky ← {
  Verify ⇐ lTri.Verify
  Compose ⇐ MP⟜H
  Inverse ⇐ H⊸MP lTri.Inverse
  Solve ⇐ H∘⊣ uTri.Solve lTri.Solve
  Determinant ⇐ ×˜ lTri.Determinant
  Decompose ⇐ { 1<n←≠𝕩 ?
    m ← ⌈n÷2 ⋄ d←m-n
    x‿y‿z ← ⟨m‿m,m‿d,d‿d⟩ ↑¨ <𝕩
    l0 ← 𝕊 x
    l1 ← 𝕊 z - (t←H ly) MP ly ← l0 lTri.Solve y
    ∾ ⟨l0,⟨m,-d⟩⥊0⟩≍⟨t,l1⟩
  ;
    ! 0<⊑𝕩
    √𝕩
  }
}

# Default implementations
Inverse ← qr.Inverse qr.Decompose
Solve ← qr.Decompose ⊸ qr.Solve
Determinant ← (⊢×=∧3⊸≥)´∘≢◶⟨
  lup.Determinant lup.Decompose
  ⊑                     # 1×1
  -´×⟜⌽˝                # 2×2
  +´(↕3)(×˝⌽˘){𝔽--⊸𝔽}⊢  # 3×3
⟩

# List of eigenvalues of 𝕩
# QR algorithm with Hessenberg reduction and Wilkinson shifts
# Returns NaNs or fails to converge if there are complex eigenvalues
Eigenvalues ← {
  Norm ← +´⌾(×˜)
  # Return a Hessenberg matrix (0⊸≠<1≥-⌜˜∘↕∘≠) similar to 𝕩
  Hessenberg ← {
    v ← (-≠𝕩) ↑ {((Norm𝕩)×¯1⋆<⟜0)⊸+⌾⊑ 𝕩} (1+𝕨)↓𝕨⊏˘𝕩
    # Multiply on both sides by symmetric orthogonal matrix id-2×u×⌜u
    # where u ← v÷Norm v
    v2 ← 2 × v ÷ +´×˜v
    (⊢-v×⌜v2+˝∘×⊢) (⊢-v×⌜˜+˝∘×⟜v2˘) 𝕩
  }´⟜(⌽∘↕0⌈≠-2˙)

  # Shift based on eigenvalues of a symmetric matrix
  WilkinsonShift ← { 𝕊a‿·‿b‿c:
    d ← 2÷˜a-c ⋄ b2 ← ×˜b
    c - b2 0⊸≠◶0‿÷ d + (×d) × b2⊸+⌾(×˜)d
  }

  # Obtain r MP q, where 𝕩≡q MP r is a QR decomposition
  QRev ← {𝕊a:
    Giv ← { ≍⟜(-⌾⊑⌽) ÷⟜Norm ⟨𝕨+↕2,<𝕨⟩⊏𝕩 }  # Givens rotation matrix, transposed
    n ← ≠𝕩
    i←⥊⟜(↕×´)2‿n  # First two rows
    gs ← { g←𝕩 Giv a ⋄ a g⊸MP⌾(i⊏⥊)↩ ⋄ i↓˜↩0‿1⋄i+↩n ⋄ g }¨ ↕n-1
    i↩≍¯1‿0 ⋄ a { i+↩1⋄i∾↩n+¯1↑i ⋄ MP⟜(⍉𝕨)⌾(i⊏⥊)𝕩 }´ ⌽gs
  }

  # Get one eigenvalue with QR
  _while_ ← {𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}
  QRAlg ← {
    mu ← WilkinsonShift ⥊¯2‿¯2↑𝕩
    QRev⌾(-⟜(mu×=⌜˜↕≠𝕩)) 𝕩
  }_while_(1e¯10 < ·|¯1‿¯2⊸⊑)

  { 1≥≠𝕩 ? 1⥊𝕩 ; ¯1‿¯1 (𝕊∘↓∾˜⊑) QRAlg 𝕩 } Hessenberg 𝕩
}

# Faddeev-LeVerrier algorithm
CharPoly ← {
  !2==𝕩 ⋄ !=´≢𝕩
  id←=⌜˜↕n←≠𝕩
  c←-Trace m←m0←𝕩
  1‿c ∾ c { Trace m ↩ m0 MP m+𝕩×id }⊸÷` -2+↕n-1
}
