⟨_line⟩ ← •Import "util.bqn"
pr ← •Import "../primes.bqn"

atomic ← ⟨ "IsPrime", "Factor", "Totient", "PrevPrime", "NextPrime" ⟩
range  ← ⟨ "PrimesIn", "SieveSegment" ⟩

L ← 28 _line
•Out "(Result of PrimesTo 1e7 is saved for later operations)"
{(∾⟜𝕨¨(1+·⌈´≠¨)⊸(↑¨)𝕩) •Out∘L⟜((•BQN𝕨) {𝕎•_timed𝕩}˜ pr⊸•ns.Get)¨𝕩}´¨ ⟨
  ⟨"1e7", ⟨"PrimesTo"⟩⟩
  ⟨"1e6 +↕1e4", atomic⟩
  ⟨"1e6 +0‿1e5", range⟩
  ⟨"1e12+↕1e2", atomic⟩
  ⟨"1e12+0‿1e3", range⟩
  ⟨"1e4", ⟨"FactorCounts"⟩⟩
  ⟨"1e9", ⟨"Pi"⟩⟩
  ⟨"1e7", ⟨"NthPrime"⟩⟩
⟩
