# keys HashMap vals:     return a mutable hash map h implementing
#   h.Count any:         return number of keys defined by h
#   h.Has key:           return 1 if key is present and 0 otherwise
#   [default] h.Get key: return corresponding value, default if not found
#   key h.Set val:       set value (may overwrite); return h
#   h.Delete key:        remove corresponding value; return h

# 𝕗_hash is a function returning index in (2⋆n)-length table
⟨_hash⟩ ← {
  base ← 2 ⋆ b←32
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
  hlen←bits←table←0 ⋄ Ind←Next←⊢
  InitSize ← {
    hlen ↩ 2 ⋆ bits ↩ 1+⌈2⋆⁼ 1⌈𝕩  # hlen ≥ 2×len
    Ind ↩ bits _hash
    Next ↩ hlen⊸>⊸× 1+⊢
    table ↩ hlen ⥊ ¯1
  }
  ST ← {table 𝕨⌾(𝕩⊸⊑)↩⋄@}
  Count ⇐ {𝕊:len}

  # Lookup and modify
  Find ← { 𝕊 key:
    T ← ("Not found!"!¯1⊸≠)⊸⊢ ⊑⟜table
    table ⊑˜ Next•_while_(key≢keys⊑˜T) Ind key
  }
  Get ⇐ {
      𝕊 key: vals ⊑˜ Find key ;
    d 𝕊 key: Next•_while_(¯1⊸≠◶⟨0,⊢{d↩𝕨⋄𝕩}⍟(¬⊢)key≢⊑⟜keys⟩⊑⟜table) Ind key ⋄ d
  }
  tombstone ← {⇐}
  Delete ⇐ { 𝕊 key:
    keys tombstone⌾((Find key)⊸⊑)↩
    DecLen 1
    self
  }
  Has ⇐ { 𝕊 key:
    h←1 ⋄ Next•_while_(¯1⊸≠◶⟨{𝕊:h↩0},key≢⊑⟜keys⟩⊑⟜table) Ind key ⋄ h
  }
  DefKey ← { 𝕊 key:
    Next•_while_(¯1⊸≠◶⟨0,"Duplicate key"!key≢⊑⟜keys⟩⊑⟜table) Ind key
  }
  Set ⇐ { key 𝕊 val:
    New ← {len ST 𝕨 ⋄ keys∾↩<key ⋄ vals∾↩<val ⋄ IncLen 1 ⋄ 0}
    Mod ← {vals val˙⌾((𝕨⊑table)⊸⊑)↩ ⋄ 0}
    Next•_while_(¯1⊸≠◶⟨New,Mod⍟(¬⊢)⟜(key≢⊑⟜keys)⟩⟜(⊑⟜table)) Ind key
    self
  }

  # Resize
  Init ← {
    InitSize 𝕩
    (↕𝕩) ST⟜DefKey¨ keys
  }
  ClearTombs ← {𝕊:
    ! len ≡ +´ k ← tombstone⊸≢¨ keys
    keys‿vals k⊸/¨↩
    k
  }
  Renumber ← { # Based on filter 𝕩
    table ⊏↩ 1-˜(𝕩×+`𝕩)∾0
    @
  }
  IncLen ← {
    len +↩ 𝕩
    hlen ≥ 2 × ≠keys ? @ ;
    k ← ClearTombs@
    hlen ≥ 1.75 × len ? Renumber k ;
    Init len
  }
  DecLen ← {
    len -↩ 𝕩
    hlen < 6 × len ? @ ;
    ClearTombs@
    Init len
  }
  Init len ← ≠keys
}
