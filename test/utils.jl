@testset "Utils" begin
  @testset "readcoda" begin
    df = readcoda(joinpath(datadir,"juraset.csv"); codanames=(:Cd, :Cu, :Pb, :Co, :Cr, :Ni, :Zn));
    @test names(df) == ["X", "Y", "Rock", "Land", "coda"]
    @test size(df) == (359, 5)
    @test df[1, "coda"] == Composition(Cd=1.74, Cu=25.72, Pb=77.36, Co=9.32, Cr=38.32, Ni=21.32, Zn=92.56)

    df = readcoda(joinpath(datadir,"juraset.csv"); codanames=("Cd", "Cu", "Pb", "Co", "Cr", "Ni", "Zn"));
    @test names(df) == ["X", "Y", "Rock", "Land", "coda"]
    @test size(df) == (359, 5)
    @test df[1, "coda"] == Composition(Cd=1.74, Cu=25.72, Pb=77.36, Co=9.32, Cr=38.32, Ni=21.32, Zn=92.56)

    df = readcoda(joinpath(datadir,"juraset.csv"); codanames=(:Cd, :Cu, :Pb, :Co, :Cr, :Ni, :Zn) => :customcolname);
    @test names(df) == ["X", "Y", "Rock", "Land", "customcolname"]
  end

  @testset "compose" begin
    data = DataFrame!(CSV.File(joinpath(datadir,"juraset.csv")))
    df = compose(data, (:Cd, :Cu, :Pb, :Co, :Cr, :Ni, :Zn))
    @test names(df) == ["X", "Y", "Rock", "Land", "coda"]
    @test size(df) == (359, 5)
    @test df[1, "coda"] == Composition(Cd=1.74, Cu=25.72, Pb=77.36, Co=9.32, Cr=38.32, Ni=21.32, Zn=92.56)

    df = compose(data, ("Cd", "Cu", "Pb", "Co", "Cr", "Ni", "Zn"))
    @test names(df) == ["X", "Y", "Rock", "Land", "coda"]
    @test size(df) == (359, 5)
    @test df[1, "coda"] == Composition(Cd=1.74, Cu=25.72, Pb=77.36, Co=9.32, Cr=38.32, Ni=21.32, Zn=92.56)

    df = compose(data, (:Cd, :Cu, :Pb, :Co, :Cr, :Ni, :Zn) => :customcolname)
    @test names(df) == ["X", "Y", "Rock", "Land", "customcolname"]

    df = compose(data, ("Cd", "Cu", "Pb", "Co", "Cr", "Ni", "Zn") => :customcolname)
    @test names(df) == ["X", "Y", "Rock", "Land", "customcolname"]

  end
end
