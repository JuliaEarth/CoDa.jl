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

# -----------------
# TABLES INTERFACE
# -----------------

# implement table interface for CoDaArray
Tables.istable(::Type{<:CoDaArray}) = true
Tables.rowaccess(::Type{<:CoDaArray}) = true
Tables.rows(array::CoDaArray) = array

# implement row interface for Composition
Tables.getcolumn(c::Composition, i::Int)    = getfield(c, :data)[i]
Tables.getcolumn(c::Composition, n::Symbol) = getproperty(c, n)
Tables.columnnames(c::Composition{D,PARTS}) where {D,PARTS} = PARTS