⟨P⇐Parse⟩ ← •Import "../xml.bqn"

_fails ← {0∘𝔽⎊1}
e ← ↕2‿0 # No attributes

! ⟨"tag"‿e‿⟨⟩⟩ ≡ P "<tag></tag>"
! ⟨"tag"‿[⋈"attr",⋈"val"]‿⟨⟩⟩ ≡ P "<tag attr=""val""></tag>"
! ⟨"tag"‿e‿⟨<"contents"⟩⟩ ≡ P "<tag>contents</tag>"
! ⟨"void"‿e⟩ ≡ P "<void/>"
! ⟨"void"‿["id"‿"attr","id"‿"val"]⟩ ≡ P "<void id=""id"" attr=""val""/>"
