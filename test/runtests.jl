using CoDa
using Test
using DataFrames
using CSV
using DataDeps
using RData

# list of maintainers
maintainers = ["juliohm"]

# environment settings
istravis = "TRAVIS" ∈ keys(ENV)
ismaintainer = "USER" ∈ keys(ENV) && ENV["USER"] ∈ maintainers
datadir = joinpath(@__DIR__,"data")
mkpath(datadir)

# download and setup data dependencies
register(DataDep("juraset", "A geochemical dataset from the Swiss Jura",
      "https://github.com/cran/compositions/raw/master/data/juraset.rda"))
dataset = RData.load(joinpath(datadep"juraset", "juraset.rda"))
CSV.write(joinpath(datadir,"juraset.csv"), dataset["juraset"])

# list of tests
testfiles = [
  "compositions.jl",
  "transforms.jl",
  "utils.jl"
]

@testset "CoDa.jl" begin
  for testfile in testfiles
    include(testfile)
  end
end
