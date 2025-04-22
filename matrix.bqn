⟨
  MP, H, Trace, Determinant
  Inverse, Solve, Eigenvalues, CharPoly
  lTri, uTri, qr, lup, cholesky, symmetric_eigen, svd
⟩⇐

MP ← +˝∘×⎉1‿∞  # matrix product
H  ← +⍉        # conjugate transpose
Di ← 0‿0⍉⊢     # diagonal
_while_ ← {𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}

Trace ← +´Di

# Lower (l←1) or upper (l←0) triangular matrix
LUTri ← {𝕊 l:
  Verify ⇐ (l⊑>‿<){
    ! 2==𝕩
    ! ∧´⥊ (𝕩=0) ≥ 𝔽⌜´↕¨≢𝕩
  }
  Determinant ⇐ (∧´0⊸≠)◶⟨0,×´⟩Di  # Might contain ∞ or NaN
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
    ! m‿m ≡ ≢l
    ! (∧p) ≡ ↕n
    uTri.Verify u
    lTri.Verify l
    ! ∧´ 1 = Di l
  }
  Inverse ⇐ { 𝕊 p‿l‿u: p ⊏ u uTri.Solve lTri.Inverse l }
  Solve ⇐ { p‿l‿u 𝕊 𝕩: p ⊏ u uTri.Solve l lTri.Solve 𝕩 }
  Determinant ⇐ { 𝕊 p‿l‿u:
    s ← ¯1⋆+´∾(≠↑↑)⊸>p  # Sign of permutation
    s × uTri.Determinant u
  }

  Decompose ⇐ {
    1 ≥ ≠𝕩 ? ⟨↕¯1⊑≢𝕩, 1⥊˜⋈˜≠𝕩, 𝕩⟩ ;
    m‿n←≢a←𝕩
    [i,lc,d,ur] ← ⍉>{𝕊:
      i ← ⊑⊐⟜(⌈´)|r0←⊏a  # Pivot
      d ← ⟨i-n-𝕩,i+1⟩    # Drop amounts to cut out i
      a00‿a10 ← (⊑⋈1⊸↓) i⊏˘a
      a01 ← ∾↓⟜r0¨d
      a ↩ (∾˘´(1⊸⋈↓a˙)¨d) - (cn←a10÷0⊸=⊸+a00)×⌜a01
      i‿cn‿a00‿a01
    }¨ ↕m-1
    p ← ((<↕n¬m)(⊣∾{𝕩∾𝕩⊸≤⊸+𝕨}`)⊢)⌾⌽ i
    l ← ⍉> (-m)↑¨1∾¨lc∾<↕0
    u ←  > (-n)↑¨(d∾¨(1↓p)⊏¨ur)∾<⥊a
    ⟨⍋⊑p, l, u⟩
  }

  # Recursive method, can return NaN for singular matrices
  DecomposeNonSingular ⇐ (0<≠)◶{ ⟨↕¯1⊑≢𝕩 , 0‿0⥊0 , 𝕩⟩ }‿{ LU:
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

# Default implementations
Inverse ← qr.Inverse qr.Decompose
Solve ← qr.Decompose ⊸ qr.Solve
Determinant ← (⊢×=∧3⊸≥)´∘≢◶⟨
  lup.Determinant lup.Decompose
  ⊑                     # 1×1
  -´×⟜⌽˝                # 2×2
  +´(↕3)(×˝⌽˘){𝔽--⊸𝔽}⊢  # 3×3
⟩

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

# Faddeev-LeVerrier algorithm
CharPoly ← {
  !2==𝕩 ⋄ !=´≢𝕩
  id←=⌜˜↕n←≠𝕩
  c←-Trace m←m0←𝕩
  1‿c ∾ c { Trace m ↩ m0 MP m+𝕩×id }⊸÷` -2+↕n-1
}

# Shared code for one-sided or two-sided parallel Jacobi method
_JacobiSweep ← { n‿GetSubmats‿_applyRot _𝕣:
  # Diagonalize each pair j, j⊑i with a rotation
  # Duplicates the arithmetic for sin and cos but it vectorizes well
  Layer ← { 𝕊 i:
    off‿diag ← GetSubmats i  # ⟨𝕩⊏˘m, Di m⟩ to diagonalize symmetric m
    # Required rotation is determined by the ratio u÷p
    d ← ×i-↕n
    p ← (2 × d≠0) × off         # Force to 0 for non-pairs d=0
    u ← (d × i⊸⊏⊸- diag) ⋆ p≠0  # Must be nonzero if p=0
    t ← 2 × v ← p +⌾(×˜) u
    cos ← √(v+|u)÷t
    sin ← (d×¯1⋆u<0) × p÷t×cos
    (cos⊸× - sin×i⊸⊏)_applyRot
    @
  }
  # A sweep hits each (unordered) pair of distinct indices once
  r ← ⌽↕p ← n-¬2|n
  {𝕊:
    2|n? (Layer⌽⟜r)¨ r;
    (p|(n÷2)×↕p) {Layer 𝕨∾˜p⌾(𝕨⊸⊑) 𝕩⌽r}¨ r
  }
}
# Diagonalize symmetric m with two-sided rotations
_Jacobi2 ← { rotQ _𝕣 m:
  n ← ≠m
  GetSubmats ← { ⟨𝕩⊏˘m, Di m⟩ }
  _applyRot ← { m (𝔽 𝔽⌾⍉)↩ ⋄ 𝔽 _rotQ }
  Sweep ← n‿GetSubmats‿_applyRot _JacobiSweep
  # Norm +´×˜⥊m stays constant; stop when off-diagonal part is small
  end ← (×˜1e¯14) × +´×˜⥊m
  Sweep _while_ {𝕊: end < +´×˜ (<⌜˜↕n)/○⥊m} @
  # Return eigenvalues
  Di m
}
# No eigenvectors, slightly faster than symmetric_eigen.Decompose
# Eigenvalues_Symmetric ← { !2==𝕩 ⋄ !=´≢𝕩 ⋄ ∨ {˙}_Jacobi2 𝕩 }

# Eigendecomposition of symmetric matrix: eigenvalues, eigenvectors as rows
symmetric_eigen ← {
  Compose ⇐ { 𝕊 d‿q: q H⊸MP d × q }
  Verify ⇐ { 𝕊 d‿q:
    !2==q ⋄ !=´≢q
    !1==d ⋄ ! d =○≠ q
    ! ∧´ ⥊ 5e¯14≥| (=⌜´↕¨∘≢)⊸- H⊸MP q  # Unitary
  }
  Inverse ⇐ Compose ÷⌾⊑
  Solve ⇐ { d‿q 𝕊 b: q H⊸MP d ÷˜ q MP b }
  Determinant ⇐ { 𝕊 d‿·: ×´d }
  # Parallel Jacobi method
  Decompose ⇐ {
    !2==𝕩 ⋄ !=´≢𝕩
    q ← =⌜˜↕≠𝕩               # Eigenvectors
    d ← {{q 𝔽↩}} _Jacobi2 𝕩  # Eigenvalues
    (⍒d)⊸⊏¨ d‿q
  }
}

# Singular Value Decomposition (compact shapes)
svd ← {
  Compose ⇐ { 𝕊 u‿d‿v: {u≥○≠v?  u MP  d  ×  v ;
                               (u ×⎉1 d) MP v } }
  Verify ⇐ { 𝕊 u‿d‿v:
    !1==d
    {
      !2==𝕩 ⋄ !≤´≢𝕩 ⋄ !d=○≠𝕩
      ! ∧´ ⥊ 5e¯14≥| (=⌜´↕¨∘≢)⊸- MP⟜⍉ 𝕩
    }¨ ⟨⍉u, v⟩
  }
  Inverse ⇐ Compose H‿÷‿H {𝕎𝕩}¨ ⌽
  Solve ⇐ { u‿d‿v 𝕊 b: v H⊸MP d ÷˜ u H⊸MP b }
  AbsDeterminant ⇐ { 𝕊 ·‿d‿·: ×´d }
  # Parallel Jacobi method
  Decompose ⇐ {
    !2==𝕩
    # Arrange the rows to be longer for faster computation
    tr ← >´≢𝕩
    m ← ⍉⍟tr 𝕩
    # Symmetric eigendecomposition of MP⟜⍉ m
    # We maintain m throughout with one-sided rotations
    q ← =⌜˜↕n←≠m  # Left-singular vectors (as rows)
    GetSubmats ← { ⟨+˝˘m×𝕩⊏m, +˝˘×˜m⟩ }
    _applyRot ← { m 𝔽↩ ⋄ q 𝔽↩ }
    Sweep ← n‿GetSubmats‿_applyRot _JacobiSweep
    # Stopping criterion from Demmel and Veselić 1992
    Sweep _while_ {𝕊: a←MP⟜⍉m ⋄ ∨´⥊ (<⌜˜↕n) ∧ (|a) > ×⌜˜√1e¯14×Di a} @
    # Arrange as decomposition
    d ← +˝˘⌾(×˜) m  # Singular values
    ⍉⌾⊑ ⌽⍟tr (⍒d)⊸⊏¨ ⟨q, d, m÷d⟩
  }
}

# List of eigenvalues of 𝕩; each complex one is returned as real‿imag
# Implicit QR algorithm with double shifts
Eigenvalues ← {
  !2==𝕩 ⋄ !=´≢𝕩 ⋄ !1≤≠𝕩
  # 2×2 trace + determinant, and eigenvalues
  TrDet ← Trace ⋈ ·-´×⟜⌽˝
  Eig2 ← { b‿c←TrDet 𝕩 ⋄ b÷↩2 ⋄ b (0≤s)◶⟨⋈¨,+⟩ -⊸⋈√|s←(×˜b)-c }

  # Householder reflection HH𝕩 sends 𝕩 to a multiple of 𝕩≠⊸↑1
  HH ← {
    S ← (+´×˜1↓𝕩)+×˜
    vd ← (2÷·0⊸=⊸+S∘⊑)⊸× v ← (√∘S×¯1⋆<⟜0)⊸+⌾⊑ 𝕩
    ⟨⊢-vd×⌜v+˝∘×⊢, ⊢-vd×⌜˜+˝∘×⟜v˘⟩  # Left and right applications
  }

  # Return a Hessenberg matrix (satisfies 0⊸≠<1≥-⌜˜∘↕∘≠) similar to 𝕩
  Hessenberg ← {
    # Reflect to zero out column 𝕨⊏˘𝕩 below row 1+𝕨
    Dr ← (1+𝕨)⊸↓
    HL‿HR ← HH 𝕨⊏˘Dr 𝕩 ⋄ HL⌾Dr HR⌾(Dr˘) 𝕩
  }´⟜(⌽∘↕0⌈≠-2˙)

  # Double QR step with eigenvalues of ¯2‿¯2↑𝕩 as shifts
  Step ← {𝕊a:
    # First column determines the result, use c to construct it
    s‿t ← TrDet ¯2‿¯2↑a
    l ← 1‿0 ⊑ h ← 2‿2↑a
    c ← ⟨t + +´⟨s-˜⊑h,l⟩×⊏h⟩ ∾ l × ⟨s-˜Trace h, 2‿1⊑a⟩
    # After reflecting by c we do the same reduction as Hessenberg,
    # but entries more than 2 below the diagonal will always be 0
    n ← ≠a  # ≥3
    j ← 3↑˘ i ← ⥊⟜(↕×´)3‿n
    Refl ← { HL‿HR ← HH 𝕩 ⋄ a (HL⌾(i⊏⥊) HR⌾(j⊏⥊))↩ }
    ReflJ ← { j∾↩n+j↑˜-n>≠j ⋄ Refl 𝕩 } # Extend j first
    ReflJ c
    { i+↩n⋄j+↩1 ⋄ ReflJ 𝕩 ⊏˘ 3↑(𝕩+1)↓a ⋄ i↓˘˜↩1 }¨ ↕n-3
    i↓˜↩1⋄j↓˘˜↩1 ⋄ Refl (n-3) ⊏˘ ¯2↑a
    a
  }

  # Split into irreducible components; implicit QR requires these
  Break ← {
    sd ← ((1-˜1⊸+×1↓↕)≠𝕩)⊏⥊𝕩             # Subdiagonal
    z ← (|sd) ≤ 1e¯14 × 1 (↓+-⊸↓)| Di 𝕩  # Mask of near-zero
    (⋈˜⊏𝕩˙)¨ ⊔ +`0∾z
  }

  Decompose ← {∾𝕊⍟(2<≠∘⊑)∘⋈¨ Break∘Step∘⊑_while_(1=≠) 𝕩}
  ∾ (1<≠)◶⊏‿Eig2¨ Decompose⍟(2<≠𝕩) Break Hessenberg 𝕩
}
