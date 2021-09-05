s ← •Import "../strings.bqn"
tab‿cr‿lf‿crlf‿JoinLines‿_join‿Trim‿Split‿ToBytes‿FromBytes ← s

_fails ← {0∘𝔽⎊1}

! @ ≡ tab-9
! @ ≡ lf-10
! @ ≡ cr-13
! ⟨cr,lf⟩ ≡ crlf

! ⟨⟩ ≡ JoinLines ⟨⟩
! (∾⟜lf∘⊑ ≡ JoinLines) ⟨""⟩
! (∾⟜lf∘⊑ ≡ JoinLines) ⟨"line"⟩
! (∾○(∾⟜lf)´ ≡ JoinLines) "line1"‿"l2"

! "abc" ≡ "a" "b"_join "c"
! "c,de," ≡ ","_join "c"‿"de"‿""

! "a bc" ≡ Trim "  a bc "
! "" ≡ Trim "  "
! "" ≡ Trim ""

! "" Split _fails "axxaoxxxbx"
! "a"‿""‿"ao"‿""‿""‿"b"‿"" ≡ "x" Split "axxaoxxxbx"
! "a"‿"ao"‿"xbx" ≡ "xx" Split "axxaoxxxbx"
! "axxaoxx"‿"" ≡ "xbx" Split "axxaoxxxbx"

! "latin" ≡ ToBytes "latin"
! FromBytes∘ToBytes⊸≡ "(+´÷≢)𝕩"
! FromBytes _fails "(+´÷≢)𝕩"

•Out "All passed!"
