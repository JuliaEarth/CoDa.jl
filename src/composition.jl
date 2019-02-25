# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    𝓒(x)

Return closure of `x`.
"""
𝓒(x) = x ./ sum(x)

"""
    Composition{D}(parts)

A D-part composition as defined by Aitchison 1986.
"""
struct Composition{D}
  parts::SVector{D,Float64}
end

Composition(parts) = Composition{length(parts)}(parts)
Composition(parts...) = Composition(parts)

+(c₁::Composition, c₂::Composition) = Composition(𝓒(c₁.parts .* c₂.parts))

-(c::Composition) = Composition(𝓒(1. ./ c.parts))

-(c₁::Composition, c₂::Composition) = c₁ + -c₂

*(λ::Real, c::Composition) = Composition(𝓒(c.parts.^λ))

==(c₁::Composition, c₂::Composition) = 𝓒(c₁.parts) ≈ 𝓒(c₂.parts)

"""
    inner(c₁, c₂)

Inner product between compositions `c₁` and `c₂`.
"""
function inner(c₁::Composition{D}, c₂::Composition{D}) where {D}
  x = c₁.parts; y = c₂.parts
  sum(log(x[i]/x[j])*log(y[i]/y[j]) for j=1:D for i=j+1:D) / D
end

"""
    norm(c)

Aitchison norm of composition `c`.
"""
norm(c::Composition) = √inner(c,c)

"""
    distance(c₁, c₂)

Aitchison distance between compositions `c₁` and `c₂`.
"""
distance(c₁::Composition, c₂::Composition) = norm(c₁ - c₂)

# ------------
# IO methods
# ------------
function Base.show(io::IO, c::Composition{D}) where {D}
  print(io, c.parts)
end

function Base.show(io::IO, ::MIME"text/plain", c::Composition{D}) where {D}
  print(barplot(["part $i" for i in 1:D], c.parts, title="$D-part composition"))
end

function Base.show(io::IO, ::MIME"text/html", c::Composition{D}) where {D}
  print(barplot(["part $i" for i in 1:D], c.parts, title="$D-part composition"))
end
