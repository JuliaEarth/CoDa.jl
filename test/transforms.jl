@testset "Transforms" begin
  # compositions
  for c in [Composition(1,2,3),
            Composition(0,2,3),
            Composition(1,2,0)]
    @test alrinv(alr(c)) == c
    @test clrinv(clr(c)) == c
    @test ilrinv(ilr(c)) == c
  end

  # TableTransform.jl API
  t = (a=Float64[1,0,1], b=Float64[2,2,2], c=Float64[3,3,0])
  n, c = apply(ALR(), t)
  talr = revert(ALR(), n, c)
  n, c = apply(CLR(), t)
  tclr = revert(CLR(), n, c)
  n, c = apply(ILR(), t)
  tilr = revert(ILR(), n, c)
  @test Tables.matrix(talr) ≈ Tables.matrix(tclr)
  @test Tables.matrix(tclr) ≈ Tables.matrix(tilr)
  @test Tables.matrix(talr) ≈ Tables.matrix(tilr)

  n, c = apply(ALR(:b), t)
  talr = revert(ALR(:b), n, c)
  @test n    |> Tables.columnnames == (:a, :c)
  @test talr |> Tables.columnnames == (:a, :b, :c)

  n, c = apply(ILR(:b), t)
  tilr = revert(ILR(:b), n, c)
  @test n    |> Tables.columnnames == (:a, :c)
  @test tilr |> Tables.columnnames == (:a, :b, :c)
end
