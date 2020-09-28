@testset "Transforms" begin
  c = Composition(1,2,3)
  @test alrinv(alr(c)) == c
  @test clrinv(clr(c)) == c
  @test ilrinv(ilr(c)) == c
end
