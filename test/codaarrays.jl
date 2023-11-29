@testset "CoDaArray" begin
  table = (a=[1, 2, 3], b=[4, 5, 6], c=[7, 8, 9])
  array = CoDaArray(table)
  rows = array
  @test length(array) == 3
  @test array[1] == Composition(a=1, b=4, c=7)
  @test array[2] == Composition(a=2, b=5, c=8)
  @test array[3] == Composition(a=3, b=6, c=9)
  @test array[[1, 2]] == [Composition(a=1, b=4, c=7), Composition(a=2, b=5, c=8)]
  @test array[[1, 3]] == [Composition(a=1, b=4, c=7), Composition(a=3, b=6, c=9)]
  @test array[[2, 3]] == [Composition(a=2, b=5, c=8), Composition(a=3, b=6, c=9)]
  @test Tables.istable(array)
  @test Tables.rowaccess(array) == true
  @test Tables.rows(array) == rows
  @test Tables.getcolumn(rows[1], 1) == 1.0
  @test Tables.getcolumn(rows[1], :a) == 1.0
  @test Tables.columnnames(rows[1]) == (:a, :b, :c)

  array = compose(jura, (:Cd, :Cu, :Pb, :Co, :Cr, :Ni, :Zn), keepcols=false)
  @test parts(array) == (:Cd, :Cu, :Pb, :Co, :Cr, :Ni, :Zn)
  @test length(array) == 359
  @test array[1] == Composition(Cd=1.74, Cu=25.72, Pb=77.36, Co=9.32, Cr=38.32, Ni=21.32, Zn=92.56)
  @test length(array.Cd) == 359
  @test length(array.Cu) == 359
  @test array.Cd[1] == 1.74
  @test array.Cu[1] == 25.72
  @test_throws KeyError array.INVALID

  table = compose(jura, (:Cd, :Cu, :Pb, :Co, :Cr, :Ni, :Zn))
  @test Tables.columnnames(table) == [:X, :Y, :Rock, :Land, :CODA]
  @test Tables.getcolumn(table, :CODA) == array

  table = compose(jura, (:Cd, :Cu, :Pb, :Co, :Cr, :Ni, :Zn), as=:comps)
  @test Tables.columnnames(table) == [:X, :Y, :Rock, :Land, :comps]
  @test Tables.getcolumn(table, :comps) == array

  table = compose(jura, ("Cd", "Cu", "Pb", "Co", "Cr", "Ni", "Zn"), as="comps")
  @test Tables.columnnames(table) == [:X, :Y, :Rock, :Land, :comps]
  @test Tables.getcolumn(table, :comps) == array

  # performance test
  rng = MersenneTwister(2)
  N = 100_000
  inds = shuffle(rng, 1:N)
  array = CoDaArray((a=rand(rng, N), b=rand(rng, N), c=rand(rng, N)))
  @test @elapsed(array[inds]) < 0.5
end
