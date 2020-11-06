# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    readcoda(args...; codanames=(), kwargs...)
    readcoda(args...; codanames=() => :coda, kwargs...)

Read data from disk using `CSV.read`, optionally specifying
the columns `codanames` with compositional data.

The arguments `args` and keyword arguments `kwargs` are
forwarded to the `CSV.read` function, please check their
documentation for more details.

This function returns a collection of [`Composition`](@ref)
objects whose parts are the columns `codanames` in the file.
"""
function readcoda(args...; codanames=(), kwargs...)
  data = DataFrame!(CSV.File(args...; kwargs...))
  if codanames isa NTuple || codanames isa AbstractArray
    codanames = isempty(codanames) ? Tuple(propertynames(data)) => :coda : Tuple(Symbol.(codanames)) => :coda
  end
  compose(data, codanames)
end

"""
    compose(data, cols)
    compose(data, cols => :coda)

Convert columns `cols` of tabular `data` into
parts of a composition.
"""
function compose(data, cols::Pair{NTuple{N,Symbol},Symbol}) where {N}
  # non-compositional columns
  result = data[:,setdiff(propertynames(data), cols.first)]

  # compositional columns
  coda = map(eachrow(data[:,collect(cols.first)])) do row
    Composition(Tuple(propertynames(row)), values(row))
  end
  result[!, cols.second] = coda

  result
end

compose(data, cols::Pair{NTuple{N,String},Symbol}) where {N} = compose(data, Tuple(Symbol.(cols.first)) => cols.second)
compose(data, cols::NTuple{N,Symbol}) where {N} = compose(data, cols => :coda)
compose(data, cols::NTuple{N,String}) where {N} = compose(data, Symbol.(cols) => :coda)
compose(data, cols::AbstractArray{Symbol,N}) where {N} = compose(data, Tuple(cols) => :coda)
compose(data, cols::AbstractArray{String,N}) where {N} = compose(data, Tuple(Symbol.(cols)) => :coda)