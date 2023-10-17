@testset "log-ratio" begin
  # compositions
  for c in [Composition(1, 2, 3), Composition(0, 2, 3), Composition(1, 2, 0)]
    @test alrinv(alr(c)) == c
    @test clrinv(clr(c)) == c
    @test ilrinv(ilr(c)) == c
  end

  # convenience methods for heap-allocated vectors
  @test alrinv([1, 2, 3]) isa Composition{4}
  @test clrinv([1, 2, 3]) isa Composition{3}
  @test ilrinv([1, 2, 3]) isa Composition{4}
end
