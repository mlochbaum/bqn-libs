⟨
  Min1
  _powell
  _nelderMead
⟩⇐

_while_ ← {𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}

#⌜
# Nelder and Mead's downhill simplex method
NelderMead_sub ← { Fn‿excessvol‿pts:
  beta_vol ← 2⋆⁼|betas ← ¯0.5‿1‿2

  fp ← Fn¨ pts
  fp‿pts (⍋fp)⊸⊏¨↩ 

  # Perform one step and return log base 2 of change in volume
  Loop ← {𝕤
    centroid ← (+˝÷≠) ¯1↓pts
    # Points to try: linear combinations of the centroid and worst
    try ← centroid (⊣ + betas×-) ¯1⊏pts
    min ← ⌊˝ ft ← Fn¨ try
    p ← ⊑ fp ⍋ min            # Place relative to existing points
    p < ≠fp ?
      # New point improves on at least one other
      i ← ⊑ ft ⊐ min
      pts‿fp {p (↑∾𝕩»↓) 𝕨}¨↩ ⟨i⊏try,min⟩
      i ⊑ beta_vol            # Volume changes proportional to beta
    ;
      # New point is still the worst
      fp ↩ Fn¨ pts (2÷˜+)⟜⊏↩  # Contract towards best point
      fp‿pts (⍋fp)⊸⊏¨↩        # Reorder
      1-≠pts                  # Volume shrinks by half in each dimension
  }

  # Keep going until volume decreases enough
  Loop⊸+ _while_ (0⊸<) excessvol
  ⟨⊑pts, ⊑fp⟩
}

_nelderMead ← {
  simplex ← ⟨𝕩⟩∾𝕩⊸+¨<⊸=↕≠𝕩
  NelderMead_sub ⟨𝔽, (≠𝕩)×(-2⋆⁼𝕨)⊣15, simplex⟩
}


#⌜
# 1-dimensional minimization, beginning at interval ¯1‿1
# Return ⟨argument, value⟩ for a local minimum
Min1 ← { tol 𝕊 f:
  phi ← 2÷˜1+√5  # golden ratio
  phi2 ← 2 - phi
  max_iter ← 100

  # Find initial minimum range, with steps increasing by factors of phi
  Init ← ∾{
    v ← (⊢ + phi × -˜)´ ¯2↑𝕨
    (v𝔽𝕨) (≤´1↓⊢)◶⟨«_𝕣,≍˘⟩ (F v)𝔽𝕩
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
_linmin ← { 𝔽_𝕣 start‿dir‿tol:
  Trans ← start + dir⊸×
  Fn ← 𝔽∘Trans⚇0
  Trans⌾⊑ tol Min1 fn
}


#⌜
# (Enhanced) Powell's direction-set method

# Works with a set of directions, one for each dimension
# Idea is to optimize in all directions in order, then possibly add the
# total distance travelled as a new direction

Powell_sub ← { Fn‿Min‿p‿tol‿max_iter:
  fp ← Fn p     # Current function value
  pt ← p        # Baseline to find new directions
  dp ← <⊸= ↕≠p  # Initialize direction set with basis vectors

  iter ← 0
  ⊢_while_ {𝕤
    max_iter > iter+↩1 ?
    fi ← fp

    # Minimize in each direction successively, and record change in f
    df ← { f0←fp ⋄ p‿fp↩Min p‿𝕩 ⋄ f0-fp }¨ dp

    # Relative tolerance
    (2×|fi-fp) > tol × fi +○| fp ?

    dt ← p - pt
    fe ← Fn pe ← p + dt  # Extrapolate
    pt ↩ p               # Starting point for next dt

    # Now fi → fp → fe are successive values separated by dt
    # Consider adding dt to the direction set
    # Replace the direction of largest increase to maintain independence
    { fe < fi ?
      mdf ← ⌈´df          # Largest decrease
      d2f ← fi+fe - 2×fp  # Approximate second derivative wrt dt
      (2×d2f × ×˜ (fp+mdf)-fi) < mdf × ×˜ fe-fi ?
      p‿fp ↩ Min p‿dt
      dp dt⌾((⊑df⊐mdf)⊸⊑)↩
    ;@}
    1;0
  }@

  p‿fp
}

_powell ← {
  tol ← 𝕨⊣1e¯10
  step ← ÷4
  ltol ← 1e¯4
  Powell_sub ⟨𝔽, 𝔽 _linmin {p‿d:𝕩⋄⟨p,step×d,ltol⟩}, 𝕩, tol, 50×≠𝕩⟩
}
