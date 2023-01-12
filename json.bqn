# JSON: JavaScript Object Notation
⟨
  Parse  # JSON string to BQN
⟩⇐

⟨Consts⟩ ← {
  val ← <¨ name ← "true"‿"false"‿"null"
  Consts ⇐ {
    i ← name ⊐ 𝕩
    "Unknown constant" ! ∧´ i<≠name
    i ⊏ val
  }
}
⟨UnEscape⟩ ← {
  in ← """\/bfrnt"
  out ← (3↑in)∾@+8‿12‿13‿10‿9
  diff ← (out-in) ∾ 0
  UnEscape ⇐ { 𝕩 + 𝕨 × (in⊐𝕩) ⊏ diff }
}
ws←@+9‿10‿13‿32 # whitespace

# JSON to ⟨tokens, constants, numbers, strings⟩
# Tokens are characters {}[],: and a constant, 0 number, " string
# Values correspond to a, 0, and " in order
Tokenize←{
  # Strings
  e ← »eo ← <`'\'=𝕩
  s ← ≠`q ← e<'"'=𝕩
  "Unclosed quote" ! ¬¯1⊑s
  "Backslash outside string" ! ∧´s≥e
  sg ← 1-˜(s>q∨eo)×+`s∧q            # Start at s∧q; exclude q and eo
  str ← sg ⊔ e UnEscape 𝕩           # Strings

  # Numbers and constants
  w←»⊸<l←¬s∨𝕩∊"""{}[],:"∾ws         # Word chars l, start w
  n←l∧(+`w)⊏0∾('-'∾'0'+↕10)∊˜w/𝕩    # Number starts
  k←n<w                             # Constant starts
  cns ← Consts (1-˜(n<l)×+`k)⊔𝕩     # Constants
  num ← •ParseFloat¨ (1-˜n×+`n∧w)⊔𝕩 # Numbers

  # Tokenize
  f ← ¬(𝕩∊ws)∨(w<l)∨s               # First characters of tokens
  tok ← '0'¨⌾((f/n)⊸/) 'a'¨⌾((f/k)⊸/) f/𝕩
  ⟨tok, cns, num, str⟩
}

Parse ← {
  t‿cns‿num‿strk ← Tokenize 𝕩

  # Validate (incomplete)
  q ← '"'=t
  c ← ':'=t
  "Object keys must be strings" ! ∧´(»q)≥c
  g ← ⍋+`(co←t∊"[{")-cc←t∊"]}"      # Bracket depth ordering indices
  u ← g⊏t
  r ← +` s ← u∊"[{"
  o ← s/'{'=u                       # Container is object
  "Improper , or : usage" ! (≢⥊0‿1˙)⊸≡ s∨u∊",:"
  RunLen ← (1+↕∘≠)(⊣-⌈`∘×)¬
  p ← 4 | RunLen r ⊏ 0∾o            # Position within object
  "Improper : usage" ! (u=':') ≡ 3=p
  "Object ends cefore key-value pair completed" ! ¬∨´s∧»0≠p

  # Keys
  l ← (⍋g) ⊏ r                      # Container index
  j ← +`⊸× o                        # Object index (start at 1; 0 if list)
  keys ← (q/(«c)×l⊏0∾j) ⊔ strk
  str ← ⊑1↑keys

  # Build collections
  nv ← ≠ vals ← ∾cns‿num‿str        # Initial set of values
  f ← ¬(«⊸∨c)∨co∨','=t              # Filter for just values a0"]}
  vi← ⍋⍋(f/'0'=t)+(2×f/q)+3×f/cc    # Value indices
  i ← vi ⊏ (↕nv) ∾ nv+≠⊸-cc/»l      # Adjust for collection ordering
  j {vals∾↩<𝕨⊑⟜keys⊸≍⍟(0<⊣)𝕩⊏vals⋄@}¨○⌽ (1-˜f/l)⊔i
  ¯1⊑vals
}
