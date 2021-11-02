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
  total::Union{Nothing, Number}

  function Remainder(total=nothing)
    new(total)
  end
end

isrevertible(::Type{Remainder}) = true

assertions(::Type{Remainder}) = [TT.assert_continuous]

function apply(transform::Remainder, table)
  # basic checks
  for assertion in assertions(transform)
    assertion(table)
  end

  # table as matrix and get the sum acros dims 2
  X = Tables.matrix(table)
  Σ = sum(X, dims=2)

  # infer total when not specified
  total = if !isnothing(transform.total)
    transform.total
  else
    maximum(Σ)
  end

  # original column names
  names = Tables.columnnames(table)

  # create a column with the remainder of each row
  T = total .- Σ
  Z = hcat(X, T)

  # table with the new column
  names = (names..., :remainder)
  𝒯 = (; zip(names, eachcol(Z))...)

  newtable = 𝒯 |> Tables.materializer(table)
  newtable, total
end

function revert(::Remainder, newtable, cache)
  Reject(:remainder)(newtable)
end

function reapply(transform::Remainder, table, cache)
  # basic checks
  for assertion in assertions(transform)
    assertion(table)
  end

  # retrieve total from cache
  total = cache

  # original column names
  names = Tables.columnnames(table)

  # table as matrix and get the sum acros dims 2
  X = Tables.matrix(table)
  Σ = sum(X, dims=2)

  # create a column with the remainder of each row
  T = total .- Σ
  Z = hcat(X, T)

  # table with the new column
  names = (names..., :remainder)
  𝒯 = (; zip(names, eachcol(Z))...)

  newtable = 𝒯 |> Tables.materializer(table)
  newtable, total
end
