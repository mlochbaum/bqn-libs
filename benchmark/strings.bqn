# Missing:
# - Trim: time for long string probably not relevant?
# - Locate
# - ReplaceAll
# - _template: should be same as split mostly

⟨_line⟩ ← •Import "util.bqn"
str ← •Import "../strings.bqn"
L ← 36 _line
RR ← •rand.Range

Ins ← { 𝕨 𝕊 𝕩: # Shuffle and insert strings 𝕨 into 𝕩, non-overlapping
  𝕨 •rand.Deal∘≠⊸⊏↩
  a ← 1-˜ l←≠¨𝕨
  i ← (+`»a) + (≠𝕨) •rand.Subset (≠𝕩)-+´a
  (∾𝕨)⌾((∾i+↕¨l)⊸⊏) 𝕩
}

•Out "Times normalized to s/MB input except where noted!"

_time ← {(1e6÷≠∘⊢) × 𝔽•_timed}

s4 ← ' ' + 1e4 RR -´"\ "
Sp_t ← (1e6÷·≠1⊑⊢) × str.Split´•_timed
SP ← {
  t ← 100 Sp_t ' '+⟨0, 1e4 RR 𝕩⟩
  •Out ("Split on one character in "∾¯2↑•Repr𝕩) L t
;
  t ← 10 Sp_t ⟨𝕨, ((⌈1e4÷𝕩)⥊<𝕨) Ins s4⟩
  •Out ⟨"Split on """,𝕨,""", 1 in ",¯2↑•Repr𝕩⟩ ∾⊸L t
}
SP¨ 60‿12‿2‿1
"xy" SP 20
"separator" SP 20
"aaaa" SP 8

CE ← 3e3 str.CEscape _time ⊢
•Out "CEscape, no escapes" L CE s4
•Out "CEscape, 40% basic escapes" L CE s4 Ins˜ (2e3 RR ≠)⊸⊏'\'⋈¨"""'?\abefnrtv"

•Out "ToBytes"   L 100 str.ToBytes _time @+1e4 RR 1e4
•Out "FromBytes" L 100 str.FromBytes _time str.ToBytes @+1e4 RR 1e4

•Out "ToBase64"   L 100 str.ToBase64 _time @+1e4 RR 256
•Out "FromBase64" L 100 str.FromBase64 _time (1e4 RR ≠)⊸⊏ ∾ (⊣+↕∘¬˜)¨˝˘ ∘‿2⥊"AZaz09++//"

•Out "ToNats" L 100 str.ToNats _time '0'+¯1+1e4 RR 11
•Out "ToNums" L 100 str.ToNums _time ∾ ' '⊸∾¨•Repr¨ ⋆20×100 RR 0

DST ← ('a'+100 RR¨2‿100⥊26){
  •Out (𝕨∾", 100 letters, seconds") L (⊢´≢𝕗) ÷˜ 𝕏¨˝•_timed 𝕗
}
DST´¨⟨
  "LcsLen"     ‿str.LcsLen
  "Lcs"        ‿str.Lcs
  "Levenshtein"‿str.Levenshtein
⟩
