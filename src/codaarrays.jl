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
  data  = Tables.matrix(table, transpose=true)
  CoDaArray{length(PARTS),Tuple(PARTS)}(data)
end

Base.getindex(array::CoDaArray{D,PARTS}, ind) where {D,PARTS} =
  Composition(PARTS, getfield(array, :data)[:,ind])

Base.size(array::CoDaArray) = (size(getfield(array, :data), 2),)

Base.IndexStyle(::Type{<:CoDaArray}) = IndexLinear()

function Base.getproperty(array::CoDaArray{D,PARTS}, part::Symbol) where {D,PARTS}
  ind = findfirst(isequal(part), PARTS)
  if isnothing(ind)
    throw(KeyError("$part"))
  else
    vec(getfield(array, :data)[ind,:])
  end
end

"""
    parts(array)

Parts in compositional `array`.
"""
parts(::CoDaArray{D,PARTS}) where {D,PARTS} = PARTS

"""
    compose(table, cols; keepcols=true, as=:coda)

Convert columns `cols` of `table` into parts of a
composition and save the result in a [`CoDaArray`](@ref).
If `keepcols` is set to `true`, then save the result `as`
a column in a new table with all other columns preserved.
"""
function compose(table, cols=Tables.columnnames(table);
                 keepcols=true, as=:coda)
  # construct compositional array from selected columns
  coda = table |> Select(cols) |> CoDaArray

  # different types of return
  if keepcols
    other = setdiff(Tables.columnnames(table), cols)
    osel  = table |> Select(other)
    ocol  = [o => Tables.getcolumn(osel, o) for o in other]
    # preserve input table type
    𝒯 = Tables.materializer(table)
    𝒯((; ocol..., as => coda))
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
Tables.getcolumn(c::Composition, i::Int)    = getfield(c, :data)[i]
Tables.getcolumn(c::Composition, n::Symbol) = getfield(c, :data)[n]
Tables.columnnames(c::Composition{D,PARTS}) where {D,PARTS} = PARTS