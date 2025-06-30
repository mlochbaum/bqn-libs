# Arithmetic on large natural numbers.

base ← ⊑ •args ∾ 2⋆24  # Less than half 2⋆53

_while_ ← {𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}

_extend ← { 𝕨 𝔽○((𝕨⌈○≠𝕩)⊸↑) 𝕩 }

Trim ← { 𝕩 ↑˜ -⟜1 _while_ (≥◶⟨0,0=-⊑𝕩˙⟩⟜1) ≠𝕩 }

Carry1 ← {
  g ← 𝕩 ≥ base        # Generate
  p ← 𝕩 = base-1      # Propagate
  i ← ⌈`∘×⟜(1+↕∘≠)¬p  # Start index of propagation chain
  a ← i ⊏ gs←0∾g      # Active propagations
  c ← g ∨ p ∧ a       # Carry from these positions
  r ← (𝕩 + »c) - c×base
  ⟨r, ⊢´gs⟩
}
Carry ← {
  ∧´ (0≤𝕩) ∧ (base+base-1)>𝕩 ? Carry1 𝕩 ;
  c ← ⌊𝕩÷base
  (⊑¯1↑c)⊸+⌾(1⊸⊑) 𝕊 (»c) + 𝕩-base×c
}

Add ⇐ {
  0⊸<◶⊣‿∾´ Carry1 𝕨 +_extend 𝕩
}

Sub ⇐ {
  ! 𝕨 ≥○≠ 𝕩
  s‿c ← Carry 𝕨 -_extend 𝕩
  ! 0 = c
  Trim s
}

Mul ⇐ {
  32 < n←𝕨⌊○≠𝕩 ? # Karatsuba
    k←⌊n÷2
    # Add⟜((k⥊0)⊸∾){𝔽´𝔽¨˝} 𝕨 𝕊⌜○(k⊸(↑⋈↓)) 𝕩  but one less 𝕊
    l‿h‿a ← 𝕨 𝕊¨○(∾⟜(<Add´)k⊸(↑⋈↓)) 𝕩
    Add⟜((k⥊0)⊸∾)´ ⟨l, a Sub l Add h, h⟩
  ;
  # Requires ((×˜base)×𝕨⌊○≠𝕩) ≤ 2⋆53; guaranteed by check above
  0⊸<◶⟨Trim⊣,∾⟩´ Carry (≠⊸↑˜+⊢)⟜(0⊸∾)˝ 𝕨 ×⌜ 𝕩
}

_compare ⇐ {
  Full ← 0⊸≤◶⟨𝔽˜,⊑⟜𝕨𝔽⊑⟜𝕩⟩ · -⟜1 _while_ (0⊸≤◶⟨0,⊑⟜𝕨=⊑⟜𝕩⟩) -⟜1
  𝕨 =◶𝔽‿Full○≠ 𝕩
}

Neg ⇐ (!0=≠)⊸⊢
Signum ⇐ ×∘≠
Abs ⇐ Conj ⇐ ⊢
