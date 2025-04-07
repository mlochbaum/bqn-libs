⟨P⇐Parse⟩ ← •Import "../xml.bqn"

_fails ← {0∘𝔽⎊1}
e ← ↕2‿0 # No attributes

! P _fails "<"
! P _fails "<tag><</tag>"

! ⟨"tag"‿e‿⟨⟩⟩ ≡ P "<tag></tag>"
! ⟨"tag"‿[⋈"attr",⋈"val"]‿⟨⟩⟩ ≡ P "<tag attr=""val""></tag>"
! ⟨"tag"‿e‿⟨<"contents"⟩⟩ ≡ P "<tag>contents</tag>"
! ⟨"void"‿e⟩ ≡ P "<void/>"
! ⟨"void"‿["id"‿"attr","id"‿"val"]⟩ ≡ P "<void id=""id"" attr=""val""/>"

! ⟨"void"‿["a"‿"b",">'> "‿"; "">"]⟩ ≡ P "<void a="">'> "" b='; "">'/>"

! ⟨"tag"‿e‿⟨<"text"⟩⟩ ≡ P "<tag>text</tag>"
! (⋈˜"tag"‿e‿⟨<"qu'ote"⟩) ≡ P ∾˜"<tag>qu'ote</tag>"
! ⟨"tag"‿e‿⟨<">>>"⟩⟩ ≡ P "<tag>>>></tag>"

# Character references
#! ⟨"tag"‿e‿⟨<"<>&'"""⟩⟩ ≡ P "<tag>&lt;&gt;&amp;&apos;&quot;</tag>"

# Special tags
! (⋈∘< ≡ P) "<?xml version=""1.1""?>"
! (⋈∘< ≡ P) "<!--<?comment<![CDATA[?>comment]]>-->"
! ⟨"tag"‿e‿⟨<"<![CDATA[<not>not tag</not>]]>"⟩⟩ ≡ P "<tag><![CDATA[<not>not tag</not>]]></tag>"

# Nesting
FmtNest ← ∾{𝕊t‿l:∾⟜(∾𝕊¨l)⊸∾´("<"∾∾⟜t∾">"˙)¨""‿"/"}¨
(! {𝕊t‿l:⟨t,e,𝕊¨l⟩}¨ ≡ P∘FmtNest)¨ ⟨
  ⟨"a0"⋈⟨"a1"⋈⟨⟩⟩, "b0"⋈⟨⟩, "c0"⋈⟨⟩⟩
  ⟨"a0"⋈⟨⟩, "b0"⋈⟨"b1"⋈⟨"b2"⋈⟨"b3"⋈⟨⟩⟩,"b4"⋈⟨⟩,"b5"⋈⟨⟩⟩⟩⟩
⟩

•Out "All passed!"
