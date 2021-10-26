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
   clr(table)

Centered log-ratio transformation of `table`.
"""
function clr(table)
  # design matrix
  X = Tables.matrix(table) .|> Float64
  n = Tables.columnnames(table)

  # new variable names
  vars = collect(n)

  # transformation
  μ = geomean.(eachrow(X))
  L = log.(X .+ eps())
  l = log.(μ .+ eps())
  Y = L .- l

  # return same table type
  T = (; zip(vars, eachcol(Y))...)
  T |> Tables.materializer(table)
end

"""
    clrinv(table)

Inverse clr transformation of `table`.
"""
function clrinv(table)
  # design matrix
  Y = Tables.matrix(table) .|> Float64
  n = Tables.columnnames(table)

  # new variable names
  vars = collect(n)

  # trasformation
  E = exp.(Y)
  X = mapslices(𝓒, E, dims=2)

  # return same table type
  T = (; zip(vars, eachcol(X))...)
  T |> Tables.materializer(table)
end