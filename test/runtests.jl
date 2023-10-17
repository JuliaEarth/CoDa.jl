using CoDa
using CSV
using RData
using Tables
using DataDeps
using Distances
using LinearAlgebra
using Test, Random

# accept downloads without interaction
ENV["DATADEPS_ALWAYS_ACCEPT"] = true

# environment settings
datadir = joinpath(@__DIR__, "data")

# download and setup data dependencies
register(
  DataDep(
    "juraset",
    "A geochemical dataset from the Swiss Jura",
    "https://github.com/cran/compositions/raw/master/data/juraset.rda",
    "0fcf23fbca1d6fcb58ae0de6f11365f39fa3df02828128708185ebf45b002382"
  )
)
rda = joinpath(datadep"juraset", "juraset.rda")
jura = RData.load(rda)["juraset"]
CSV.write(joinpath(datadir, "jura.csv"), jura)

# list of tests
testfiles = ["compositions.jl", "codaarrays.jl", "distances.jl", "logratio.jl", "covariances.jl", "matrices.jl"]

@testset "CoDa.jl" begin
  for testfile in testfiles
    include(testfile)
  end
end
