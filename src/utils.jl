# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

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
  D = length(cols)

  # non-compositional columns
  ctable = Tables.columns(table)
  onames = setdiff(Tables.columnnames(table), cols)
  others = [o => Tables.getcolumn(ctable, o) for o in onames]

  # new column with compositions
  coda = map(Tables.rows(table)) do row
    comps = ntuple(i -> Tables.getcolumn(row, cols[i]), D)
    Composition(cols, comps)
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

compose(table) = compose(table, Tables.columnnames(table))