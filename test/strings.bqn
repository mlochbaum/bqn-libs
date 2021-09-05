_join‿Split‿lf‿JoinLines‿Trim ← •Import "../strings.bqn"

! @ ≡ lf-10

! ⟨⟩ ≡ JoinLines ⟨⟩
! (∾⟜lf∘⊑ ≡ JoinLines) ⟨""⟩
! (∾⟜lf∘⊑ ≡ JoinLines) ⟨"line"⟩
! (∾○(∾⟜lf)´ ≡ JoinLines) "line1"‿"l2"

! "abc" ≡ "a" "b"_join "c"
! "c,de," ≡ ","_join "c"‿"de"‿""

! "a bc" ≡ Trim "  a bc "
! "" ≡ Trim "  "
! "" ≡ Trim ""

"" !∘Split⎊@ "axxaoxxxbx"
! "a"‿""‿"ao"‿""‿""‿"b"‿"" ≡ "x" Split "axxaoxxxbx"
! "a"‿"ao"‿"xbx" ≡ "xx" Split "axxaoxxxbx"
! "axxaoxx"‿"" ≡ "xbx" Split "axxaoxxxbx"

•Out "All passed!"
