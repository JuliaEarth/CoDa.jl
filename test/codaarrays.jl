@testset "CoDaArray" begin
  table = (a=[1,2,3], b=[4,5,6], c=[7,8,9])
  array = CoDaArray(table)
  rows  = array
  @test length(array) == 3
  @test array[1] == Composition(a=1, b=4, c=7)
  @test array[2] == Composition(a=2, b=5, c=8)
  @test array[3] == Composition(a=3, b=6, c=9)
  @test Tables.istable(array)
  @test Tables.rowaccess(array) == true
  @test Tables.rows(array) == rows
  @test Tables.getcolumn(rows[1], 1) == 1.0
  @test Tables.getcolumn(rows[1], :a) == 1.0
  @test Tables.columnnames(rows[1]) == (:a, :b, :c)

  array = compose(jura, (:Cd, :Cu, :Pb, :Co, :Cr, :Ni, :Zn))
  @test parts(array) == (:Cd, :Cu, :Pb, :Co, :Cr, :Ni, :Zn)
  @test length(array) == 359
  @test array[1] == Composition(Cd=1.74, Cu=25.72, Pb=77.36, Co=9.32, Cr=38.32, Ni=21.32, Zn=92.56)

  table = compose(jura, (:Cd, :Cu, :Pb, :Co, :Cr, :Ni, :Zn), keepcols=true)
  @test Tables.columnnames(table) == [:X,:Y,:Rock,:Land,:coda]
  @test Tables.getcolumn(table, :coda) == array

  table = compose(jura, (:Cd, :Cu, :Pb, :Co, :Cr, :Ni, :Zn), keepcols=true, as=:comps)
  @test Tables.columnnames(table) == [:X,:Y,:Rock,:Land,:comps]
  @test Tables.getcolumn(table, :comps) == array
end