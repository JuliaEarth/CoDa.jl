@testset "Matrices" begin
  # tests with Aitchson's definitions
  d = 10
  D = d + 1
  @test J(d) == ones(d, d)
  @test F(d) == [I(d) -ones(d)]
  @test G(D) ≈ I(D) - J(D) / D
  @test H(d) == I(d) + J(d)

  # tests of multiplications
  for M in [J G H]
    @test M * [1:d...] ≈ M(d) * [1:d...]
    @test [1:d...]' * M ≈ [1:d...]' * M(d)
  end

  # tests of F (d x D)
  @test F * [1:D...] == F(d) * [1:D...]
  @test [1:d...]' * F == [1:d...]' * F(d)
end
