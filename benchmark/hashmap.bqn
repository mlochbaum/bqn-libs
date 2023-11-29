⟨_line⟩ ← •Import "util.bqn"
⟨HashMap⟩ ← •Import "../hashmap.bqn"

L ← 16 _line
v ← 1e5 •rand.Deal 1e9
•Out "Build 1e5" L HashMap˜•_timed v
m ← HashMap˜ v
•Out "Get 1e5" L m.Get¨•_timed •rand.Deal∘≠⊸⊏ v
•Out "Has 1e5" L m.Has¨•_timed •rand.Deal∘≠⊸⊏ (↕2÷˜≠v)»v
