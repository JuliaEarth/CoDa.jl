# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    CoDaArray(table)

Construct an array of compositional data from `table`.
"""
struct CoDaArray{D,PARTS} <: AbstractVector{Composition{D,PARTS}}
  data::Matrix{Union{Float64,Missing}}
end

function CoDaArray(table)
  parts = Tables.columnnames(table)
  data  = Tables.matrix(table) |> transpose
  CoDaArray{length(parts),parts}(data)
end

Base.getindex(array::CoDaArray{D,PARTS}, i) where {D,PARTS} =
  Composition(PARTS, array.data[:,i])

Base.size(array::CoDaArray) = (size(array.data, 2),)

Base.IndexStyle(::Type{<:CoDaArray}) = IndexLinear()

"""
    parts(array)

Parts in compositional `array`.
"""
parts(::CoDaArray{D,PARTS}) where {D,PARTS} = PARTS

"""
    compose(table, (:c1, c2, ..., :cn))

Convert columns `:c1`, `:c2`, ..., `:cn` of `table`
into parts of a composition and save the result in
a [`CoDaArray`](@ref).

## Example

```julia
# create a new compositional array
compose(table, (:Cd, :Cu, :Pb))
```
"""
function compose(table, cols=Tables.columnnames(table))
  s = TableOperations.select(table, cols...)
  t = Tables.columntable(s) # see https://github.com/JuliaData/TableOperations.jl/issues/25
  CoDaArray(t)
end

# -----------------
# TABLES INTERFACE
# -----------------

# implement table interface for CoDaArray
Tables.istable(::Type{<:CoDaArray}) = true
Tables.rowaccess(::Type{<:CoDaArray}) = true
Tables.rows(array::CoDaArray) = array

# implement row interface for Composition
Tables.getcolumn(c::Composition, i::Int)    = getfield(c, :data)[i]
Tables.getcolumn(c::Composition, n::Symbol) = getfield(c, :data)[n]
Tables.columnnames(c::Composition{D,PARTS}) where {D,PARTS} = PARTS