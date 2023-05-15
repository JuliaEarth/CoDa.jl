@testset "Scitypes" begin
  @test scitype(Composition(a=1, b=2)) === Compositional{2}
  @test scitype(Composition(a=1, b=2, c=3)) === Compositional{3}

  table = (a=rand(100), b=rand(100), c=rand(100), d=1:100)
  coda = compose(table, (:a, :b, :c))
  @test schema(coda).scitypes == (Count, Compositional{3})
end
