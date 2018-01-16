using CoDa
using Base.Test

@testset "CoDa.jl" begin
  @testset "Composition" begin
    c₀ = Composition(1,1,1)
    c₁ = Composition(1,2,3)
    c₂ = Composition(10,20,30)
    @test c₁ == c₂
    @test c₁ - c₂ == c₀
    @test norm(c₀) ≈ 0.
    @test isapprox(distance(c₁, c₁), 0., atol=1e-6)
  end
end
