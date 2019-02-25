# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    alr(c)

Additive log-ratio transformation of composition `c`.
"""
alr(c::Composition{D}) where {D} = log.(c.parts[1:D-1] ./ c.parts[D])

"""
    alrinv(x)

Inverse alr for coordinates `x`.
"""
alrinv(x) = Composition(𝓒(vcat(exp.(x), 1.)))

"""
    clr(c)

Centered log-ratio transformation of composition `c`.
"""
clr(c::Composition{D}) where {D} = log.(c.parts ./ geomean(c.parts))

"""
    clrinv(x)

Inverse clr for coordinates `x`.
"""
clrinv(x) = Composition(𝓒(exp.(x)))

"""
    ilr(c)

Isometric log-ratio transformation of composition `c`.
"""
function ilr(c::Composition{D}) where {D}
  # TODO
end

"""
    ilrinv(x)

Inverse ilr for coordinates `x`.
"""
function ilrinv(x)
  # TODO
end
