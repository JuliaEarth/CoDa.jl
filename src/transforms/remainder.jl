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
struct Remainder <: Transform end

isrevertible(::Type{Remainder}) = true

function apply(::Remainder, table)
  # TODO
end

function revert(::Remainder, newtable, cache)
  # TODO
end

function reapply(::Remainder, table, cache)
  # TODO
end
