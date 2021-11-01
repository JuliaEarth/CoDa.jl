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

# ----------------
# IMPLEMENTATIONS
# ----------------

# helper function to permute columns of
# table based on a reference variable
function tableperm(table, var)
  vars  = Tables.columnnames(table)
  ovars = setdiff(vars, (var,))
  pvars = [ovars; var]
  TableOperations.select(table, pvars...)
end

include("transforms/alr.jl")
include("transforms/clr.jl")
include("transforms/ilr.jl")