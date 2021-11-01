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

function apply(::Closure, table)
  # TODO
end

function revert(::Closure, newtable, cache)
  # TODO
end

function reapply(::Closure, table, cache)
  # TODO
end