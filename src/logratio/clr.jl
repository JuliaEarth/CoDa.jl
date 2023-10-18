# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    clr(c)

Centered log-ratio transformation of composition `c`.
"""
function clr(c::Composition{D}) where {D}
  w = components(c) .+ eps()
  μ = exp(mean(log, w)) # geometric mean
  SVector(ntuple(i -> log(w[i] / μ), D))
end

"""
    clrinv(x)

Inverse clr transformation of coordinates `x`.
"""
clrinv(x::SVector{D,T}) where {D,T<:Real} = Composition(𝒞(exp.(x)))

clrinv(x::AbstractVector) = clrinv(SVector{length(x)}(x))
