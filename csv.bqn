# Comma-separated values (.csv)
⟨
  Split , Join   # Convert between plain text and split cells
  SplitL, JoinL  # Between list of lines and split cells
⟩⇐

# Control characters: double quote, comma, newline
control ← {
  0=≠•args ? ""","∾@+10 ;
  ("CSV: •args must consist of 3 values" ! ⟨3⟩≡≢)⊸⊢ ∾⍟(1<≡) •args
}

# Join by separator 𝕨
J ← ∾1↓·⥊<⊸(≍˘)

# CSV text to list of list of strings
Split ← { 𝕊⁼𝕩: Join𝕩 ;
  [q,c,n] ← control=⌜𝕩
  e ← ≠`q       # Escaped characters
  s ← e<c∨n     # Split points
  d ← s∨q>»e<q  # Characters to be dropped
  (0∾s/+`e<n) ⊔ (d(¬⊸×-⊣)+`s) ⊔ 𝕩
}

# Parse list of lines, e.g. from •file.Lines
SplitL ← { 𝕊⁼𝕩: JoinL𝕩 ; Split (2⊑control) J 𝕩 }

# List of list of strings, or table, to list of lines
# Result contains internal line separators if 𝕩 does
JoinL ← { 𝕊⁼𝕩: SplitL𝕩 ;
  q‿c‿n ← control
  𝕩 <˘⍟(1<=)↩
  Esc ← (q∾˜q∾(1+q⊸=)⊸/)⍟(∨´control⊸∊)
  (c J Esc¨)¨ 𝕩
}

# To CSV text
Join ← { 𝕊⁼𝕩: Split𝕩 ; (2⊑control) J JoinL 𝕩 }
