⟨
  MP, H
  uTri, qr
  Inverse
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
  Inverse ⇐ uTri.Inverse⊸MP⟜H˜´
}

# Default matrix inverse
Inverse ⇐ qr.Inverse qr.Decompose
