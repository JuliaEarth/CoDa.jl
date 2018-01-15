using CoDa
using Base.Test

@testset "CoDa.jl" begin
  @testset "Composition" begin
    c₁ = Composition(1,2,3)
    c₂ = Composition(10,20,30)
    @test c₁ == c₂
    @test c₁ - c₂ == Composition(1,1,1)
  end
end
