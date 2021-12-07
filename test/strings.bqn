s ← •Import "../strings.bqn"
tab‿cr‿lf‿crlf‿JoinLines‿_join‿Trim‿Split‿ReplaceAll‿_template ← s
ToBytes‿FromBytes‿ToNats‿ToNums ← s

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

! ⟨'a'⟩‿⟨"x"⟩ (ReplaceAll ≡ {'x'¨⌾(('a'=𝕩)⊸/)𝕩}) "abaababaaaba"
! "yxbyxzcz" ≡ ⟨"aa","ab",'a'⟩‿(⥊¨"xyz") ReplaceAll "abaababaaaca"
! (10⥊"a") ≡ ⟨"aaa"⟩‿⟨"aaaa"⟩ ReplaceAll 8⥊"a"
! "end is start" ≡ (⋈⟜⌽ "start"‿"end") ReplaceAll "start is end"

! "a0b12cd3" ≡ "a%b%%cd%" '%'_template ⥊¨'0'+↕4
! "|a|bc|def|" ≡ "|-||-||-||-|" "|-"_template (↕4)/⊸⊔"abcdef"
! "" ≡ "" "+"_template ""

! "latin" ≡ ToBytes "latin"
! FromBytes∘ToBytes⊸≡ "(+´÷≢)𝕩"
! FromBytes _fails "(+´÷≢)𝕩"

! (•BQN ≡ ToNats) "2‿030‿40‿00999 "
! ⟨123456789⟩ ≡ ToNats '0'+↕10
! 13‿5e¯5‿0.04‿∞ ≡ ToNums ",13;05E¯5,::.04%∞"
! (•BQN ≡ ToNums) "⟨13,05E¯5,, 2.04,∞,⟩"
! ∧´ (⋈∘•BQN ≡ ToNums)¨ ⟨"000","0.0e0","¯1e10","π"⟩

•Out "All passed!"
