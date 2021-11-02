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

  # Tests for Closure
  t = (a=Float64[2,66,0], b=Float64[4,22,2], c=Float64[4,12,98])
  n, c = apply(Closure(), t)
  tcls = revert(Closure(), n, c)
  @test Tables.matrix(n) ≈ [0.2 0.4 0.4; 0.66 0.22 0.12; 0.00 0.02 0.98;]
  @test Tables.matrix(tcls) ≈ Tables.matrix(t)

  # Tests for Remainder
  t = (a=Float64[2,66,0], b=Float64[4,22,2], c=Float64[4,12,98])
  n, c = apply(Remainder(), t)
  trem = revert(Remainder(), n, c)
  @test Tables.matrix(n)[:, 1:end-1] == Tables.matrix(t)
  @test all(x -> 0 ≤ x ≤ c, Tables.matrix(n)[:, end])
  @test n    |> Tables.columnnames == (:a, :b, :c, :total_minus_abc)
  @test trem |> Tables.columnnames == (:a, :b, :c)

  t = (a=Float64[1,10,0], b=Float64[1,5,0], c=Float64[4,2,1])
  n, c = reapply(Remainder(), t, c)
  @test all(x -> 0 ≤ x ≤ c, Tables.matrix(n)[:, end])
end
