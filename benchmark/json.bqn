⟨_line, NsGet⟩ ← •Import "util.bqn"
⟨Parse⟩ ← •Import "../json.bqn"

L ← 36 _line ⟜ ((1e6÷≠) × 1e3 Parse•_timed ⊢)
LV← L⟜(Parse⁼)
R ← •rand.Range

Q ← '"'⊸(∾∾⊣)
Esc ← {
  i ← (↕2) +⌜˜ ↕∘≠⊸+ 𝕨•rand.Subset(≠𝕩)-𝕨
  ((𝕨R≠)⊸⊏'\'≍˘"""\/bfrnt")⌾(i⊸⊏) 𝕩
}
s4 ← '#'+(1e4-2)R-´"\#"  # 1e4 non-escape characters

•Out "Times normalized to s/MB!"

•Out "Long string, no escapes"            L  Q s4
•Out "Long string, 20% basic escapes"     L  Q 1e3 Esc s4
•Out "Strings with ~10 characters"        LV ⊔⟜('#'⊸+)´1e3 R¨ 1e2⋈-´"\#"
•Out "Natural numbers <1e4"               LV 1e3 R 1e4
•Out "Natural numbers <1e4, lists of ~10" LV ⊔´1e3 R¨ 1e2‿1e4
•Out "1e3 nested []"                      L  1e3/"[]"
•Out "1e3 paired []"                      LV 1e3⥊<⟨⟩
•Out "1e3 paired {}"                      LV 1e3⥊<2‿0⥊0
