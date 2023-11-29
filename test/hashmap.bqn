⟨HashMap⟩ ← •Import "../hashmap.bqn"

{
  n ← ≠ k ← 3‿¯π‿"str"‿'k'‿'j'
  offset ← 100
  m ← k HashMap v←offset+↕5
  ! n ≡ m.Count@
  ! (m.Has¨ ≡ ∊⟜k) (¯π+¯1‿0‿1×1e¯15)∾"strike"∾3‿4
  ! ((offset-˜m.Get)¨ ≡ k⊸⊐) 3‿1‿0‿2⊏k
  ! ∧´ 0∘m.Get⎊1¨ "k"‿'i'‿¯3
  ! ⟨offset+4,'q',offset+1⟩ ≡ "pqr" m.Get¨ 'j'‿"k"‿¯π
  ! m ≡ 3 m.Set "new"
  ! n ≡ m.Count@
  ! "new" ≡ m.Get 3
  ! m ≡ 4 m.Set "thing"
  ! (n+1) ≡ m.Count@
  ! "thing" ≡ m.Get 4
  ! ∧´ m.Has¨ ¯π‿3‿4
  ! m ≡ m.Delete 4
  ! n ≡ m.Count@
  ! 0 ≡ m.Has 4
  ! m ≡ m.Delete "str"
  ! 0∘m.Delete⎊1 "str"
  ! (n-1) ≡ m.Count@
  ! 0∘m.Get⎊1 "str"
  ! (("new"⌾⊑offset+k⊐⊢) ≡ m.Get¨) 3‿¯π‿'k'‿'j'

  # Resizing probably
  (k10 ← ≍⍟(↕10) @) m.Set¨ (<"ab")+↕10
  ! (n+9) ≡ m.Count@
  ! 0 ≡ m.Has 4
  ! ("ab"+6) ≡ m.Get ≍⍟6 @
  m.Delete⎊@¨ k
  ! 10 ≡ m.Count@
  m.Delete¨ k10
  ! 0 ≡ m.Count@
  ! ∧´ 0 = m.Has¨ k∾⟨≍⍟3 @,"thing"⟩
}

•Out "All passed!"
