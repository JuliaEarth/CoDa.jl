@testset "Transforms" begin
  # compositions
  for c in [Composition(1,2,3),
            Composition(0,2,3),
            Composition(1,2,0)]
    @test alrinv(alr(c)) == c
    @test clrinv(clr(c)) == c
    @test ilrinv(ilr(c)) == c
  end

  # tables
  table = (a=[1,0,1], b=[2,2,2], c=[3,3,0])
  a = alrinv(alr(table))
  c = clrinv(clr(table))
  i = ilrinv(ilr(table))
  @test Tables.matrix(a) ≈ Tables.matrix(c)
  @test Tables.matrix(c) ≈ Tables.matrix(i)
  @test Tables.matrix(a) ≈ Tables.matrix(i)

  # FeatureTransforms.jl API
  table = (a=[1,0,1], b=[2,2,2], c=[3,3,0])
  ALR   = LogRatio(:alr)
  CLR   = LogRatio(:clr)
  ILR   = LogRatio(:ilr)
  a = ALR(ALR(table), inv=true)
  c = CLR(CLR(table), inv=true)
  i = ILR(ILR(table), inv=true)
  @test Tables.matrix(a) ≈ Tables.matrix(c)
  @test Tables.matrix(c) ≈ Tables.matrix(i)
  @test Tables.matrix(a) ≈ Tables.matrix(i)

  table = (a=[1,0,1], b=[2,2,2], c=[3,3,0])
  ALR   = LogRatio(:alr, :b)
  ILR   = LogRatio(:ilr, :b)
  @test ALR(table) |> keys == (:a, :c)
  @test ILR(table) |> keys == (:a, :c)
  @test ALR(table, inv=true) |> keys == (:a, :b, :c, :total_minus_abc)
  @test ILR(table, inv=true) |> keys == (:a, :b, :c, :total_minus_abc)
end
