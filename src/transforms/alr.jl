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
   ALR([refvar])

Additive log-ratio transform following the
[TableTransforms.jl](https://github.com/JuliaML/TableTransforms.jl)
interface.

Optionally, specify the reference variable `refvar` for the ratios.
Default to the last column of the input table.
"""
struct ALR <: LogRatio
  refvar::Union{Symbol,Nothing}
end

ALR() = ALR(nothing)

function apply(transform::ALR, table)
  # basic checks
  for assertion in assertions(transform)
    assertion(table)
  end

  # original variable names
  vars = Tables.columnnames(table)

  # reference variable
  refvar = isnothing(transform.refvar) ? last(vars) : transform.refvar

  @assert refvar ∈ vars "invalid reference variable"

  # permute columns if necessary
  ptable = tableperm(table, refvar)

  # design matrix
  X = Tables.matrix(ptable)
  n = Tables.columnnames(ptable)

  # new variable names
  nvars = collect(n)[begin:end-1]

  # transformation
  L = log.(X .+ eps())
  Y = L[:,begin:end-1] .- L[:,end]

  # return same table type
  𝒯 = (; zip(nvars, eachcol(Y))...)
  newtable = 𝒯 |> Tables.materializer(table)

  # save reference index to revert later
  refind = indexin([refvar], collect(vars)) |> first

  newtable, (refvar, refind)
end

function revert(::ALR, table, cache)
  # retrieve cache
  refvar, refind = cache

  # design matrix
  Y = Tables.matrix(table)
  n = Tables.columnnames(table)

  # original variable names
  vars = [collect(n); refvar]

  # trasformation
  E = [exp.(Y) ones(size(Y,1))]
  X = mapslices(𝓒, E, dims=2)

  # permute reference variable
  vars[[refind,end]] .= vars[[end,refind]]
  X[:,[refind,end]]  .= X[:,[end,refind]]

  # return same table type
  𝒯 = (; zip(vars, eachcol(X))...)
  𝒯 |> Tables.materializer(table)
end