t ← •Import "../datetime.bqn"
ToTimestamp‿FromTimestamp ← t

! 2001‿9‿9‿1‿46‿40 ≡ ToTimestamp 1e9
! FromTimestamp∘ToTimestamp⊸≡ 2e9 × 1|π⋆˜↕1e3

•Out "All passed!"
