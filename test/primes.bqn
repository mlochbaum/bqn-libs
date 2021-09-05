p ← •Import "../primes.bqn"
PrimesTo‿PrimesIn‿SieveSegment‿IsPrime‿Factor‿FactorExponents ← p

! 2‿3‿5‿7‿11‿13‿17‿19‿23‿29‿31 ≡ PrimesTo 32

! (0‿18‿20‿32⊸+ ≡ ·PrimesIn +⟜0‿33) 5423669
! (  18‿20   ⊸+ ≡ ·PrimesIn +⟜1‿32) 5423669
! 0‿18‿20 ≡ /SieveSegment     0‿32+ 5423669

! IsPrime 37281953
! 20 ((SieveSegment 0⊸≍⊸+) ≡ (IsPrime ↕⊸+)) 37281945

! 2081‿3709 ≡ Factor 7718429
! ⟨⟨23⟩,2‿2‿2‿3,5‿5⟩ ≡ Factor 23‿24‿25

! (2‿3‿5‿7≍4‿2‿1‿1) ≡ FactorExponents ×´1+↕7

•Out "All passed!"
