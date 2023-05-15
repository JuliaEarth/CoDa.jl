@testset "Distances" begin
  d = Aitchison()
  c = rand(Composition{5}, 100)

  # test with compositions
  @test d(c[1], c[2]) ≈ aitchison(c[1], c[2])
  @test pairwise(d, c) ≈ [aitchison(c[i], c[j]) for i in 1:100, j in 1:100]

  # test with raw vectors
  x, y = rand(3), rand(3)
  @test d(x, y) ≈ d(Composition(x), Composition(y))
end
