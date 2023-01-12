j ← •Import "../json.bqn"

_fails ← {0∘𝔽⎊1}

# Numbers
! 5.125 ≡ j.Parse "5.125"
! ¯2e3  ≡ j.Parse "-2e+3"
! ¯2e3  ≡ j.Parse "-2e+3"
#! j.Parse _fails "03"
! j.Parse _fails ".3"
#! j.Parse _fails "3.e2"

# Strings
Q ← '"'⊸(∾∾⊣)
! ".?𝕩"          ≡ j.Parse Q".?𝕩"
! ""             ≡ j.Parse Q""
! ((@+8)∾"b""c") ≡ j.Parse Q"\bb\""c"
#! "y2Àga"        ≡ j.Parse Q"y2\u00C0ga"

# Constants
! ∧´ (< ≡ j.Parse)¨ "true"‿"false"‿"null"
! j.Parse _fails "test"

# Collections
! j.Parse _fails ""
! 3‿2‿1   ≡ j.Parse "[3,2.00,1e0]"
! ⟨⟩      ≡ j.Parse "[]"
! ⟨⟩‿1‿⟨⟩ ≡ j.Parse "[[],1,[]]"
! (↕2‿0)  ≡ j.Parse "{}"
! ("ab\c"‿""≍⟨2,<"false"⟩) ≡ j.Parse "{""ab\\c"":2, """":false}"

# Combined
! ≡⟜j.Parse´ ⟨
  ⟨<"null", "k0"‿"key1"≍⟨<"true",6.25e9‿2‿3⟩, ⟨"43",43⟩⟩
  "[null,{""k0"":true,""key1"":[6.25e+9,2,3]},[""43"",43]]"
⟩
