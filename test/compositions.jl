@testset "Composition" begin
  # basic tests
  c₀ = Composition(1,1,1)
  c₁ = Composition(1,2,3)
  c₂ = Composition(10,20,30)
  @test c₁ == c₂
  @test c₁ - c₂ == c₀
  @test norm(c₀) ≈ 0.
  @test isapprox(distance(c₁, c₁), 0., atol=1e-6)

  # make sure names are preserved
  c = Composition(a=1.0, b=2.0)
  @test names(c + c) == names(c)
  @test names(-c) == names(c)
  @test names(c - c) == names(c)
  @test names(2c) == names(c)

  # unicode names work fine
  c = Composition(CO₂=1.0, CH₄=0.1, N₂O=0.1)
  @test c.CO₂ == 1.0
  @test c.CH₄ == 0.1
  @test c.N₂O == 0.1

  # get part by name
  c = Composition(a=3,b=2,c=1)
  @test c.a == 3
  @test c.b == 2
  @test c.c == 1

  # missing parts
  c = Composition(a=1.0, b=2.0, c=missing)
  @test c.a == 1
  @test c.b == 2
  @test ismissing(c.c)
end
