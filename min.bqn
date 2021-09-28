⟨
  Min1
⟩⇐

_while_ ← {𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}

# 1-dimensional minimization, beginning at interval ¯1‿1
# Return ⟨argument, value⟩ for a local minimum
Min1 ← { tol 𝕊 f:
  phi ← 2÷˜1+√5  # golden ratio
  phi2 ← 2 - phi
  max_iter ← 100

  # Find initial minimum range, with steps increasing by factors of phi
  Init ← ∾{
    v ← (⊢ + phi × -˜)´ ¯2↑𝕨
    (v𝔽𝕨) (<´1↓⊢)◶⟨«_𝕣,≍˘⟩ (F v)𝔽𝕩
  }
  val ← ∧ {𝕨 Init○((⍒𝕩)⊸⊏) 𝕩}⟜F ¯1‿1

  # Decrease bounding interval to tolerance
  e←d←0                      # Distance on two previous steps
  bounds ← ⊏˘ 0‿¯1⊏val       # Possible range
  mins ← 3⊸⥊¨ 1⊏val          # Lowest 3 values; initially same

  iter ← 0
  ⊢_while_ {𝕤
    # Conditions
    max_iter > iter+↩1 ?
    ¯∞ < ⊑1⊑mins ?
    bx ← bounds - ⊑⊑mins
    (2×tol) < -⊸⌈´bx ?

    # Compute sign s, distance d, saved distance e
    s←@ ⋄ s‿d‿e ↩ {
      tol<e? 2<iter?
      # Parabolic interpolation
      rq ← (⊑ - 1⊸↓)¨ mins
      a ← | dn ← (×˜⊸× 0⊸≠◶∞‿÷⟜(¯2⊸×)○(-´) ×)⟜⌽´ rq
      =˜dn ?              # Not NaN
      e > 2×a ?           # Movement needs to decrease enough
      tol < -⊸⌊´ bx-dn ?  # Stay away from bounds
      ⟨×dn,a,d⟩
    ;
      # Non-interpolation method: golden split of smaller half
      a ← | b ← -⊸<´⊸⊑ bx
      ⟨×b,phi2×a,a⟩
    }

    x ← ⊑⊑mins
    uf ← F u ← x + s×tol⌈d               # Move at least tol from x

    i ← 0 < p ← ⊑ (1⊑mins) ⍋ uf          # Position of u
    bounds ↩ (i⊑x‿u)˙⌾((i=0<s)⊸⊑) bounds # Tighten bounds; always drop one
    mins {p (↑∾𝕩»↓) 𝕨}¨↩ u‿uf            # Three lowest points; might discard u and keep all
    1;0
  }@

  ⊑¨ mins
}

# linear minimizer in multidimensions
# y is (initial value ≍ direction vector);(tolerance)
# returns (lowest point);(function value)
_linmin ← { 𝔽_𝕣 pts‿tol:
  start‿dir ← <˘pts
  Trans ← start + dir⊸×
  Fn ← 𝔽∘Trans⚇0
  Trans⌾⊑ tol Min1 fn
}
