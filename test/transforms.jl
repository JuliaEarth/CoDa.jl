@testset "Transforms" begin
  c = Composition(1.0,2.0,3.0)
  @test alrinv(alr(c)) == c
  @test clrinv(clr(c)) == c
  @test ilrinv(ilr(c)) == c
end
