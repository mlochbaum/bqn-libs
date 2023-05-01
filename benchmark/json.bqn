⟨_line⟩ ← •Import "util.bqn"
⟨Parse⟩ ← •Import "../json.bqn"

L ← 36 _line ⟜ ((1e6÷≠) × 1e3 Parse•_timed ⊢)
LV← L⟜(Parse⁼)
R ← •rand.Range

Q ← '"'⊸(∾∾⊣)
Esc ← { m‿k 𝕊 𝕩: # Add m basic and k compound (\u) escapes to 𝕩
  Sub ← •rand.Subset
  t ← m+k
  u ← t ↑ /⁼ k Sub t     # Which are compound
  l ← 2‿6 ⋄ a ← +`u⊏l-1  # Total added characters after each escape
  i‿j ← l +⌜⟜↕˜¨ (u∾2) ⊔ (»a) + t Sub (≠𝕩)-⊢´a
  ei ← (m R ≠)⊸⊏ '\'≍˘"""\/bfrnt"
  ej ← "\u"⊸∾˘ (∾"0A"+⟜↕¨10‿6) ⊏˜ 13⊸=⊸+⌾(⊏˘) k‿4 R 16 # Avoid surrogates 13…
  ej⌾(j⊸⊏)⍟(0<k) ei⌾(i⊸⊏) 𝕩
}
s4 ← '#'+(1e4-2)R-´"\#"  # Non-escape characters

•Out "Times normalized to s/MB!"

•Out "Long string, no escapes"            L  Q s4
•Out "Long string, 20% basic escapes"     L  Q 1e3‿0 Esc s4
•Out "Long string, 10% basic / 15% \u"    L  Q 500‿250 Esc s4
•Out "Long string, all \u escapes"        L  Q 0‿1e3 Esc 6e3⥊' '
•Out "Strings with ~10 characters"        LV ⊔⟜('#'⊸+)´1e3 R¨ 1e2⋈-´"\#"
•Out "Natural numbers <1e4"               LV 1e3 R 1e4
•Out "Natural numbers <1e4, lists of ~10" LV ⊔´1e3 R¨ 1e2‿1e4
•Out "1e3 nested []"                      L  1e3/"[]"
•Out "1e3 paired []"                      LV 1e3⥊<⟨⟩
•Out "1e3 paired {}"                      LV 1e3⥊<2‿0⥊0
