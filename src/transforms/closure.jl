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

  # original column names
  names = Tables.columnnames(table)

  # table as matrix and get the sum acros dims 2
  X = Tables.matrix(table)
  S = sum(X, dims=2)

  # divides each row by its sum (closure operation)
  Z = X ./ S

  # table with the old columns and the new values
  𝒯 = (; zip(names, eachcol(Z))...)
  newtable = 𝒯 |> Tables.materializer(table)
  
  newtable, S
end

function revert(::Closure, newtable, cache)
  # transformed column names
  names = Tables.columnnames(newtable)

  # table as matrix
  Z = Tables.matrix(newtable)

  # retrieve cache
  Σ = cache

  # undo operation
  X = Z .* Σ

  # table with original columns
  𝒯 = (; zip(names, eachcol(X))...)
  𝒯 |> Tables.materializer(newtable)
end

function reapply(transform::Closure, table, cache)
  apply(transform, table) # how to reuse cache (column of sum) to a (possibly different) table ?
end