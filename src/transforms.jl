# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

# transforms in functional form
include("transforms/alr.jl")
include("transforms/clr.jl")
include("transforms/ilr.jl")

"""
    LogRatio(kind, [refvar])

A log-ratio transform of given `kind`.

Optionally, specify the reference variable
`refvar` for the the ratios. Default to the
last column of the input table.

## Examples

Additive log-ratio transform with denominator `O₂`:

```julia
julia> LogRatio(:ilr, :O₂)
```
"""
struct LogRatio <: Transform
  kind::Symbol
  refv::Union{Symbol,Nothing}

  function LogRatio(kind, refv)
    @assert kind ∈ (:alr,:clr,:ilr) "invalid log-ratio transform"
    new(kind, refv)
  end
end

LogRatio(kind) = LogRatio(kind, nothing)

function apply(transform::LogRatio, table)
  vars = Tables.columnnames(table)
  kind = transform.kind
  refv = transform.refv

  # permute columns if necessary
  pvars = if (kind ∈ (:alr, :ilr) && !isnothing(refv) && refv != last(vars))
    # sanity check with reference variable
    @assert refv ∈ vars "invalid reference variable"
    ovars = setdiff(vars, (refv,))
    Tuple([ovars; refv])
  else
    vars
  end

  # perform permutation
  ptable = TableOperations.select(table, pvars...)

  # apply transform
  newtable = _lr(kind, ptable)

  # return new table and cache
  newtable, nothing
end

function revert(transform::LogRatio, table, cache)
  # TODO
end

function _lr(kind, table)
  kind == :alr && return alr(table)
  kind == :clr && return clr(table)
  kind == :ilr && return ilr(table)
end

function _lrinv(kind, table)
  kind == :alr && return alrinv(table)
  kind == :clr && return clrinv(table)
  kind == :ilr && return ilrinv(table)
end