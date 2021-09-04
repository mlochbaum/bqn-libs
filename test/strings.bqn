_join‿Split‿lf‿JoinLines‿Trim ← •Import "../strings.bqn"

"" !∘Split⎊@ "axxaoxxxbx"
! "a"‿""‿"ao"‿""‿""‿"b"‿"" ≡ "x" Split "axxaoxxxbx"
! "a"‿"ao"‿"xbx" ≡ "xx" Split "axxaoxxxbx"
! "axxaoxx"‿"" ≡ "xbx" Split "axxaoxxxbx"
