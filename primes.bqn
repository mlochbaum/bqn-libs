⟨
  PrimesTo
  PrimesIn, SieveSegment
  NextPrime, PrevPrime
  IsPrime
  Pi
  NthPrime
  Factor, FactorExponents
  FactorCounts
  Totient
⟩⇐

# Wheel factorization
MakeWheel ← {
  len ⇐ ×´primes ⇐ 𝕩     # Primes in wheel and wheel length
  mask ⇐ ∧´(len⥊0<↕)¨primes
  numc ⇐ ≠ coprime ⇐ /mask

  # Get prime mask on segment [start,end) with prime divisors pd
  # Assumes pd doesn't intersect primes, or [start,end)
  Sieve ⇐ {pd 𝕊 start‿end:
    w←coprime,wn←numc,wl←len
    bc‿ep ← wl (⌊∘÷˜ ≍○< w⍋|) (𝕩-1)÷⌜pd

    # Do first partial wheels together
    m ← ≠˝bc
    U←{⟨r←𝕩-𝕨,(⊒/r)+r/𝕨⟩} #{⟨r←𝕩-𝕨,((↕·⊑¯1⊸↑)+r/𝕨-»)+`r⟩}
    fr‿fk ← U⟜((m×wn)⊸⌈)˝ ep
    j ← (fr/pd) × (fr/wl×⊏bc) + fk⊏w

    # Then the remainder for each prime spanning multiple wheels
    Rem ← {p‿s‿e‿o: # prime, start, end, overflow
      pl←p×wl ⋄ pw←start-˜p×w
      ⟨⥊(pl×s+↕e-s)+⌜pw, (pl×e)+o↑pw⟩
    }
    b ← Rem˘ ⍉>m⊸/¨⟨pd,1+⊏bc,1⊏bc,1⊏ep⟩

    i ← ∾ ⟨j-start⟩∾⥊b
    0¨⌾(i⊸⊏) (end-start)⥊start⌽mask
  }
}

# Prime state
next ← 11
⟨Sieve⟩ ← wheel ← MakeWheel 2‿3‿5‿7
wlen ← ≠ wheel.primes
primes ← wheel.primes
Extend ← {
  E ← {
    next ↩ ⌈ 𝕩 ⌊ ((2⋆22)⊸+ ⌊ ×˜) old←next
    primes ∾↩ old + / (wlen↓primes(⍋↑⊣)√next) Sieve old‿next
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
  S ← {pd 𝕊 s‿e:
    n ← next⌊e
    (PR s‿n) ∾ <´◶⟨⟨⟩,primes⊸SN⟩ n‿e
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

NextPrime ← {        (0<≠)◶⟨𝕊1⊑R,  ⊑ ⟩ PrimesIn r←  𝕩+1‿65 }⚇0
PrevPrime ← { !2<𝕩 ⋄ (0<≠)◶⟨𝕊0⊑R,¯1⊑⊢⟩ PrimesIn r←1⌈𝕩-64‿0 }⚇0

IsPrime ← {
  CheckNat 𝕩
  p ← wheel.primes
  c ← ∨´0=p|𝕩
  c◶⟨(×˜¯1⊑p)⊸<◶1‿MillerRabin, 0⟩ 𝕩
}⚇0

MillerRabin ← { 𝕊 n:
  # n = 1 + d×2⋆s
  s ← 0 {𝕨 2⊸|◶⟨+⟜1𝕊2⌊∘÷˜⊢,⊣⟩ 𝕩} n-1
  d ← (n-1) ÷ 2⋆s

  # Arithmetic mod n
  q←2⋆27  # Half a double mantissa, rounded up
  Mul ← {a𝕊b:
    ah‿bh←ab-al‿bl←q|ab←a‿b
    bm←2|bl  # Avoid 27×27 bits
    ((n×<⟜0)⊸+ -⟜n+⊢)´ n | (a×bm) ∾ ⥊ah‿al×⌜bh‿(bl-bm)
  }
  Pow ← (1<⊢)◶⟨⋆,Mul{𝔽´𝔽˜⍟(/2|⌊∘÷⟜2⍟(↕·⌈2⋆⁼⊢)𝕩)𝕨}⟩

  # Miller-Rabin test
  mr ← {(⊑𝕨)◶⟨𝕩,1⊑𝕨⟩}´ ⟨
    ⟨   1 ⊸=  ⋄ ≠⟜s ⟩
    ⟨(n-1)⊸=  ⋄ 0   ⟩
    ⟨    ≤⟜1  ⋄ 1   ⟩
    {(𝕨-1) MR Mul˜𝕩}
  ⟩
  C ← { 𝕊a: s MR a Pow d }  # Is composite
  0 {𝕨<⟜≠◶⟨1,C∘⊑◶⟨+⟜1⊸𝕊,0⟩⟩𝕩} Witnesses 𝕩
}

witnesses ← { (1↓𝕨)⊸⍋⌾< ⊑ 𝕩˙ }˝ ⍉∘‿2⥊ ⟨
  0                , ⟨1948244569546278⟩
  212321           , 15‿5511855321103177
  624732421        , 15‿7363882082‿992620450144556
  273919523041     , 2‿2570940‿211991001‿3749873356
  47636622961201   , 2‿2570940‿880937‿610386380‿4130785767
  3770579582154547 , 2‿325‿9375‿28178‿450775‿9780504‿1795265022
⟩

# Number of primes less than or equal to 𝕩
Pi ← ((0=≡) ⊑∘⊢⍟⊣ {𝕩 LargePi∘⊣¨⌾((next<𝕩)⊸/) primes⍋𝕩}⌾⥊)∘⌊⚇1
LargePi ← {
  # Meissel-Lehmer algorithm
  Extend 2×√𝕩  # Need one past √𝕩
  a‿b‿c ← primes ⍋ 4‿2‿3 √ 𝕩

  ph ← -´ +´¨ 2⌊∘÷˜1+ (↓⥊𝕩) (⊢∾⟜(0⊸<⊸/)¨·⌽⌊∘÷˜)´ 1↓a↑primes  # φ(𝕩,a)

  p ← a↓b↑primes
  w ← 𝕩 ÷ p
  v ← w ↑˜ ca←c-a
  j ← (primes ⍋ √v) - a+↕ca
  r ← +´Pi w ∾ (j/v)÷(⊒⊸+/j)⊏p
  is ← (b+a-2) × (b¬a) ÷ 2
  js ← +´ j × (a+↕≠j)+(j-1)÷2
  ph + is + js - r
}

NthPrime ← {primes≠⊸≤◶⟨⊑˜,NP⟩𝕩}⚇0
NP ← {
  a ← 2⌈⌈ (1-˜⋆⁼⍟2(++-⟜2⊸÷)⋆⁼)⊸× 𝕩 # Approximation
  d ← 𝕩 - Pi a-1                   # Primes remaining
  p ← ⋆⁼a                          # Number→distance multiplier
  e ← 8××d-0.5                     # Go a few primes further
  a { 𝕩 (≥⟜-∧<)⟜≠◶⟨n𝕊⊣-×⊸×⟜≠,⊑⟩ PrimesIn ∧𝕨≍n←𝕨+⌊p×𝕩+e } d
}

# Prime factors and exponents
FactorExponents ← {
  CheckNat 𝕩
  2⊸⌊◶⟨!∘"Can't factor 0", 2‿0⊸⥊, IsPrime◶⟨FactorTrial, ≍˘≍⟜1⟩⟩ 𝕩
}⚇0
FactorTrial ← { 𝕊n:
  r ← 0‿2⥊0  # Transposed result
  Div ← {𝕊p: # Add exponents of p to result
    D←0=p|⊢
    e←0 ⋄ n↩{e+↩1⋄𝕊⍟D𝕩÷p}n
    r∾↩p‿e
  }
  Try ← {
    Div¨ (0=|⟜n)⊸/ PrimesIn 𝕨‿𝕩
    𝕩 Try (1+⌊√n)⌊2×𝕩
  }⍟<
  2 Try (1+⌊√n)⌊64
  ⍉ r ∾ (1<n)/≍n‿1
}

# Prime factors with repetition
Factor ← /˜˝∘FactorExponents⚇0

# Numbers of prime factors (with multiplicity) for ↕𝕩
FactorCounts ← {
  ¯1⌾⊑ +´ 𝕩{𝕗⥊0(1+⌾⊑⊢⌜)⍟(⌊𝕩⋆⁼𝕗)˜↕𝕩}¨ PrimesTo 𝕩
}

# Euler's Totient function
Totient ← (×´ (-⟜1 × ⊣⋆⊢-1˙)˝)∘FactorExponents⚇0
