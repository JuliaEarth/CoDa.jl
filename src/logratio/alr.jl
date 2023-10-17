# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    alr(c)

Additive log-ratio transformation of composition `c`.
"""
function alr(c::Composition{D}) where {D}
  w = components(c) .+ eps()
  SVector(ntuple(i -> log(w[i] / w[D]), D - 1))
end

"""
    alrinv(x)

Inverse alr transformation of coordinates `x`.
"""
alrinv(x::SVector{D,T}) where {D,T<:Real} = Composition(𝒞([exp.(x); SVector(one(T))]))

alrinv(x::AbstractVector) = alrinv(SVector{length(x)}(x))
