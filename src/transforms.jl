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
struct LogRatio <: Stateless
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
  ptable = if (kind ∈ (:alr, :ilr) && !isnothing(refv) && refv != last(vars))
    # sanity check with reference variable
    @assert refv ∈ vars "invalid reference variable"
    ovars = setdiff(vars, (refv,))
    pvars = [ovars; refv]
    TableOperations.select(table, pvars...)
  else
    table
  end

  # apply transform
  newtable = _lr(kind, ptable)

  # save index to restore later
  rvar = Tables.columnnames(ptable) |> last
  rind = indexin([rvar], collect(vars)) |> first

  # return new table and cache
  newtable, (rvar, rind)
end

function revert(transform::LogRatio, table, cache)
  kind = transform.kind

  # invert the transform
  otable = _lrinv(kind, table)

  # adjust columns if necessary
  ocols = Tables.columns(otable)
  if kind ∈ (:alr, :ilr)
    rvar, rind = cache
    vars = Tables.columnnames(table) |> collect
    oinds = [1:rind-1; length(vars)+1; rind:length(vars)]
    ovars = [vars[begin:rind-1]; rvar; vars[rind:end]]
    ovals = [Tables.getcolumn(ocols, i) for i in oinds]
    𝒯 = (; zip(ovars, ovals)...)
    𝒯 |> Tables.materializer(table)
  else
    otable
  end
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