# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    alr(c)

Additive log-ratio transformation of composition `c`.
"""
alr(c::Composition{D,SYMS}) where {D,SYMS} =
  SVector(ntuple(i -> log(c.parts[i] / c.parts[D]), D-1))

"""
    alrinv(x)

Inverse alr for coordinates `x`.
"""
alrinv(x::SVector{D,T}) where {D,T<:Real} =
  Composition(𝓒(vcat(exp.(x), SVector((one(T),)))))

"""
    clr(c)

Centered log-ratio transformation of composition `c`.
"""
function clr(c::Composition{D,SYMS}) where {D,SYMS}
  m = geomean(c.parts)
  SVector(ntuple(i -> log(c.parts[i] / m), D))
end

"""
    clrinv(x)

Inverse clr for coordinates `x`.
"""
clrinv(x) = Composition(𝓒(exp.(x)))

"""
    ilr(c)

Isometric log-ratio transformation of composition `c`.
"""
function ilr(c::Composition)
  # TODO
end

"""
    ilrinv(x)

Inverse ilr for coordinates `x`.
"""
function ilrinv(x)
  # TODO
end
