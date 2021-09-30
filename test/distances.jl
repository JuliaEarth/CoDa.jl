@testset "Distances" begin
  comps = rand(Composition{5}, 100)
  d = CoDaDistance()

  # Test CoDaDistance
  @test d(comps[1], comps[2]) ≈ distance(comps[1], comps[2])

  # Test pairwise with CoDaDistance
  @test pairwise(d, comps) ≈ [distance(comps[i], comps[j]) for i in 1:100, j in 1:100]
end