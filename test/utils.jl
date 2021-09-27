@testset "Utils" begin
  @testset "compose" begin
    df1 = compose(jura, (:Cd, :Cu, :Pb, :Co, :Cr, :Ni, :Zn))
    @test names(df1) == ["X","Y","Rock","Land","coda"]
    @test size(df1) == (359, 5)
    @test df1[1,"coda"] == Composition(Cd=1.74, Cu=25.72, Pb=77.36, Co=9.32, Cr=38.32, Ni=21.32, Zn=92.56)

    df2 = compose(jura, ("Cd", "Cu", "Pb", "Co", "Cr", "Ni", "Zn"))
    @test df1 == df2

    df3 = compose(jura, (:Cd, :Cu, :Pb, :Co, :Cr, :Ni, :Zn) => :Composition)
    df4 = compose(jura, ("Cd", "Cu", "Pb", "Co", "Cr", "Ni", "Zn") => "Composition")
    @test names(df3) == names(df4) == ["X","Y","Rock","Land","Composition"]
  end
end
