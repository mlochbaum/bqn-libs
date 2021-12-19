⟨HashMap⟩ ← •Import "../hashmap.bqn"

{
  n ← ≠ k ← 3‿¯π‿"str"‿'k'‿'j'
  m ← k HashMap v←↕5
  ! n ≡ m.Count@
  ! (m.Has¨ ≡ ∊⟜k) (¯π+¯1‿0‿1×1e¯15)∾"strike"∾3‿4
  ! (m.Get¨ ≡ k⊸⊐) 3‿1‿0‿2⊏k
  ! ∧´ 0∘m.Get⎊1¨ "k"‿'i'‿¯3
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
  ! (n-1) ≡ m.Count@
  ! 0∘m.Get⎊1 "str"
  ! (("new"⌾⊑k⊐⊢) ≡ m.Get¨) 3‿¯π‿'k'‿'j'
}

•Out "All passed!"
