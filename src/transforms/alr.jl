# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

# -------------
# COMPOSITIONS
# -------------

"""
    alr(c)

Additive log-ratio transformation of composition `c`.
"""
function alr(c::Composition{D}) where {D}
  w = components(c) .+ eps()
  SVector(ntuple(i -> log(w[i] / w[D]), D-1))
end

"""
    alrinv(x)

Inverse alr transformation of coordinates `x`.
"""
alrinv(x::SVector{D,T}) where {D,T<:Real} =
  Composition(𝓒([exp.(x); SVector(one(T))]))

# -------
# TABLES
# -------

"""
   alr(table)

Additive log-ratio transformation of `table`.
"""
function alr(table)
  # design matrix
  X = Tables.matrix(table) .|> Float64
  n = Tables.columnnames(table)

  # new variable names
  vars = collect(n)[begin:end-1]

  # transformation
  L = log.(X .+ eps())
  Y = L[:,begin:end-1] .- L[:,end]

  # return same table type
  T = (; zip(vars, eachcol(Y))...)
  T |> Tables.materializer(table)
end

"""
    alrinv(table)

Inverse alr transformation of `table`.
"""
function alrinv(table)
  # design matrix
  Y = Tables.matrix(table) .|> Float64
  n = Tables.columnnames(table)

  # new variable names
  vars = [collect(n); Symbol("total_minus_"*join(n,""))]

  # trasformation
  E = [exp.(Y) ones(size(Y,1))]
  X = mapslices(𝓒, E, dims=2)

  # return same table type
  T = (; zip(vars, eachcol(X))...)
  T |> Tables.materializer(table)
end