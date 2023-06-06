# JSON: JavaScript Object Notation
⟨
  Parse   # JSON string to BQN
  Export  # BQN value to JSON (also Parse⁼)
⟩⇐

# JSON numbers, strings, and lists correspond directly to BQN
# Objects are represented as keys≍values
# true, false, null are represented as <"true", <"false", <"null"

# An empty list exports as "" if its fill is a space and [] otherwise

⟨Consts, ExportConst⟩ ← {
  val ← <¨ name ← "true"‿"false"‿"null"
  Consts ⇐ {
    i ← name ⊐ 𝕩
    "Unknown constant" 𝕎 i = ≠name  # 𝕎 formats errors
    i ⊏ val
  }
  cm ← "Enclosed value must be JSON constant"∾∾' '⊸∾¨"or "⊸∾⌾(¯1⊸⊑)name
  ExportConst ⇐ {
    i ← val⊸⊐⌾< 𝕩
    cm ! i<≠val
    i ⊑ name
  }
}
⟨UnEscape, Escape⟩ ← {
  in ← """\/bfrnt"
  out ← (3↑in)∾@+8‿12‿13‿10‿9
  diff ← (out-in) ∾ 0
  Basic ← {
    i ← in ⊐ 𝕩
    "Unknown escape" ! ∧´𝕨≤i<≠in
    𝕩 + 𝕨 × i ⊏ diff
  }

  hc ← "0Aa"
  hb ← ⥊hc+0≍˘10‿6‿6   # Hex boundaries, start and after-end
  ho ← 2/hc-0‿10‿10    # Corresponding offsets
  Hex ← { u 𝕊 𝕩:
    d ← 𝕩 /˜ m ← ≠` (4⥊0)⊸»⊸≠ »u
    t ← hb ⍋ d
    "String \u must be followed by 4 hex characters" ! ∧´1=2|t
    # Now m can't run past the end or self-intersect,
    # or it would have hit a closing quote or backslash
    v ← 16⊸×⊸+˜˝⌽ ⍉∘‿4⥊ d-t⊏ho
    w‿e ← Surrogate v
    ⟨(w+@-'u')⊸+⌾(u⊸/)𝕩, e⌾(u⊸/)m⟩
  }
  sr ← 2⋆10            # Surrogate base/radix
  sb ← sr×52+2+↕3      # Surrogate character boundaries
  Surrogate ← {
    c ← (≠sb)|sb⍋𝕩     # 0 for non-surrogate, 1 then 2 for surrogate
    h ← 1=c            # First half
    "Unmatched surrogate pair" ! (0∾h) ≡ (2=c)∾0
    r ← 𝕩 - c⊏0∾sb     # Numeric value of surrogates
    v ← r + »h×sr×(2⋆6)+r
    ⟨v, h⟩
  }

  UnEscape ⇐ { e 𝕊 𝕩:
    u ← e ∧ 𝕩='u'
    (u<e)⊸Basic⌾⊑ u Hex⟜⊑⍟(∨´u) 𝕩‿0
  }

  Hex32 ← {                # Convert 𝕩<32 to two hex digits
    u‿l ← 16(⌊∘÷˜⋈|)𝕩      # Upper and lower digits; ∧´u<2
    '0'+u≍˘l-(10+-´"0A")×10≤l
  }
  Escape ⇐ {
    e ← (𝕩∊2↑in) ∨ 𝕩<@+32  # Quote, backslash, and control characters
    j ← /e ⋄ k ← ¬e        # Their indices; characters to keep
    c ← j ⊏ 𝕩              # Characters to be escaped
    m ← c - (out⊐c)⊏diff   # Escape the basic ones
    g ← 2 ∾˜ m<@+32        # Group 𝕨 to separate...
    n‿u ← g ⊔ m            # Characters requiring basic, hex escapes
    i ← ∾⟨/k⟩∾2‿6/¨g⊔j     # Target indices
    i ⍋⊸⊏ ∾⟨               # Use them to reorder:
      k/𝕩                  # Kept characters
      ⥊'\'≍˘n              # Basic escapes
      ⥊"\u00"⊸∾˘ Hex32 u-@ # Hex escapes
    ⟩
  }
}

# Format error with message 𝕨 at locations 𝕩 in 𝕗
_fmtErr ← { msg src _𝕣 pos:
  lf ← @+10
  s ← 0∾1+ b←/src=lf                # Line start and break positions
  l ← (1↓s) ⍋ pos                   # Error line numbers
  c ← pos - l⊏s                     # Error column numbers
  d ← ⊑l                            # First line only
  1↓∾lf⊸∾¨ ⟨
    msg
    (d⊑s)↓(d⊑b∾≠src)↑src            # Display first line
    " ^" ⊏˜ /⁼ (d=l)/c              # And carets under errors
  ⟩∾{
    n ← ≠ a ← d⊸≠⊸/l                # 1-indexed numbers of other lines
    0<n ? ⋈((-1=n)↓"Also lines")∾1↓∾⥊(<", ")≍˘•Repr¨1+a
    ; ⟨⟩
  }
}

# JSON to ⟨tokens, constants, numbers, strings⟩
# Tokens are characters {}[],: and a constant, 0 number, " string
# Values correspond to a, 0, and " in order
Tokenize ← {
  FE ← 𝕩_fmtErr ⋄ _err ← {(! 𝕗 FE /)⍟(∨´)}
  # Strings
  e ← »eo ← <`'\'=𝕩
  s ← ≠`q ← e<'"'=𝕩
  "Unclosed quote" ! ¬¯1⊑s
  "Backslash outside string"_err s<eo
  "Un-escaped control character"_err s>𝕩≥@+32
  xe‿dr ← e UnEscape 𝕩              # Escaped 𝕩; characters to drop
  sg ← ((1-˜(s>q∨eo∨dr)×+`)∾+´)s∧q  # Start at s∧q; exclude q, eo, dr
  str ← sg ⊔ xe                     # Strings

  # Numbers and constants
  b ← s ∨ 𝕩∊@+9‿10‿13‿32            # Whitespace (blank)
  l ← ¬ b ∨ 𝕩∊"""{}[],:"            # Word characters
  w ← »⊸< l                         # Word starts
  neg ← '-' = 𝕩
  dig ← ('0'≤𝕩) ∧ 𝕩≤'9'
  m ← l ∧ (+`w)⊏0∾w/dig∨neg         # Numbers
  n ← m∧w ⋄ k ← m<w                 # Number and constant starts
  "Leading zero"_err (n≠»⊸∨n∧neg)∧('0'=𝕩)∧«dig
  "Digits required on both sides of decimal"_err (m∧'.'=𝕩)>(»∧«)dig
  CE ← {(! 𝕨 FE /⟜(/k))⍟(∨´) 𝕩}
  cns ← ce Consts (1-˜(m<l)×+`k)⊔𝕩  # Constants
  num ← •ParseFloat¨ (1-˜m×+`n)⊔𝕩   # Numbers

  # Tokenize
  f ← ¬b∨w<l                        # First characters of tokens
  tok ← '0'¨⌾((f/n)⊸/) 'a'¨⌾((f/k)⊸/) f/𝕩
  ⟨tok, f, cns, num, str⟩
}

Parse ← {
  𝕊⁼𝕩: Export 𝕩 ;
  "Empty input" ! 0<≠𝕩
  t‿tf‿cns‿num‿strk ← Tokenize 𝕩
  "Empty input" ! 0<≠t

  # Validate
  # _tr records persistent transformations
  # Temporary transformations are passed to _err_ as 𝔽
  trs ← ⟨tf,/⟩ ⋄ _tr ← {trs∾↩⟨𝕨⊸𝔽⟩⋄𝕨𝔽𝕩}
  FE ← 𝕩_fmtErr ⋄ _err_ ← {𝕗{! 𝕗 FE 𝕩/𝔾{𝕎𝕩}´⌽trs}𝔾⍟(∨´)}
  q ← '"'=t
  c ← ':'=t
  "Object keys must be strings"_err_⊢ (»q)<c
  g ← ⍋+`(co←t∊"[{")-cc←t∊"]}"      # Bracket depth ordering indices
  u ← g ⊏_tr t
  r ← +` s ← u∊"[{"
  o ← s/'{'=u                       # Container is object
  "Mismatched brackets"_err_{s/𝕩} o ≠ (u∊"]}")/'}'=u
  v ← («⊸∨¬s) /_tr u                # Remove empty lists/objects
  vs← v ∊ "[{,:"                    # Must alternate 0101...10
  "Improper , or : usage"_err_⊢ 1(∾=∾˜) vs
  v /_tr˜↩ vs
  # v should be composed of lists [,,, and objects {:,:,:
  # Convert {: to { and ,: to : to get [,,, and {::
  v /_tr˜↩ ¬((»v='{')⊸∧ ∨ (v=',')∧«)v=':'
  # Or, every , follows list-like [, and every : follows object-like {:
  d ← v∊",:"
  "Top-level , or :"_err_{1↑𝕩} 1↑d
  "Bad object structure"_err_⊢ d > »⊸=v∊"{:"

  # Keys
  l ← (⍋g) ⊏ r                      # Container index
  j ← +`⊸× o                        # Object index (start at 1; 0 if list)
  keys ← ((q/(«c)×l⊏0∾j)∾1+´o) ⊔ strk
  str ← ⊑keys

  # Purely numeric lists
  l ⊏↩ ⍋⍋nm←0⌾⊑1(∾/∾˜)s(∨/⊣)u∊"]}""a"
  nn ← +´¬nm
  nl ← num⊔˜(1+´nm)∾˜0⊸<⊸×(1-nn)+(t='0')/l
  jj‿jn ← 2↑(1↓nm)⊔j
  Ob ← ⊑⟜keys⊸≍⍟(0<⊣)
  n ← jn Ob¨ 1↓nl

  # Build collections
  nv← n -˜○≠ vals←∾⟨cns,⊑nl,str,⌽n⟩ # Initial set of values
  f ← (l<nn)∧¬(«⊸∨c)∨co∨','=t       # Filter for just values a0"]}
  vi← ⍋⍋(f/'0'=t)+(2×f/q)+3×f/cc    # Value indices
  i ← vi ⊏ (↕nv) ∾ nv+≠⊸-cc/»l      # Adjust for collection ordering
  jj {vals∾↩⟨𝕨 Ob 𝕩⊏vals⟩⋄@}¨○⌽ ((≠jj)∾˜1-˜f/l)⊔i
  ¯1⊑vals
}

ExportNumber ← {
  "NaN can't be represented in JSON" ! =˜𝕩
  "Infinities can't be represented in JSON" ! ∞≠|𝕩
  r ← •Repr 𝕩
  r + (-´"-¯")×r='¯'
}
IsString ← {∧´2=•Type¨ 1⊸↑⍟(0=≠) 𝕩}
ExportList ← {
  IsString 𝕩 ? ExportString 𝕩 ;
  ∾ ⟨"["⟩∾⟨"]"⟩∾˜ 1↓⥊(<",")≍˘Export¨ 𝕩
}
ExportString ← '"' (∾∾⊣) Escape
ExportObject ← {
  "Object must consist of keys≍values" ! 2=≠𝕩
  [k,v] ← 𝕩
  "Object keys must be strings" ! ∧´ IsString¨ k
  kv ← ⥊ (ExportString¨ k) ≍˘ Export¨ v
  ∾ ⟨"{"⟩∾⟨"}"⟩∾˜ ¯1↓⥊ kv ≍˘ (≠kv) ⥊ ⟨":",","⟩
}
Export ← (2⌊•Type)◶⟨ # Check type
  (3⌊=)◶⟨            # Type 0, array: Check rank
    ExportConst      #   0 constant (enclosed string)
    ExportList       #   1 List or string
    ExportObject     #   2 Object
    !∘"Rank >2 cannot be exported to JSON"
  ⟩
  ExportNumber       # Type 1: number
  !∘"Only numbers and arrays can be exported to JSON"
⟩
