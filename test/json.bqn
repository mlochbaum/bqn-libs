⟨P⇐Parse⟩ ← •Import "../json.bqn"

_fails ← {0∘𝔽⎊1}

# Numbers
! 5.125 ≡ P "5.125"
! ¯2e3  ≡ P "-2e+3"
! 0     ≡ P "0e25"
! P _fails "03"
! P _fails "-001.2e-1"
! P _fails ".3"
! P _fails "3.e2"
! "0"       ≡ P⁼ 0
! "-2.5e-9" ≡ P⁼ ¯2.5e¯9
! P⁼_fails ¯∞
! P⁼_fails ÷˜0

# Strings
Q ← '"'⊸(∾∾⊣)
! ".?𝕩"          ≡ P Q".?𝕩"
! ""             ≡ P Q""
! ((@+8)∾"b""c") ≡ P Q"\bb\""c"
! "y2Àgau"       ≡ P Q"y2\u00C0ga\u0075"
! "𝕨×𝕩"          ≡ P Q"\ud835\uDd68×\uD835\udd69"
! P _fails Q"ab\cd"
! P _fails Q"\u12"
! P _fails Q"\uDd68\ud835"
! "" Q⊸≡ P⁼ ""
! "ab\\c\""" Q⊸≡ P⁼ "ab\c"""
! "\u0006\u0007\b\t\n\u000B" Q⊸≡ P⁼ @+6+↕6
! "\u001F !" Q⊸≡ P⁼ @+31‿32‿33

# Constants
! ∧´ (< ≡ P)¨ "true"‿"false"‿"null"
! P _fails "test"
! ∧´ (⊢ ≡ P⁼∘<)¨ "true"‿"false"‿"null"
! P⁼_fails <"test"

# Collections
! P _fails ""
! ∧´ P _fails∘⥊¨ "[]{}"
! P _fails "{[}]"
! P _fails "[1,]"
! P _fails "2,3"
! P _fails "{""key"":}"
! P _fails "[""key"":4]"
! 3‿2‿1   ≡ P "[3,2.00,1e0]"
! ⟨⟩      ≡ P "[]"
! ⟨⟩‿1‿⟨⟩ ≡ P "[[],1,[]]"
! (↕2‿0)  ≡ P "{}"
! ("ab\c"‿""≍⟨2,<"false"⟩) ≡ P "{""ab\\c"":2, """":false}"
! "[]" ≡ P⁼ ⟨⟩
! "[]" ≡ P⁼ ↕0
! "[-1,""str"",false]" ≡ P⁼ ⟨¯1,"str",<"false"⟩
! "{}" ≡ P⁼ 2‿0⥊⟨⟩
! "{""key"":4}" ≡ P⁼ ≍˘"key"‿4

! P⁼_fails 'c'
! P⁼_fails 'c'‿0‿'d'‿2
! P⁼_fails {⇐}
! P⁼_fails {⌜}
! P⁼_fails 1‿1‿1⥊@
! P⁼_fails ≍"k0"‿"k1"≍2‿3

# Combined
! ≡⟜P´ ⟨
  ⟨<"null", "k0"‿"key1"≍⟨<"true",6.25e9‿2‿3⟩, ⟨"43",43⟩⟩
  "[null,{""k0"":true,""key1"":[6.25e+9,2,3]},[""43"",43]]"
⟩
! P⁼⊸≡´ ⟨
  ⟨<"null", "k0"‿"key1"≍⟨<"true",6.25‿2‿3⟩, ⟨"43",43⟩⟩
  "[null,{""k0"":true,""key1"":[6.25,2,3]},[""43"",43]]"
⟩
! (6⥊<2‿0⥊0) ≡ P "["∾"]"«18⥊",{}"

# Default pretty formatting
! "{
    ""k1"": {
        ""sub"": 10
    },
    ""k2"": 20,
    ""k3"": [
        30,
        40,
        50
    ]
}" ≡ (4/" ") P⁼ ⟨"k1", "k2", "k3"⟩≍⟨⟨"sub"⟩≍⟨10⟩, 20, ⟨30, 40, 50⟩⟩

# Spaces after items and keys; no line breaks or indentation
! ⟨"", "", ", ", ": "⟩⊸P⁼⊸≡´ ⟨
    ⟨"k1", "k2", "k3"⟩≍⟨⟨"sub"⟩≍⟨10⟩, 20, ⟨30, 40, 50⟩⟩
    "{""k1"": {""sub"": 10}, ""k2"": 20, ""k3"": [30, 40, 50]}"
⟩

•Out "All passed!"
