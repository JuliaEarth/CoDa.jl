@testset "Composition" begin
  # basic tests
  c = Composition(1,1,1)
  @test parts(c) == (:w1,:w2,:w3)
  @test components(c) == [1,1,1]
  c = Composition(a=1, b=missing)
  @test parts(c) == (:a,:b)
  @test isequal(components(c), [1,missing])
  for c in [Composition((w1=1,w2=2))
            Composition((:w1,:w2), (1,2))
            Composition((1,2))
            Composition(1,2)]
    @test parts(c) == (:w1,:w2)
    @test components(c) == [1,2]
  end

  # equality
  c₀ = Composition(1,1,1)
  c₁ = Composition(1,2,3)
  c₂ = Composition(10,20,30)
  @test c₁ == c₂
  @test c₁ - c₂ == c₀
  @test norm(c₀) ≈ 0.
  @test isapprox(distance(c₁, c₁), 0., atol=1e-6)

  # scalar multiplication
  c = Composition(1,2,3)
  @test 2c == Composition(1^2, 2^2, 3^2)
  @test c/2 == Composition(√1,√2,√3)
  c = Composition(1,1,1)
  @test c == 2c == c/2

  # make sure names are preserved
  c = Composition(a=1.0, b=2.0)
  @test parts(c + c) == parts(c)
  @test parts(-c) == parts(c)
  @test parts(c - c) == parts(c)
  @test parts(2c) == parts(c)

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

  # random compositions
  c = rand(Composition{3})
  w = components(c)
  @test all(w .≥ 0)
  @test sum(w) ≈ 1

  c = fill(Composition(0.1,0.2,0.7), 100000)
  @test mean(c) == first(c)
  @test isapprox(var(c), 0, atol=1e-10)
  @test isapprox(std(c), 0, atol=1e-5)

  if visualtests
    c1 = Composition(CO₂=1.0, CH₄=0.1, N₂O=0.1)
    c2 = Composition(CO₂=1.0, CH₄=missing, N₂O=0.1)
    @test_reference "data/composition1.png" plot(c1)
    @test_reference "data/composition2.png" plot(c2)
  end
end
