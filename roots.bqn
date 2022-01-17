⟨
  _ITP
⟩⇐

_while_ ← {𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}

# F is a real-valued function, and
# x≡a‿b is an interval such that (F a)<0 and (F b)>0.
# Return a value at a distance of at most 𝕨⊣1e¯10 from a root of F.
_ITP ← { 𝕨 F _𝕣 x:
  e ← 𝕨⊣1e¯10                      # Tolerance
  w ← -˜´x                         # Initial width
  c ← 0.8÷w, n0←1                  # c←k1×2⋆k2←2
  r0← (n0+⌈)⌾(2⋆⁼÷⟜e)w             # Expected radius upper bound
  ! <○(0⊸<)´ y ← F¨x               # Require bracketed and increasing
  xi←0                             # Result
  ⊢_while_ {𝕤
    xh‿r ← (+⋈-˜)´x÷2              # Midpoint and radius
    xi↩xh ⋄ e<r ?                  # Convergence criterion
    d←c××˜r ⋄ r0÷↩2                # Update constants
    xf ← x (× ÷○(-´) ⊢) ⌽y         # Interpolate
    s‿xd←(×⋈|)xf-xh                # xf = xh + s×xd
    yi←F xi +↩ s×0⌈(xd-d)⌊r0-r     # Truncate/Project
    0≠yi ?                         # Stop if 0
    U←(0<yi)⊸⊑ ⋄ x xi⌾U↩ ⋄ y yi⌾U↩ # Update bounds
    1;0
  }@
  xi
}
