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

cardinality(::LogRatio) = ManyToMany()

function apply(table, t::LogRatio; inv=false)
  vars = Tables.columnnames(table)

  # permute columns of table if necessary
  𝒯 = if (t.kind ∈ (:alr, :ilr) && !inv &&
          !isnothing(t.refv) && t.refv != last(vars))
    # sanity check with reference variable
    @assert t.refv ∈ vars "invalid reference variable"

    # permute columns of table
    ovars = setdiff(vars, (t.refv,))
    pvars = [ovars; t.refv]
    TableOperations.select(table, pvars...)
  else
    # forward input table
    table
  end

  # return appropriate transform
  t.kind == :alr && !inv && return alr(𝒯)
  t.kind == :alr &&  inv && return alrinv(𝒯)
  t.kind == :clr && !inv && return clr(𝒯)
  t.kind == :clr &&  inv && return clrinv(𝒯)
  t.kind == :ilr && !inv && return ilr(𝒯)
  t.kind == :ilr &&  inv && return ilrinv(𝒯)
end