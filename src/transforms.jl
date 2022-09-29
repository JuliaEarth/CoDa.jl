# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

# -----------------
# BASIC TRANSFORMS
# -----------------

include("transforms/closure.jl")
include("transforms/remainder.jl")

# ---------------------
# LOG-RATIO TRANSFORMS
# ---------------------

"""
    LogRatio

A log-ratio transform following the
[TableTransforms.jl](https://github.com/JuliaML/TableTransforms.jl)
interface.

See also [`ALR`](@ref), [`CLR`](@ref), [`ILR`](@ref).
"""
abstract type LogRatio <: StatelessFeatureTransform end

assertions(::Type{<:LogRatio}) = [TableTransforms.assert_continuous]

isrevertible(::Type{<:LogRatio}) = true

function applyfeat(transform::LogRatio, table, prep)
  # basic checks
  for assertion in assertions(transform)
    assertion(table)
  end

  # original variable names
  vars = Tables.columnnames(table)

  # reference variable
  rvar = refvar(transform, vars)
  @assert rvar ∈ vars "invalid reference variable"
  rind = first(indexin([rvar], collect(vars)))

  # permute columns if necessary
  ovars  = setdiff(vars, (rvar,))
  pvars  = [ovars; rvar]
  ptable = table |> Select(pvars)

  # transformation
  X = Tables.matrix(ptable)
  Y = applymatrix(transform, X)

  # new variable names
  n = newvars(transform, pvars)

  # return same table type
  𝒯 = (; zip(n, eachcol(Y))...)
  newtable = 𝒯 |> Tables.materializer(table)

  newtable, (rvar, rind)
end

function revertfeat(transform::LogRatio, table, fcache)
  # retrieve cache
  rvar, rind = fcache

  # trasformation
  Y = Tables.matrix(table)
  X = revertmatrix(transform, Y)

  # original variable names
  vars = Tables.columnnames(table)
  n = oldvars(transform, vars, rvar)

  # permute reference variable
  n[[rind,end]]   .= n[[end,rind]]
  X[:,[rind,end]] .= X[:,[end,rind]]

  # return same table type
  𝒯 = (; zip(n, eachcol(X))...)
  𝒯 |> Tables.materializer(table)
end

# to be implemented by log-ratio transforms
function refvar end
function newvars end
function oldvars end
function applymatrix end
function revertmatrix end

# ----------------
# IMPLEMENTATIONS
# ----------------

include("transforms/alr.jl")
include("transforms/clr.jl")
include("transforms/ilr.jl")