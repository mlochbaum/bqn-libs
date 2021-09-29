p ← •Import "../primes.bqn"
PrimesTo‿PrimesIn‿SieveSegment‿NextPrime‿PrevPrime‿IsPrime‿NthPrime‿Pi‿Factor‿FactorExponents‿Totient ← p

! 2‿3‿5‿7‿11‿13‿17‿19‿23‿29‿31 ≡ PrimesTo 32

! 78498 ≡ Pi 1e6
! (≠∘PrimesTo¨ ≡ Pi) 4389‿4391

! (0‿18‿20‿32⊸+ ≡ ·PrimesIn +⟜0‿33) 5423669
! (  18‿20   ⊸+ ≡ ·PrimesIn +⟜1‿32) 5423669
! 0‿18‿20 ≡ /SieveSegment     0‿32+ 5423669

! (+⟜11 ≡ NextPrime⍟2) 2‿3×1e3
! 31397 (NextPrime⊸≡ ∧ ≡⟜PrevPrime) 31469
! 11‿13 ≡ (PrevPrime ≍ NextPrime) 12

! IsPrime 37281953
! (PrimesTo ≡ /∘IsPrime∘↕) 10
! 20 ((SieveSegment 0⊸≍⊸+) ≡ (IsPrime ↕⊸+)) 37281945

! (PrimesIn 8039‿8112) ≡ NthPrime 1010+↕10

! (⥊¨ ≡ Factor) 5‿257‿2261093
! 2081‿3709 ≡ Factor 7718429
! ⟨⟨23⟩,2‿2‿2‿3,5‿5⟩ ≡ Factor 23‿24‿25

! (2‿3‿5‿7≍4‿2‿1‿1) ≡ FactorExponents ×´1+↕7
! ∧´ (≍⟜(1¨) ≡ FactorExponents∘(×´))¨ ⟨37951‿113171,3793‿1132333,(2⋆17‿31)-1⟩

! 1 ≡ Totient 1
! 16‿6‿18‿8 ≡ Totient 17‿18‿19‿20

•Out "All passed!"
