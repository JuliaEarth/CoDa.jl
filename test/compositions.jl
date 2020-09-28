@testset "Composition" begin
  # basic tests
  c₀ = Composition(1.0,1.0,1.0)
  c₁ = Composition(1.0,2.0,3.0)
  c₂ = Composition(10.0,20.0,30.0)
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

  # get part by name
  c = Composition(a=3.0,b=2.0,c=1.0)
  @test c.a == 3.0
  @test c.b == 2.0
  @test c.c == 1.0
end
