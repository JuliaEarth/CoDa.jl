# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    Closure()

The transform that applies the closure operation 𝒞
to all rows of the input table. The rows of the
output table sum to one.
"""
struct Closure <: Transform end

isrevertible(::Type{Closure}) = true

assertions(::Type{Closure}) = [TT.assert_continuous]

function apply(transform::Closure, table)
  # basic checks
  for assertion in assertions(transform)
    assertion(table)
  end

  names = Tables.columnnames(table)
  Z = Tables.matrix(table)
  Σ = sum(Z, dims=2)
  C = Z ./ Σ
  𝒯 = (; zip(names, eachcol(C))...)

  newtable = 𝒯 |> Tables.materializer(table)
  newtable, Σ
end

function revert(::Closure, newtable, cache)
  # transformed column names
  names = Tables.columnnames(newtable)

  # table as matrix
  C = Tables.matrix(newtable)

  # retrieve cache
  Σ = cache

  # undo operation
  Z = C .* Σ

  # table with original columns
  𝒯 = (; zip(names, eachcol(Z))...)
  𝒯 |> Tables.materializer(newtable)
end

function reapply(transform::Closure, table, cache)
  apply(transform, table) # how to reuse cache to a (possibly different) table ?
end