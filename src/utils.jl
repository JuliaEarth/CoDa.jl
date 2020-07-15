# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    readcoda(args...; codanames=[], kwargs...)

Read data from disk using `CSV.read`, optionally specifying
the columns `codanames` with compositional data.

The arguments `args` and keyword arguments `kwargs` are
forwarded to the `CSV.read` function, please check their
documentation for more details.

This function returns a collection of [`Composition`](@ref)
objects whose parts are the columns `codanames` in the file.
"""
function readcoda(args...; codanames=[], kwargs...)
  data = DataFrame!(CSV.File(args...; kwargs...))
  cols = isempty(codanames) ? names(data) : codanames
  compose(data, cols)
end

"""
    compose(data, cols)

Convert columns `cols` of tabular `data` into
parts of a composition.
"""
function compose(data, cols::Vector{Symbol})
  # non-compositional columns
  result = data[:,setdiff(names(data), cols)]

  # compositional columns
  coda = map(eachrow(data[:,cols])) do row
    Composition(Tuple(names(row)), values(row))
  end
  result[Symbol(join(cols, "|"))] = coda

  result
end
