⟨
  PrimesTo
  PrimesIn, SieveSegment
  IsPrime
  Factor, FactorExponents
  FactorCounts
⟩⇐

# Wheel factorization
MakeWheel ← {
  len ⇐ ×´primes ⇐ 𝕩     # Primes in wheel and wheel length
  mask ⇐ ∧˝0≠primes|⌜↕len
  numc ⇐ ≠ coprime ⇐ /mask

  # Get prime mask on segment [start,end) with prime divisors pd
  # Assumes pd doesn't intersect primes, or [start,end)
  Sieve ⇐ {pd 𝕊 start‿end:
    w←coprime,wn←numc,wl←len
    bc‿ep ← wl (⌊∘÷˜ ≍○< w⍋|) (𝕩-1)÷⌜pd
    U←{⟨r←𝕨+-˜˝𝕩,(⊒/r)+r/⊏𝕩⟩}
    br‿bk ←  1 U bc
    fr‿fk ← wn U (1(⊢≍«)∊/br) × br⊸/˘ ep-0‿wn
    i ← (fr/br/pd) × (fr/wl×bk) + fk⊏w

    0¨⌾((i-start)⊸⊏) (end-start)⥊start⌽mask
  }
}

# Prime state
next ← 11
⟨Sieve⟩ ← wheel ← MakeWheel 2‿3‿5‿7
wlen ← ≠ wheel.primes
primes ← wheel.primes
Extend ← {
  E ← {
    next ↩ ⌈ 𝕩 ⌊ (1e7⊸+ ⌊ ×˜) old←next
    primes ∾↩ old + / (wlen↓primes) Sieve old‿next
    𝕊⍟(next⊸<) 𝕩
  }
  next E∘(2⊸×⊸⌈)⍟< 𝕩
}

CheckNum  ← "Argument must be a non-negative number" ! (1=•Type)◶⟨0,0⊸≤⟩
CheckNat  ← "Argument must be a natural number" ! (1=•Type)◶⟨0,|∘⌊⊸=⟩

PrimesTo ← {
  CheckNum 𝕩
  Extend 𝕩
  primes (⍋↑⊣) 𝕩
}

_getSegment ← {ind _𝕣:
  PRange ← { primes (⊣⊏˜·(⊣+↕∘-˜)´⍋) 𝕩-1 }
  sn ← {⊑∘⊢+/∘𝕏}⍟𝕗 sieve
  pr ← {-˜´ ↑ ·/⁼𝕏-⊑}⍟(¬𝕗) prange
  S ← {𝕊 s‿e:
    n ← next⌊e
    (PR s‿n) ∾ <´◶⟨⟩‿SN n‿e
  }
  # IsPrime¨⊸(𝕗◶⊣‿/) start(⊣+↕∘-˜)end
  {𝕊 start‿end:
    CheckNat¨ 𝕩
    "Range must be ordered" ! ≤´𝕩
    (wlen ↓ PrimesTo √end-1) (next≤start)◶S‿SN 𝕩
  }
}
SieveSegment ← 0 _getSegment  # IsPrime¨   (⊣+↕∘-˜)´
PrimesIn     ← 1 _getSegment  # IsPrime¨⊸/ (⊣+↕∘-˜)´

IsPrime ← {
  CheckNat 𝕩
  next⊸≤◶⟨⊑∊⟜primes, ∧´0≠PrimesTo∘√⊸|⟩ 𝕩
}⚇0

Factor ← {
  CheckNat 𝕩
  ∧ 𝕩 {(0<≠∘⊢)◶⟨⥊⊣,⊢∾𝕊⟩⍟(>⟜1)˜⟜(𝕨÷×´)𝕩/˜0=𝕩|𝕨} PrimesTo √𝕩
}⚇0

# Prime factors and exponents
FactorExponents ← (/≠⟜«)⊸(⊏ ≍ -⟜(¯1⊸»)∘⊣) ∘ Factor ⚇0

# Numbers of prime factors (with multiplicity) for ↕𝕩
FactorCounts ← {
  ¯1⌾⊑ +´ 𝕩{𝕗⥊0(1+⌾⊑⊢⌜)⍟(⌊𝕩⋆⁼𝕗)˜↕𝕩}¨ PrimesTo 𝕩
}