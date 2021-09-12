@testset "Matrices" begin
  # tests with Aitchson's definitions
  d = 10
  D = d+1
  @test JColumn(d) == ones(d)
  @test JMatrix(d) == ones(d, d)
  @test F(d) == [I(d) -ones(d)]
  @test maximum(abs.(G(D) - I(D)  + JMatrix(D)/ D)) < 1e-5
  @test H(d) == I(d) + JMatrix(d)
end
