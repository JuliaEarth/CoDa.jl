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
  PARTS = Tables.columnnames(table)
  data = Tables.matrix(table, transpose=true)
  CoDaArray{length(PARTS),Tuple(PARTS)}(data)
end

Base.size(array::CoDaArray) = (size(getfield(array, :data), 2),)

Base.getindex(array::CoDaArray{D,PARTS}, ind::Int) where {D,PARTS} =
  Composition{D,PARTS}(view(getfield(array, :data), :, ind))

Base.IndexStyle(::Type{<:CoDaArray}) = IndexLinear()

function Base.getproperty(array::CoDaArray{D,PARTS}, part::Symbol) where {D,PARTS}
  ind = findfirst(isequal(part), PARTS)
  if isnothing(ind)
    throw(KeyError("$part"))
  else
    vec(getfield(array, :data)[ind, :])
  end
end

"""
    parts(array)

Parts in compositional `array`.
"""
parts(::CoDaArray{D,PARTS}) where {D,PARTS} = PARTS

"""
    compose(table, colnames; keepcols=true, as=:CODA)

Convert columns `colnames` of `table` into parts of a
composition and save the result in a [`CoDaArray`](@ref).
If `keepcols` is set to `true`, then save the result `as`
a column in a new table with all other columns preserved.
"""
function compose(table, colnames=nothing; keepcols=true, as=:CODA)
  cols = Tables.columns(table)
  names = Tables.columnnames(cols)
  snames = isnothing(colnames) ? names : Symbol.(colnames)
  scols = (nm => Tables.getcolumn(cols, nm) for nm in snames)
  # construct compositional array from selected columns
  coda = (; scols...) |> CoDaArray

  # different types of return
  if keepcols
    other = setdiff(names, snames)
    ocols = (nm => Tables.getcolumn(cols, nm) for nm in other)
    # preserve input table type
    (; ocols..., Symbol(as) => coda) |> Tables.materializer(table)
  else
    coda
  end
end

# -----------------
# TABLES INTERFACE
# -----------------

# implement table interface for CoDaArray
Tables.istable(::Type{<:CoDaArray}) = true
Tables.rowaccess(::Type{<:CoDaArray}) = true
Tables.rows(array::CoDaArray) = array

# implement row interface for Composition
Tables.getcolumn(c::Composition, i::Int) = getfield(c, :data)[i]
Tables.getcolumn(c::Composition, n::Symbol) = getfield(c, :data)[n]
Tables.columnnames(::Composition{D,PARTS}) where {D,PARTS} = PARTS
