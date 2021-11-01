# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    LogRatio

A log-ratio transform following the
[TableTransforms.jl](https://github.com/JuliaML/TableTransforms.jl)
interface.

See also [`ALR`](@ref), [`CLR`](@ref), [`ILR`](@ref).
"""
abstract type LogRatio <: Stateless end

assertions(::Type{<:LogRatio}) = [TT.assert_continuous]

isrevertible(::Type{<:LogRatio}) = true

function apply(transform::LogRatio, table)
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
  ptable = TableOperations.select(table, pvars...)

  # design matrix
  X = Tables.matrix(ptable)
  n = Tables.columnnames(ptable)

  # new variable names
  nvars = newvars(transform, n)

  # transformation
  Y = applymatrix(transform, X)

  # return same table type
  𝒯 = (; zip(nvars, eachcol(Y))...)
  newtable = 𝒯 |> Tables.materializer(table)

  newtable, (rvar, rind)
end

# to be implemented by log-ratio transforms
function refvar end
function newvars end
function applymatrix end

# ----------------
# IMPLEMENTATIONS
# ----------------

include("transforms/alr.jl")
include("transforms/clr.jl")
include("transforms/ilr.jl")