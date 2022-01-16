files‿opts ← 2 ↑ ('-'=⊑)¨⊸⊔ •args
files (0<≠)◶⟨1,∨´"all"⊸≡¨⟩◶⟨∾⟜".bqn"¨, •name⊸≢¨⊸/·∧•file.List∘""⟩↩

fail ← 0
Test ← {𝕊f:
  •Out "⌜ "∾f∾":"
  ⟨⟩ •Import⎊{𝕤⋄ fail+↩1 ⋄ •Show •CurrentError@} f
  •Out ""
}
Test¨ files
(•Out •Repr∾" file"∾("s"/˜1⊸<)∾" failed"˙)⍟(0⊸<) fail
