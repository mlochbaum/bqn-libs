# Arithmetic on large natural numbers.

base ← ⊑ •args ∾ 2⋆24
! 1=•Type base ⋄ ! (⌊⊸=∧0⊸≤) base
! (×˜base) ≤ 2⋆53

_while_ ← {𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}

Valid ← {
  1==𝕩? ∧´1=•Type¨𝕩? ∧´(⌊⊸=∧0⊸≤∧<⟜base)𝕩? # List of integers in [0,base)
  (0<≠)◶⟨1,0≠⊢´⟩𝕩? 1 ;                    # Highest-order one isn't 0
  0
}
Trim ← { 𝕩 ↑˜ -⟜1 _while_ (≥◶⟨0,0=-⊑𝕩˙⟩⟜1) ≠𝕩 }

From ⇐ {
  𝕊⁼𝕩: ! Valid 𝕩 ⋄ ToNum 𝕩 ;
  ! 1 = •Type 𝕩
  ! (0≤𝕩) ∧ 𝕩<∞
  ! ⌊⊸=𝕩
  {0:↕0; m∾𝕊base÷˜𝕩-m←base|𝕩} 𝕩
}
ToNum ⇐ { r←𝕨+base×𝕩 ⋄ "inexact"!𝕨=base|r ⋄ r }´
NearestNum ⇐ {
  base = 2⋆l←2⋆⁼base? d←0⌈(≠𝕩)-⌈53÷l ⋄ (2⋆l×d) × +⟜(base⊸×)´ d↓𝕩 ;
  ! "Non-powers of 2 not yet implemented"
}

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
_extend ← { 𝕨 𝔽○((𝕨⌈○≠𝕩)⊸↑) 𝕩 }
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

Fact ⇐ { 𝕩≤1? ⟨1⟩; 𝕨𝕊n:
  Prod ← {2≤l←≠𝕩 ? (⌊l÷2)(↑Mul○𝕊↓)𝕩 ; From ×´𝕩} # Recurse to keep intermediates small
  Pri ← {/(2≤↕𝕩){𝕩>0⌾(𝕨⊸⊑)𝕩≠⊸⥊𝕨↑1}⍟⊑´⌽↕⌈√𝕩}     # Primes <𝕩
  p ← 𝕨 Pri⊘(≤/⊣) n+1                           # (save them in 𝕨)
  s ← Prod 1⊸<⊸/ {𝕊p:p⋆+´2|{𝕊0:↕0;𝕊⊸∾⌊𝕩÷p}n}¨ p # Swinging factorial
  s Mul Mul˜ p 𝕊 ⌊n÷2
}∘⊢
