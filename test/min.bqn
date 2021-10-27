m ← •Import "../min.bqn"
⟨Min1,_powell,_nelderMead⟩ ← m

Ef ← (eb←1.1)⊸⋆⊸-
! ((-⊢⋆⁼⋆⁼)eb) ≥○Ef ⊑ 1e¯16 Min1 ef
! ∧´ (|∘-⟜(¯1⊸⊏) ⊢ ⊑∘Min1¨ ef˙)⊸< 10⋆-↕19

# Some easier functions to optimize (global minimum value of 0 for each)
S ← Sphere ← +´ ×˜
Booth ← S +´⊸+ - 5‿7˙
Matyas ← (0.26×S) + 0.48××´
Rosenbrock ← 1‿100 { a‿b _𝕣:
  {x‿y: (×˜a-x) + b××˜(y-×˜x)}
}
CheckMin ← { tol 𝕊 opt:
  start ← ≍˜¯1.9
  {
    res ← 𝕏 _opt start
    ! 𝕏⊸≡´ res
    ! tol > 1⊑res
  }¨ ⟨sphere,booth,matyas,rosenbrock⟩
}

1e¯20 CheckMin powell
1e¯6  CheckMin nelderMead
