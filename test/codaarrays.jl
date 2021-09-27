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
end