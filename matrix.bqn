⟨
  MP, H
  uTri, qr, lup
  Inverse
  Solve
⟩⇐

MP ← +˝∘×⎉1‿∞  # matrix product
H  ← +⍉        # conjugate transpose

uTri ← {
  Verify ⇐ {
    ! 2==𝕩
    ! ∧´⥊ (𝕩=0) ≥ >⌜´↕¨≢𝕩
  }
  Inverse ⇐ (1<≠)◶÷‿{
    l ← ≠𝕩
    m ← ⌈l÷2
    ai‿di ← Inverse¨ m‿m(↑≍○<↓)𝕩
    b ← ⟨m,m-l⟩↑𝕩
    x ← - ai MP b MP di
    z ← 0 ⥊˜ ⟨l-m,m⟩
    ∾ ai‿x ≍ z‿di
  }
  Solve ⇐ { u 𝕊 b:
    ! u=○≠b
    >{
      i←1-˜≠b
      new←b÷○(i⊸⊏)𝕩
      b↩b-⟜(×⌜⟜new)○(i⊸↑)𝕩
      new
    }¨⌾⌽ <˘⍉u
  }
}
lTri ← {
  Verify ⇐ uTri.Verify ⍉
  Inverse ⇐ uTri.Inverse⌾⍉
}

lup ← {
  Compose ⇐ { 𝕊 p‿l‿u: p⊸⊏˘ l MP u }
  Verify ⇐ { 𝕊 p‿l‿u:
    ! ≤´ m‿n ← ≢u
    ! n‿n ≡ ≢l
    ! (∧p) ≡ ↕n
    uTri.Verify u
    lTri.Verify l
    ! ∧´ 1 = 0‿0⍉l
  }
  Inverse ⇐ { 𝕊 p‿l‿u: (⍋p) ⊏ (uTri.Inverse u) MP lTri.Inverse l }
  Solve ⇐ { p‿l‿u 𝕊 𝕩: (⍋p) ⊏ u uTri.Solve l lTri.Solve 𝕩 }

  # Recursive method
  Decompose ⇐ LU ← (2⌊≠)◶{
    ⟨↕¯1⊑≢𝕩 , 0‿0⥊0 , 𝕩⟩
  }‿{
    p ← (+´∧`0=v) {⌽⌾(0‿𝕨⊸⊏)𝕩}⍟(0<⊣) ↕≠v←⥊𝕩
    ⟨p , ≍≍1 , ≍p⊏v⟩
  }‿{ 𝕊a:
    m‿n ← ≢a
    m2 ← ⌈m÷2
    a1‿a2 ← m2(↑≍○<↓)a
    p1‿l1‿u1 ← LU a1
    g1 ← ⍋p1
    fe1← ((m2↑g1)⊸⊏˘ a2) MP uTri.Inverse m2 ↑˘ u1
    g  ← ((m2↓g1)⊸⊏˘ a2) -        fe1 MP m2 ↓˘ u1
    p2‿l2‿u2 ← LU g
    p3 ← m2(↕∘⊣∾+)p2
    h  ← (⍋p3)⊸⊏˘ u1
    z  ← m2‿(m-m2)⥊0
    ⟨ p1⊏p3 , ∾l1‿z≍fe1‿l2 , h∾(-n)↑˘u2 ⟩
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

  # Recursive Gram-Schmidt
  Decompose ⇐ { QR a:
    !2==a ⋄ !≥´≢a
    n←⊢´≢a
    (1<n)◶{
      𝕩 (÷⟜⊑ ≍○< ⊢) √ H⊸MP 𝕩
    }‿{𝕤
      m ←⌈n÷2
      a0←m↑˘𝕩
      a1←m↓˘𝕩
      q0‿r0←QR a0
      q1‿r1←QR a1 - q0 MP t ← q0 H⊸MP a1
      ⟨q0∾˘q1 , (r0∾˘t)∾(-n)↑˘r1⟩
    }a
  }

  # Householder reflections: slower; more stable
  DecomposeHH ⇐ { 𝕊 a:
    m‿n←≢a
    q←=⌜˜↕m
    Step ← {𝕊k:
      i←k+↕m-k ⋄ ni←n×i ⋄ _col←{(𝕗+ni)⊏⥊} #{⟨i,<𝕗⟩⊸⊏}
      Norm←+´∘|⌾(×˜)
      nz←Norm z←k _col a
      nv←Norm v←-(nz××)⊸+⌾⊏z
      v÷↩nv
      HH ← {-⟜(v × 2 × (+v) +´∘× ⊢)⌾(𝕨_col) 𝕩}´⟜⌽⍟(nv≥2⋆¯52)
      a HH↩ ↕n
      q HH↩ ↕m
    }
    Step¨ ↕n
    ⟨H q, a×m≤⌜○↕n⟩
  }
}

# Default matrix inverse and solve
Inverse ← qr.Inverse qr.Decompose
Solve ← qr.Decompose ⊸ qr.Solve
