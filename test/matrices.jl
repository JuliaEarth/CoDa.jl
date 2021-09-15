@testset "Matrices" begin
  # tests with Aitchson's definitions
  d = 10
  D = d+1
  @test J(d) == ones(d, d)
  @test F(d) == [I(d) -ones(d)]
  @test norm(G(D) - I(D)  + J(D)/ D, Inf) < 1e-5
  @test H(d) == I(d) + J(d)

  square_matrices = [J G H]

  # tests of multiplications
  for M in square_matrices
    @test norm(M * [1:d...] - M(d) * [1:d...], Inf) < 1e-5
    @test norm([1:d...]' * M - [1:d...]' * M(d), Inf) < 1e-5
  end

  # tests of F (d x D)
  @test F * [1:D...] == F(d) * [1:D...]
  @test [1:d...]' * F == [1:d...]' * F(d)
end
