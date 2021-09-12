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
    @test M(d) == M * I(d)
    @test M(d) == I(d) * M
    @test M(d) * collect(1:d) ==  M * collect(1:d)
    @test collect(1:d)' * M(d) ==  collect(1:d)' * M
  end

  # tests of additions
  for M in square_matrices
    @test M(d) + M(d) == M + M(d)
    @test M(d) + M(d) == M(d) + M
    @test M(d) + I(d) == M + I(d)
    @test I(d) + M(d) == I(d) + M
  end

  # tests of F (d x D)
  @test F(d) == F * I(D)
  @test F(d) == I(d) * F
  @test F(d) * collect(1:D) ==  F * collect(1:D)
  @test collect(1:d)' * F(d) ==  collect(1:d)' * F
  @test F(d) + F(d) == F + F(d)
  @test F(d) + F(d) == F(d) + F
  @test F(d) + [I(d) ones(Int,d)] == F + [I(d) ones(Int,d)]
  @test [I(d) ones(Int,d)] + F(d) == [I(d) ones(Int,d)] + F
end
