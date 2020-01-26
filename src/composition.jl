# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    𝓒(x)

Return closure of `x`.
"""
𝓒(x) = x ./ sum(x)

"""
    Composition(symsparts)
    Composition(syms, parts)
    Composition(sym₁=val₁, sym₂=val₂, ...)
    Composition(parts)
    Composition(val₁, val₂, ...)

A D-part composition as defined by Aitchison 1986.

## Examples

A 2-part composition with parts `a=0.1` and `b=0.8`:

```julia
julia> Composition(a=0.2, b=0.8)
julia> Composition((a=0.2, b=0.8))
julia> Composition((:a, :b), (0.2, 0.8))
```

When the names of the parts are not specified, the
constructor uses default names `part-1`, `part-2`,
..., `part-D`:

```
julia> Composition(0.1, 0.8)
julia> Composition((0.1, 0.8))
```
"""
struct Composition{D,SYMS}
  parts::SVector{D,Float64}
end

Composition(parts::NamedTuple) =
  Composition{length(parts),keys(parts)}(Tuple(parts))

Composition(syms::NTuple{D,Symbol}, parts::NTuple{D,<:Real}) where {D} =
  Composition(NamedTuple{syms}(parts))

Composition(syms::NTuple{D,Symbol}, parts::SVector{D,<:Real}) where {D} =
  Composition(syms, Tuple(parts))

Composition(; parts...) = Composition((; parts...))

Composition(parts::NTuple{D,<:Real}) where {D} =
  Composition(ntuple(i->Symbol("part-$i"), D), parts)

Composition(parts::SVector{D,<:Real}) where {D} = Composition(Tuple(parts))

Composition(part::Real, parts...) = Composition((part, parts...))

+(c₁::Composition{D,SYMS}, c₂::Composition{D,SYMS}) where {D,SYMS} =
  Composition(SYMS, 𝓒(c₁.parts .* c₂.parts))

-(c::Composition{D,SYMS}) where {D,SYMS} = Composition(SYMS, 𝓒(1 ./ c.parts))

-(c₁::Composition, c₂::Composition) = c₁ + -c₂

*(λ::Real, c::Composition{D,SYMS}) where {D,SYMS} = Composition(SYMS, 𝓒(c.parts.^λ))

==(c₁::Composition{D,SYMS₁}, c₂::Composition{D,SYMS₂}) where {D,SYMS₁,SYMS₂} =
  SYMS₁ == SYMS₂ && 𝓒(c₁.parts) ≈ 𝓒(c₂.parts)

"""
    names(c)

Names of parts in the composition `c`.
"""
names(c::Composition{D,SYMS}) where {D,SYMS} = SYMS

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
  print(io, join(c.parts, "|"))
end

function Base.show(io::IO, ::MIME"text/plain", c::Composition{D,SYMS}) where {D,SYMS}
  print(barplot([S for S in SYMS], c.parts, title="$D-part composition"))
end

function Base.show(io::IO, ::MIME"text/html", c::Composition{D,SYMS}) where {D,SYMS}
  print(barplot([S for S in SYMS], c.parts, title="$D-part composition"))
end
