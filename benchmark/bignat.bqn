⟨_line⟩ ← •Import "util.bqn"
bn ← •Import "../bignat.bqn"
L ← 40 _line

R ← •rand.Range⟜(2⋆24)

•Out "Add      1e5-part numbers" L 100 bn.Add´•_timed R¨1e5‿1e5
•Out "Subtract 1e5-part numbers" L 100 bn.Sub´•_timed R¨1e5-↕2
•Out "Compare  1e5-part numbers (off by 1)" L 100 ≤bn._compare´•_timed bn.Add⟜⟨1⟩⊸⋈ R 1e5
•Out "Multiply 1e4-part numbers" L bn.Mul´•_timed R¨1e4‿1e4
