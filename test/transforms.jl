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
  t = (a=[1,0,1], b=[2,2,2], c=[3,3,0])
  a = alrinv(alr(t))
  c = clrinv(clr(t))
  i = ilrinv(ilr(t))
  @test Tables.matrix(a) ≈ Tables.matrix(c)
  @test Tables.matrix(c) ≈ Tables.matrix(i)
  @test Tables.matrix(a) ≈ Tables.matrix(i)

  # TableTransform.jl API
  t = (a=[1,0,1], b=[2,2,2], c=[3,3,0])
  ALR  = LogRatio(:alr)
  n, c = apply(ALR, t)
  talr = revert(ALR, n, c)
  CLR  = LogRatio(:clr)
  n, c = apply(CLR, t)
  tclr = revert(CLR, n, c)
  ILR  = LogRatio(:ilr)
  n, c = apply(ILR, t)
  tilr = revert(ILR, n, c)
  @test Tables.matrix(talr) ≈ Tables.matrix(tclr)
  @test Tables.matrix(tclr) ≈ Tables.matrix(tilr)
  @test Tables.matrix(talr) ≈ Tables.matrix(tilr)

  t = (a=[1,0,1], b=[2,2,2], c=[3,3,0])
  ALR = LogRatio(:alr, :b)
  n, c = apply(ALR, t)
  talr = revert(ALR, n, c)
  @test t |> ALR |> Tables.columnnames == (:a, :c)
  @test talr |> Tables.columnnames == (:a, :b, :c)

  t = (a=[1,0,1], b=[2,2,2], c=[3,3,0])
  ILR = LogRatio(:ilr, :b)
  n, c = apply(ILR, t)
  tilr = revert(ILR, n, c)
  @test t |> ILR |> Tables.columnnames == (:a, :c)
  @test tilr |> Tables.columnnames == (:a, :b, :c)
end
