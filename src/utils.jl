# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    readcoda(args...; codanames=nothing, kwargs...)

Read data from disk using `CSV.read`, optionally specifying
the columns `codanames` with the parts of the composition.
If `nothing` is specified, interpret all columns as parts.

The arguments `args` and keyword arguments `kwargs` are
forwarded to the `CSV.read` function, please check their
documentation for more details.

The option `codanames` can also be a pair as described in
the documentation of [`compose`](@ref).
"""
function readcoda(args...; codanames=nothing, kwargs...)
  table = DataFrame!(CSV.File(args...; kwargs...))
  cols = if isnothing(codanames)
    Tuple(Tables.columnnames(table))
  else
    codanames
  end
  compose(table, cols)
end

"""
    compose(table, (:c1, c2, ..., :cn) [=> :coda])

Convert columns `:c1`, `:c2`, ..., `:cn` of `table`
into parts of a composition and save it as a new
column with name `:coda`.

## Example

```julia
# create a new table with `:coda` column
compose(table, (:Cd, :Cu, :Pb))

# create a new table with `:comp` column
compose(table, (:Cd, :Cu, :Pb) => :comp)
```
"""
function compose(table, spec::Pair{NTuple{N,Symbol},Symbol}) where {N}
  # retrieve specification
  cols, name = spec

  # non-compositional columns
  ctable = Tables.columns(table)
  onames = setdiff(Tables.columnnames(table), cols)
  others = [o => Tables.getcolumn(ctable, o) for o in onames]

  # new column with compositions
  nparts = length(cols)
  coda = map(Tables.rows(table)) do row
    parts = ntuple(i -> Tables.getcolumn(row, cols[i]), nparts)
    Composition(cols, parts)
  end

  # preserve table type in result
  𝒯 = Tables.materializer(table)

  𝒯((; others..., name => coda))
end

compose(table, cols::Pair{NTuple{N,String},String}) where {N} =
  compose(table, Symbol.(first(cols)) => Symbol(last(cols)))

compose(table, cols::NTuple{N,Symbol}) where {N} =
  compose(table, cols => :coda)

compose(table, cols::NTuple{N,String}) where {N} =
  compose(table, cols => "coda")
