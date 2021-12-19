# keys HashMap vals: return a mutable hash map h implmenting
#   h.Count any:     return number of keys defined by h
#   h.Has key:       return 1 if key is present and 0 otherwise
#   h.Get key:       return corresponding value
#   key h.Set val:   set value (may overwrite); return h
#   h.Delete key:    remove corresponding value; return h

# 𝕗_hash is a function returning index in (2⋆n)-length table
⟨_hash⟩ ← {
  base ← 2 ⋆ b←16
  _hash ⇐ { bits _𝕣:
    ! 1≤bits
    d‿m←b(⌈∘÷˜⋈|)bits
    mod ← (0<m)⊑⟨⊢,(2⋆m)⊸|⟩
    acc ← (2⌊d-1)⊑⟨Mod⊑, (base×Mod∘⊑)+¯1⊸⊑, +⟜(base⊸×)´·⌽Mod⌾⊑∘↑⟩
    (-d) Acc •Hash
  }
}

HashMap ⇐ {𝕩.Self𝕩}∘{ keys 𝕊 vals: Self⇐{self↩𝕩}
  "HashMap: keys 𝕨 and values 𝕩 must be arrays" ! ∧´ (0=•Type)¨keys‿vals
  "HashMap: key and value arrays must have the same shape" ! keys ≡○≢ vals
  keys‿vals ⥊¨↩
  hlen ← 2 ⋆ bits ← 1+⌈2⋆⁼ len ← ≠keys  # hlen ≥ 2×len
  Ind ← bits _hash
  Next ← hlen⊸>⊸× 1+⊢
  table ← ¯1 ⥊˜ hlen ⋄ ST ← {table 𝕨⌾(𝕩⊸⊑)↩⋄@}
  Count ⇐ {𝕊:len}
  Find ← { 𝕊 key:
    T ← ("Not found!"!¯1⊸≠)⊸⊢ ⊑⟜table
    table ⊑˜ Next•_while_(key≢keys⊑˜T) Ind key
  }
  Get ⇐ { 𝕊 key: vals ⊑˜ Find key }
  tombstone ← {⇐}
  Delete ⇐ { 𝕊 key:
    keys tombstone⌾((Find key)⊸⊑)↩
    len -↩ 1
    self
  }
  Has ⇐ { 𝕊 key:
    h←1 ⋄ Next•_while_(¯1⊸≠◶⟨{𝕊:h↩0},key≢⊑⟜keys⟩⊑⟜table) Ind key ⋄ h
  }
  DefKey ← { 𝕊 key:
    Next•_while_(¯1⊸≠◶⟨0,"Duplicate key"!key≢⊑⟜keys⟩⊑⟜table) Ind key
  }
  Set ⇐ { key 𝕊 val:
    New ← {len ST 𝕩 ⋄ keys∾↩key ⋄ vals∾↩val ⋄ len+↩1 ⋄ 0}
    i ← Next•_while_(¯1⊸≠◶⟨New⊣,key≢⊢⊑keys˙⟩⟜(⊑⟜table)) Ind key
    vals val˙⌾((i⊑table)⊸⊑)↩
    self
  }
  (↕len) ST⟜DefKey¨ keys
}
