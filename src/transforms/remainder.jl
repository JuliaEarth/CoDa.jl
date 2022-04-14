# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    Remainder([total])

The transform that takes a table with columns `x₁, x₂, …, xₙ`
and returns a new table with an additional column containing the
remainder value `xₙ₊₁ = total .- (x₁ + x₂ + ⋯ + xₙ)` If the `total`
value is not specified, then default to the maximum sum across rows.
"""
struct Remainder <: Transform
  total::Union{Float64,Nothing}
end

Remainder() = Remainder(nothing)

isrevertible(::Type{Remainder}) = true

assertions(::Type{Remainder}) = [TableTransforms.assert_continuous]

function _cache(transform::Remainder, table)
  # design matrix
  X = Tables.matrix(table)

  # find total across rows
  if !isnothing(transform.total)
    transform.total
  else
    maximum(sum(X, dims=2))
  end
end

function _apply(transform::Remainder, table, cache)
  # basic checks
  for assertion in assertions(transform)
    assertion(table)
  end

  # design matrix
  X = Tables.matrix(table)

  # retrieve the total
  total = cache

  # make sure that the total is valid
  @assert all(x -> x ≤ total, sum(X, dims=2)) "the sum for each row must be less than total"

  # original column names
  names = Tables.columnnames(table)

  # create a column with the remainder
  S = sum(X, dims=2)
  Z = [X (total .- S)]

  # create new column name
  rname = :remainder
  while rname ∈ names
    rname = Symbol(rname,:_)
  end
  names = (names..., rname)

  # table with new column
  𝒯 = (; zip(names, eachcol(Z))...)
  newtable = 𝒯 |> Tables.materializer(table)

  newtable, total
end

apply(transform::Remainder, table) =
  _apply(transform, table, _cache(transform, table))

function revert(::Remainder, newtable, cache)
  names = Tables.columnnames(newtable)
  Reject(last(names))(newtable)
end

reapply(transform::Remainder, table, cache) =
  _apply(transform, table, cache) |> first