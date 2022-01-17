_while_ ← {𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}

complex ← {
  M ⇐ -´∘×⋈+´∘×⟜⌽
  D ⇐ (-⌾(1⊸⊑) ÷ +˝∘(×˜)){𝔽⊘(M⟜𝔽)}
  A2⇐ +´∘×˜
  A ⇐ √A2
  Sqrt ⇐ { 0<m←A𝕩 ? s‿t←0>a‿b←𝕩 ⋄ -⍟t∘⌽⍟s (÷⟜2⋈b⊸÷) √2×m+|a ; 0‿0 }
  _poly ⇐ {+⟜(𝕩⊸M)´𝕗}
  _polyd_ ⇐ {<˘⍉> (2⥊<𝕘⥊0) (»¨+𝕩⊸M)´ 𝕗}
  _polyd_ek_ ⇐ {
    ek←0 ⋄ ax←A𝕩
    v ← <˘⍉> (2⥊<𝕘⥊0) {ek↩(A⊑¨𝕩)+ax×ek⋄𝕩}∘(»¨+𝕩⊸M)´ 𝕗
    v‿ek
  }
}
CPoly ← ⋈⟜0⍟(0==)¨

# Return all complex roots of little-endian polynomial 𝕩
# 𝕨 gives the number of iterations
# Result is a list of real‿imag pairs
WeierstrassRoots ← {
  M‿D‿_poly ← complex
  F ← (M¨⟜(D¨¯1⊸⊏)CPoly𝕩)_poly
  n ← ≠𝕩
  r0← <˘⍉> 1‿0 M⍟(↕n-1)˜ 4‿9÷10  # Initial roots: 0.4i0.9⋆↕n-1
  r ← -⟜(F D ·M˝·⍉0(⊢+1‿0×⌜∧˝∘=)·><⊸-¨)⍟(𝕨⊣50) r0
  <˘⍉> (1e¯16<|)⊸× r
}

# Find a root of the given polynomial with Laguerre's method
_laguerre_ ← {poly _𝕣_ eps root:
  M‿D‿A‿A2‿Sqrt‿_polyd_ek_ ← complex
  Jump ← (•MakeRand 1).Range∘0 ⋄ jump_i ← 10

  nk2 ← 2 ÷ nrn ← ¬ rn ← ÷ 1-˜≠poly
  F ← (CPoly poly) _polyd_ek_ 3
  max_iter ← 200
  i ← 0
  ⊢_while_ {𝕤
    i < max_iter ?
    ⟨p‿dp‿d2p_h, ek⟩ ← F root
    0 < a2p ← A2 p ?
    crit ← eps × ×˜ek  # Square of stopping criterion
    stop ← { a2p ≥      crit ? 0   # keep going
           ; a2p ≥ 0.01×crit ? 1   # finish this iteration, then stop
           ;                   2 } # return immediately
    2 > stop ?
    dx ← {
      # Division by zero: jump in random direction
      0‿0 ≡ dp ? (1 + A root) × (•math.Sin⋈•math.Cos) (2×π) × Jump i ;
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
