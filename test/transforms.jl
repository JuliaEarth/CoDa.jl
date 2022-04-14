@testset "Transforms" begin
  # compositions
  for c in [Composition(1,2,3),
            Composition(0,2,3),
            Composition(1,2,0)]
    @test alrinv(alr(c)) == c
    @test clrinv(clr(c)) == c
    @test ilrinv(ilr(c)) == c
  end

  # convenience methods for heap-allocated vectors
  @test alrinv([1,2,3]) isa Composition{4}
  @test clrinv([1,2,3]) isa Composition{3}
  @test ilrinv([1,2,3]) isa Composition{4}

  # TableTransform.jl API
  t = (a=[1.,0.,1.], b=[2.,2.,2.], c=[3.,3.,0.])
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
  @test n    |> Tables.columnnames |> collect == [:a, :c]
  @test talr |> Tables.columnnames |> collect == [:a, :b, :c]

  n, c = apply(ILR(:b), t)
  tilr = revert(ILR(:b), n, c)
  @test n    |> Tables.columnnames |> collect == [:a, :c]
  @test tilr |> Tables.columnnames |> collect == [:a, :b, :c]

  # Tests for Closure
  t = (a=[2.,66.,0.], b=[4.,22.,2.], c=[4.,12.,98.])
  n, c = apply(Closure(), t)
  tcls = revert(Closure(), n, c)
  @test Tables.matrix(n) ≈ [0.2 0.4 0.4; 0.66 0.22 0.12; 0.00 0.02 0.98;]
  @test Tables.matrix(tcls) ≈ Tables.matrix(t)

  # Tests for Remainder
  t = (a=[2.,66.,0.], b=[4.,22.,2.], c=[4.,12.,98.])
  n, c = apply(Remainder(), t)
  trem = revert(Remainder(), n, c)
  Xt = Tables.matrix(t)
  Xn = Tables.matrix(n)
  @test Xn[:, 1:end-1] == Xt
  @test all(x -> 0 ≤ x ≤ c, Xn[:, end])
  @test n    |> Tables.columnnames |> collect == [:a, :b, :c, :remainder]
  @test trem |> Tables.columnnames |> collect == [:a, :b, :c]

  t = (a=[1.,10.,0.], b=[1.,5.,0.], c=[4.,2.,1.])
  n = reapply(Remainder(), t, c)
  Xn = Tables.matrix(n)
  @test all(x -> 0 ≤ x ≤ c, Xn[:, end])

  t = (a=[1.,10.,0.], b=[1.,5.,0.], remainder=[4.,2.,1.])
  names = t |> Remainder() |> Tables.columnnames |> collect 
  @test names == [:a, :b, :remainder, :remainder_]

  t = (a=[1.,10.,0.], b=[1.,5.,0.], remainder=[4.,2.,1.])
  n1, c1 = apply(Remainder(), t)
  n2 = reapply(Remainder(), t, c1)
  @test n1 == n2
end
