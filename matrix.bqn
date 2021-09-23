⟨
  MP, H
  uTri, qr
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
      bp‿bi←i(↑≍○<⊏)b
      lp‿li←i(↑≍○<⊏)𝕩
      b↩bp-lp×⌜new←bi÷li
      new
    }¨⌾⌽ <˘⍉u
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
      a (÷⟜⊑ ≍○< ⊢) √ H⊸MP a
    }‿{𝕤
      m ←⌈n÷2
      a0←m↑˘a
      a1←m↓˘a
      q0‿r0←QR a0
      q1‿r1←QR a1 - q0 MP t ← q0 H⊸MP a1
      ⟨q0∾˘q1 , (r0∾˘t)∾(-n)↑˘r1⟩
    }@
  }

  # QR decomposition using Householder reflections.
  DecomposeHH ⇐ { 𝕊 a:
    m‿n←≢a
    q←=⌜˜↕m
    Step ← {𝕊k:
      i←k+↕m-k ⋄ _col←{⟨i,<𝕗⟩⊸⊏}
      Norm←+˝∘|⌾(×˜)
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
