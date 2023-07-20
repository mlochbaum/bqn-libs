c ← "',/" •Import "../csv.bqn"  # Easier characters to write

# No escapes
! ("ab"⊸+⚇0⟨0,1⟩‿⟨2⟩) ≡ c.Split "ab,bc/cd"
! ⊢⌾c.Split⊸≡ "ab,bc/cd"
! "" ≡ c.Join ⟨⟩
! "  ,;""" ≡ c.Join ⋈"  "‿";"""
! ",B,BQ/BQN,BQNc,BQNcs" ≡ c.Join 2‿3⥊↑"BQNcs"

# Empty trailing
! ⟨"ab"‿""‿"bc"‿""⟩ ≡ c.Split "ab,,bc,"
! ⟨"ab"‿""‿"bc"‿"",⟨""⟩,⟨""⟩⟩ ≡ c.Split "ab,,bc,//"

# Line-based versions
! ("ab"⊸+⚇0⟨0,1⟩‿⟨2⟩) ≡ c.SplitL "ab,bc"‿"cd"
! ""‿"a"‿"," ≡ c.JoinL ⟨⟩‿⟨"a"⟩‿⟨"",""⟩
! ",B,BQ"‿"BQN,BQNc,BQNcs" ≡ c.JoinL 2‿3⥊↑"BQNcs"

# Escape handling
! ⟨"1"‿"2,//,'/"‿"",⟨"3"⟩⟩ ≡ c.Split "1,'2,//,''/',/'3'"
! "1,'2,//,''/',/3" ≡ c.Split⁼ ⟨"1"‿"2,//,'/"‿"",⟨"3"⟩⟩
! ⟨⟨"','',"⟩⟩ ≡ c.Split "''','''','"

•Out "All passed!"
