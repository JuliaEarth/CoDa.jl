# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
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
  comps::SVector{D,Union{Float64,Missing}}
end

Composition(comps::NamedTuple) =
  Composition{length(comps),keys(comps)}(values(comps))

Composition(parts::NTuple{D,Symbol},
            comps::NTuple{D,Union{<:Real,Missing}}) where {D} =
  Composition(NamedTuple{parts}(comps))

Composition(parts::NTuple{D,Symbol}, comps::AbstractVector) where {D} =
  Composition(parts, Tuple(comps))

Composition(; partscomps...) = Composition((; partscomps...))

Composition(comps::NTuple{D,Union{<:Real,Missing}}) where {D} =
  Composition(ntuple(i->Symbol("part$i"), D), comps)

Composition(comps::AbstractVector) = Composition(Tuple(comps))

Composition(comp::Real, comps...) = Composition((comp, comps...))

"""
    parts(c)

Parts in the composition `c`.
"""
parts(::Composition{D,SYMS}) where {D,SYMS} = SYMS

"""
    components(c)

Components in the composition `c`.
"""
components(c::Composition) = getfield(c, :comps)

"""
    getproperty(c, name)

Return the value of part with given `name` in the composition `c`.
"""
function getproperty(c::Composition{D,SYMS}, n::Symbol) where {D,SYMS}
  i = findfirst(isequal(n), SYMS)
  getfield(c, :comps)[i]
end

+(c₁::Composition{D,SYMS}, c₂::Composition{D,SYMS}) where {D,SYMS} =
  Composition(SYMS, 𝓒(components(c₁) .* components(c₂)))

-(c::Composition{D,SYMS}) where {D,SYMS} = Composition(SYMS, 𝓒(1 ./ components(c)))

-(c₁::Composition, c₂::Composition) = c₁ + -c₂

*(λ::Real, c::Composition{D,SYMS}) where {D,SYMS} = Composition(SYMS, 𝓒(components(c).^λ))

==(c₁::Composition{D,SYMS₁}, c₂::Composition{D,SYMS₂}) where {D,SYMS₁,SYMS₂} =
  SYMS₁ == SYMS₂ && 𝓒(components(c₁)) ≈ 𝓒(components(c₂))

"""
    dot(c₁, c₂)

Inner product between compositions `c₁` and `c₂`.
"""
function dot(c₁::Composition{D,SYMS}, c₂::Composition{D,SYMS}) where {D,SYMS}
  x = components(c₁); y = components(c₂)
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
  print(io, join(components(c), ":"))
end

function Base.show(io::IO, mime::MIME"text/plain", c::Composition{D,SYMS}) where {D,SYMS}
  p = Vector{Float64}()
  s = Vector{Symbol}()
  m = Vector{Symbol}()
  x = components(c)
  for i in 1:D
    if ismissing(x[i])
      push!(m, SYMS[i])
    else
      push!(s, SYMS[i])
      push!(p, x[i])
    end
  end
  plt = barplot(s, p, title="$D-part composition")
  isempty(m) || annotate!(plt, :t, "missing: $(join(m,", "))")
  show(io, mime, plt)
end
