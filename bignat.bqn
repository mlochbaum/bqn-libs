# Arithmetic on large natural numbers.

base ← ⊑ •args ∾ 2⋆24  # Less than half 2⋆53

_while_ ← {𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}

_extend ← { 𝕨 𝔽○((𝕨⌈○≠𝕩)⊸↑) 𝕩 }

Trim ← { 𝕩 ↑˜ -⟜1 _while_ (≥◶⟨0,0=-⊑𝕩˙⟩⟜1) ≠𝕩 }

Carry ← {
  b ← 𝕨 ⊣ 0           # Carry in
  g ← 𝕩 ≥ base        # Generate
  p ← 𝕩 = base-1      # Propagate
  i ← ⌈`∘×⟜(1+↕∘≠)¬p  # Start index of propagation chain
  a ← i ⊏ gs←b∾g      # Active propagations
  c ← g ∨ p ∧ a       # Carry from these positions
  r ← (𝕩 + b»c) - c×base
  ⟨r, c⊸«⌾⋈b⟩
}

Add ⇐ {
  0⊸<◶⊣‿∾´ Carry 𝕨 +_extend 𝕩
}

Sub ⇐ {
  ! 𝕨 ≥○≠ 𝕩
  s‿c ← 1 Carry 𝕨 (⊣ + (base-1)-⊢)_extend 𝕩
  ! 1 = c
  Trim s
}

Mul ⇐ {
  512 < n←𝕨⌊○≠𝕩 ? # Karatsuba
    k←⌊n÷2
    # Add⟜((k⥊0)⊸∾){𝔽´𝔽¨˝} 𝕨 𝕊⌜○(k⊸(↑⋈↓)) 𝕩  but one less 𝕊
    l‿h‿a ← 𝕨 𝕊¨○(∾⟜(<Add´)k⊸(↑⋈↓)) 𝕩
    Add⟜((k⥊0)⊸∾)´ ⟨l, a Sub l Add h, h⟩
  ;
  0 = 𝕨⌊○≠𝕩 ? ↕0 ;
  q ← ×˜base                           # Maintain ∧´s<q
  s←o ← 0¨𝕩                            # Sum, overflow
  p ← {c←q≤a←𝕩+«s ⋄ s↩a-c×q ⋄ o↩c+«o ⋄ ⊑¨s‿o}∘×⟜𝕩¨ 𝕨
  s‿o ∾˜¨↩ <˘⍉¯1↓>p                    # Restore passed sums
  Sp ← {t←⌊𝕩÷base ⋄ ⟨𝕩-base×t, t⟩}     # Split into top and bottom
  Trim Add⟜(0⊸∾)´ (Sp s) ∾ {∧´𝕩<base?⋈𝕩; <⊸∾⟜𝕊´Sp𝕩} o
}

_compare ⇐ {
  Full ← 0⊸≤◶⟨𝔽˜,⊑⟜𝕨𝔽⊑⟜𝕩⟩ · -⟜1 _while_ (0⊸≤◶⟨0,⊑⟜𝕨=⊑⟜𝕩⟩) -⟜1
  𝕨 =◶𝔽‿Full○≠ 𝕩
}

Neg ⇐ (!0=≠)⊸⊢
Signum ⇐ ×∘≠
Abs ⇐ Conj ⇐ ⊢
