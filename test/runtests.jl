using CoDa
using Test

# list of maintainers
maintainers = ["juliohm"]

# environment settings
istravis = "TRAVIS" ∈ keys(ENV)
ismaintainer = "USER" ∈ keys(ENV) && ENV["USER"] ∈ maintainers
datadir = joinpath(@__DIR__,"data")

# list of tests
testfiles = [
  "compositions.jl",
  "transforms.jl"
]

@testset "CoDa.jl" begin
  for testfile in testfiles
    include(testfile)
  end
end
