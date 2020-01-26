# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    𝓒(x)

Return closure of `x`.
"""
𝓒(x) = x ./ sum(x)

"""
    Composition{D,SYMS}(...)

A D-part composition as defined by Aitchison 1986
with parts named `SYMS`.
"""
struct Composition{D,SYMS}
  parts::SVector{D,Float64}
end

Composition(parts::NamedTuple) =
  Composition{length(parts),keys(parts)}(Tuple(parts))

Composition(syms::NTuple{D,Symbol}, parts::NTuple{D,<:Real}) where {D} =
  Composition(NamedTuple{syms}(parts))

Composition(; parts...) = Composition((; parts...))

Composition(parts::NTuple{D,<:Real}) where {D} =
  Composition(ntuple(i->Symbol("part-$i"), D), parts)

Composition(parts::SVector{D,<:Real}) where {D} = Composition(Tuple(parts))

Composition(part::Real, parts...) = Composition((part, parts...))

+(c₁::Composition, c₂::Composition) = Composition(𝓒(c₁.parts .* c₂.parts))

-(c::Composition) = Composition(𝓒(1 ./ c.parts))

-(c₁::Composition, c₂::Composition) = c₁ + -c₂

*(λ::Real, c::Composition) = Composition(𝓒(c.parts.^λ))

==(c₁::Composition{D,SYMS₁}, c₂::Composition{D,SYMS₂}) where {D,SYMS₁,SYMS₂} =
  SYMS₁ == SYMS₂ && 𝓒(c₁.parts) ≈ 𝓒(c₂.parts)

"""
    dot(c₁, c₂)

Inner product between compositions `c₁` and `c₂`.
"""
function dot(c₁::Composition{D,SYMS}, c₂::Composition{D,SYMS}) where {D,SYMS}
  x = c₁.parts; y = c₂.parts
  sum(log(x[i]/x[j])*log(y[i]/y[j]) for j=1:D for i=j+1:D) / D
end

"""
    norm(c)

Aitchison norm of composition `c`.
"""
norm(c::Composition) = √dot(c,c)

"""
    distance(c₁, c₂)

Aitchison distance between compositions `c₁` and `c₂`.
"""
distance(c₁::Composition, c₂::Composition) = norm(c₁ - c₂)

# ------------
# IO methods
# ------------
function Base.show(io::IO, c::Composition)
  parts = join(c.parts, ", ")
  print(io, "Composition($parts)")
end

function Base.show(io::IO, ::MIME"text/plain", c::Composition{D,SYMS}) where {D,SYMS}
  print(barplot([S for S in SYMS], c.parts, title="$D-part composition"))
end

function Base.show(io::IO, ::MIME"text/html", c::Composition{D,SYMS}) where {D,SYMS}
  print(barplot([S for S in SYMS], c.parts, title="$D-part composition"))
end
