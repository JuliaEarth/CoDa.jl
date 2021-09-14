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
    @test norm(M(d) * collect(1:d) -  M * collect(1:d), Inf) < 1e-5
    @test norm(collect(1:d)' * M(d) - collect(1:d)' * M, Inf) < 1e-5
  end

  # tests of F (d x D)
  @test F(d) * collect(1:D) ==  F * collect(1:D)
  @test collect(1:d)' * F(d) ==  collect(1:d)' * F
end
