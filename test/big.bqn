n10 ← ⟨10⟩ •Import "../bignat.bqn"
i10 ← ⟨10⟩ •Import "../bigint.bqn"

_fails ← {0∘𝔽⎊1}

TestNat ← { 𝕊 ⟨From,ToNum,Add,Sub,Mul,_compare,Signum⟩‿S:
  ! ⊢⌾From⊸≡ 1234
  ! 98675 ≡ From⁼ S "98675"
  ! "980" ≡ From∘ToNum⌾S "000980"

  ! "41401" ≡ "41099" Add⌾S "302"
  ! "" (Add≡⊢)○S "9120"

  ! Sub˜⊸≡ S ""
  ! "" ≡ "43" Sub⌾S "43"
  ! "43" Sub⌾S _fails "44"
  ! "9" Sub⌾S _fails "10"
  ! "1" ≡ "11" Sub⌾S "10"

  ! "121" ≡ Mul⌾S˜ "11"
  ! "" ≡ "3583" Mul⌾S ""
  ! "3550753" ≡ "3583" Mul⌾S "991"

  CC ← {c𝕊a‿b: ({a 𝕏_compare b}¨ ≡ {c𝕏0}¨) =‿≠‿<‿>‿≤‿≥}⟜(S¨)
  !  1 CC "321"‿"234"
  !  0 CC "90"‿"90"
  !  0 CC ""‿""
  ! ¯1 CC "99"‿"100"

  ! 0 = Signum S ""
  ! 1 = Signum S "1"
}

TestInt ← { 𝕊 ⟨Add,Sub,Mul,_compare,Signum⟩‿S:
  ! "-215" S⊸≡ "-96" Add○S "-119"
  ! "23" S⊸≡ "-96" Add○S "119"

  ! "-23" S⊸≡ "96" Sub○S "119"
  ! "-23" S⊸≡ "" Sub○S "23"

  ! "225" S⊸≡ Mul○S˜ "-15"
  ! "" S⊸≡ "-3583" Mul○S ""
  ! "-24775" S⊸≡ "25" Mul○S "-991"

  CC ← {c𝕊a‿b: ({a 𝕏_compare b}¨ ≡ {c𝕏0}¨) =‿≠‿<‿>‿≤‿≥}⟜(I¨)
  !  1 CC "1"‿"-2"
  !  0 CC "-90"‿"-90"
  !  0 CC ""‿""
  ! ¯1 CC "-1010"‿""

  ! ¯1 = Signum S "-1"
  ! 0 = Signum S ""
  ! 1 = Signum S "1"
}

Dig ← ⌽-'0'˙
TestNat n10‿Dig

IN ← 0 ≍○< Dig
I ← ("-"≡1⊸↑)◶⟨IN,1⌾⊑·IN 1⊸↓⟩
TestNat i10‿IN
TestInt i10‿I

•Out "All passed!"
