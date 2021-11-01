# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

# -------------
# COMPOSITIONS
# -------------

"""
    clr(c)

Centered log-ratio transformation of composition `c`.
"""
function clr(c::Composition{D}) where {D}
  w = components(c) .+ eps()
  μ = geomean(w)
  SVector(ntuple(i -> log(w[i] / μ), D))
end

"""
    clrinv(x)

Inverse clr transformation of coordinates `x`.
"""
clrinv(x::SVector{D,T}) where {D,T<:Real} =
  Composition(𝓒(exp.(x)))

# -------
# TABLES
# -------

"""
   CLR()

Centered log-ratio transform following the
[TableTransforms.jl](https://github.com/JuliaML/TableTransforms.jl)
interface.
"""
struct CLR <: LogRatio end

refvar(::CLR, vars) = last(vars)

newvars(::CLR, n) = collect(n)

function applymatrix(::CLR, X)
  μ = geomean.(eachrow(X))
  L = log.(X .+ eps())
  l = log.(μ .+ eps())
  L .- l
end

function revert(::CLR, table, cache)
  # design matrix
  Y = Tables.matrix(table)
  n = Tables.columnnames(table)

  # original variable names
  vars = collect(n)

  # trasformation
  E = exp.(Y)
  X = mapslices(𝓒, E, dims=2)

  # return same table type
  𝒯 = (; zip(vars, eachcol(X))...)
  𝒯 |> Tables.materializer(table)
end