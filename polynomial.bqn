⟨
  Trim, Add, Sub, Mul
  Derivative, Integral
  Eval, _fn
  LaguerreRoots, AberthRoots, WeierstrassRoots
⟩⇐

# Arithmetic for real polynomials
Trim ← (∨`⌾⌽0⊸≠)⊸/
Add  ← +´ ((⌈´≠¨)↑¨⊢)⊘(⌈○≠↑¨⋈)  # Like +´⊘+
Sub  ← -´ ⌈○≠ ↑¨ ⋈
Mul  ← +´¨ +⌜○(↕≠) ⊔ ×⌜

Derivative ← 1 ↓ ↕∘≠⊸×
Integral   ← {𝕊:(<𝕨⊣0)∾𝕩÷1+↕≠𝕩; 𝕊⁼:Derivative𝕩}

_while_ ← {𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}

complex ← {
  M ⇐ -´∘×⋈+´∘×⟜⌽
  D ⇐ (-⌾(1⊸⊑) ÷ +˝∘(×˜)){𝔽⊘(M⟜𝔽)}
  A2⇐ +´∘×˜
  A ⇐ √A2
  Sqrt ⇐ { 0<m←A𝕩 ? s‿t←0>a‿b←𝕩 ⋄ -⍟t∘⌽⍟s (÷⟜2⋈b⊸÷) √2×m+|a ; 0‿0 }
  ExpI ⇐ •math.Sin⋈•math.Cos
  _poly ⇐ {+⟜(𝕩⊸M)´𝕗}
  _polyd_ ⇐ {(𝕘‿2⥊0) (»+𝕩⊸M˘∘⊢)´ 𝕗}
  _polyd_ek_ ⇐ {
    ek←0 ⋄ ax←A𝕩
    v ← (𝕘‿2⥊0) {ek↩(A⊏𝕩)+ax×ek⋄𝕩}∘(»+𝕩⊸M˘∘⊢)´ 𝕗
    v‿ek
  }
}
CPoly ← ⋈⟜0⍟(0==)¨

# Evaluate polynomial
_fn ← {(CPoly𝕗)complex._poly}
Eval ← {𝕨_fn 𝕩}

# Analytical solutions to low-order polynomials
exact ← {
  M‿D‿Sqrt‿ExpI ← complex
  Low ← !∘"Input must have degree at least 1"
  Lin ← ⋈·-∘D´⊢
  Quad ← { 𝕨 𝕊 c‿b‿a:
    b ÷↩ ¯2
    0‿0⊸≢◶⟨⋈˜,c⊸D⋈D⟜a⟩ b(0≤+´∘×)◶⟨+,-⟩ Sqrt (M˜b) - a M c
  }
  cru ← [2‿¯1‿¯1, 0‿1‿¯1×√3]÷2     # cube roots of unity
  RealCub ← {
    r‿q‿p ← ÷⟜3⌾(1⊸↓) ¯1 (↓÷⊑) 𝕩
    a ← q-×˜p ⋄ b ← (r-p×q+2×a)÷2  # depressed coefficients
    d ← (×˜b) + ×˜⊸×a              # discriminant
    {
      d>0 ? -⟜p⊸(⋈¨)˝ cru × (+⋈-)´ •math.Cbrt (-b)(+⋈-)√d ;
      ⋈⟜0¨ p-˜ cru +˝∘× (2×√-a) × ExpI 3 ÷˜ (√-d) •math.Atan2 b
    }
  }
  _with ⇐ {(5⌊≠∘⊢)◶Low‿Low‿Lin‿Quad‿((∨´0≠⊢´¨)◶(RealCub⊑¨)‿𝔽)‿𝔽}
}

# Starting points based on Rouche's theorem, Bini 1996
RoucheInit ← {
  a ← complex.A¨ 𝕩
  # Convex hull of points sorted by x
  CH ← 0⊸↑{𝕨∾˜¯1⊸↓_while_((2<≠)◶⟨0,>´·×⟜⌽˝𝕨(«-⊢)¯2↑⊢⟩)𝕩}˝⌽
  k ← ⊏˘ CH (↕∘≠≍˘⊢) ⋆⁼ a
  e ← ((≠a)÷˜↕1-˜≠k) + ↕⊸÷¨1↓-⟜»k  # Angles
  uk ← ¯1↓(«⊸-k)√÷⟜«k⊏a            # Magnitudes
  (∾ uk⊸×)¨ complex.ExpI (2×π)×e
}

# Return all complex roots of little-endian polynomial 𝕩, using
# simultaneous root-finding methods
# 𝕨 gives the number of iterations
# Result is a list of real‿imag pairs
_allRoots_ ← { GetStep _𝕣_ deriv:
  M‿D‿A2‿_polyd_ek_ ← complex
  max_iter ← 100
  {
    eps  ← 𝕨⊣1e¯16
    step ← GetStep n ← 1-˜≠𝕩
    Poly ← (M¨⟜(D¨¯1⊸⊏)𝕩) _polyd_ek_ deriv
    r ← RoucheInit 𝕩
    i ← 0
    ⊢_while_ {𝕤
      p‿ek ← Poly r
      ∨´ (eps × ×˜ek) ≤ A2 ⊏p ?
      r Step˜↩ p
      "Failed to converge" ! max_iter > i+↩1
      1;0
    }@
    <˘⍉> r
  }exact._with {𝕨𝔽CPoly𝕩}
}
⟨WeierstrassRoots⇐WR, AberthRoots⇐AR⟩ ← {
  M‿D ← complex
  WR ⇐ { ⊢ - ⊏ ⊸  D       ⟜(M˝·⍉(1‿0×⌜=⟜<↕𝕩)+·><⊸-¨)  } _allRoots_ 1
  AR ⇐ { ⊢ - D˝⊸(⊣D 1‿0+M)⟜(¯1‿0+˝¨(⋈⟜0=⌜˜↕𝕩)D∘+-⌜˜¨) } _allRoots_ 2
}

# Find a root of the given polynomial with Laguerre's method
_laguerre_ ← {poly _𝕣_ eps root:
  M‿D‿A‿A2‿Sqrt‿ExpI‿_polyd_ek_ ← complex
  Jump ← (•MakeRand 1).Range∘0 ⋄ jump_i ← 10

  nk2 ← 2 ÷ nrn ← ¬ rn ← ÷ 1-˜≠poly
  F ← (CPoly poly) _polyd_ek_ 3
  max_iter ← 200
  i ← 0
  ⊢_while_ {𝕤
    i < max_iter ?
    ⟨p‿dp‿d2p_h, ek⟩ ← <˘⌾⊑ F root
    0 < a2p ← A2 p ?
    crit ← eps × ×˜ek  # Square of stopping criterion
    stop ← { a2p ≥      crit ? 0   # keep going
           ; a2p ≥ 0.01×crit ? 1   # finish this iteration, then stop
           ;                   2 } # return immediately
    2 > stop ?
    dx ← {
      # Division by zero: jump in random direction
      0‿0 ≡ dp ? (1 + A root) × ExpI (2×π) × Jump i ;
      # Otherwise, Laguerre step
      fac ← p‿d2p_h M¨ <D dp
      (⊑fac) D rn‿0 + nrn × -⍟(0>⊑) Sqrt 1‿0 - nk2 × M´ fac
    }
    (root -↩ dx) ≢ root ?
    ¬stop ?
    i+↩1
    # Randomly reduce length every few steps
    { 0=jump_i|i ? root +↩ dx × Jump i÷jump_i ;@}
    1;0
  }@
  root
}

# Find all roots, with linear/quadratic formulas and Laguerre
_laguerreRootsPolish ← {
  eps ← 𝕨⊣1e¯16
  ⟨M⟩ ← complex
  Solve ← {
    root ← 𝕩 _laguerre_ eps 0‿0
    root <⊸∾ Solve M⟜root⊸+`⌾⌽ 1↓𝕩
  } exact._with
  {𝕨 _laguerre_ eps¨⌾(1⊸↓) 𝕩}⍟𝕗⟜Solve exact._with CPoly 𝕩
}
LaguerreRoots ← 1 _laguerreRootsPolish
