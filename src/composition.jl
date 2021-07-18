# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    𝓒(x)

Return closure of `x`.
"""
𝓒(x) = x ./ sum(x)

"""
    Composition(partscomps)
    Composition(parts, comps)
    Composition(part₁=comp₁, part₂=part₂, ...)
    Composition(comps)
    Composition(comp₁, comp₂, ...)

A D-part composition as defined by Aitchison 1986.

## Examples

A 2-part composition with parts `a=0.1` and `b=0.8`:

```julia
julia> Composition(a=0.2, b=0.8)
julia> Composition((a=0.2, b=0.8))
julia> Composition((:a, :b), (0.2, 0.8))
```

When the names of the parts are not specified, the
constructor uses default names `part1`, `part2`,
..., `partD`:

```
julia> Composition(0.1, 0.8)
julia> Composition((0.1, 0.8))
```
"""
struct Composition{PARTS,NT<:NamedTuple}
  data::NT
end

Composition(data::NamedTuple) =
  Composition{keys(data),typeof(data)}(data)

Composition(; data...) = Composition((; data...))

Composition(parts::NTuple, comps) =
  Composition((; zip(parts, Tuple(comps))...))

Composition(comps) =
  Composition(ntuple(i->Symbol("part$i"), length(comps)), comps)

Composition(comp::Real, comps...) = Composition((comp, comps...))

"""
    parts(c)

Parts in the composition `c`.
"""
parts(c::Composition) = getfield(c, :data) |> keys

"""
    components(c)

Components in the composition `c`.
"""
components(c::Composition) = getfield(c, :data) |> values |> SVector

"""
    getproperty(c, name)

Return the value of part with given `name` in the composition `c`.
"""
getproperty(c::Composition, n::Symbol) = getfield(c, :data)[n]

+(c₁::Composition{PARTS}, c₂::Composition{PARTS}) where {PARTS} =
  Composition(parts(c₁), 𝓒(components(c₁) .* components(c₂)))

-(c::Composition) = Composition(parts(c), 𝓒(1 ./ components(c)))

-(c₁::Composition, c₂::Composition) = c₁ + -c₂

*(λ::Real, c::Composition) = Composition(parts(c), 𝓒(components(c).^λ))

==(c₁::Composition, c₂::Composition) =
  parts(c₁) == parts(c₂) && 𝓒(components(c₁)) ≈ 𝓒(components(c₂))

"""
    dot(c₁, c₂)

Inner product between compositions `c₁` and `c₂`.
"""
function dot(c₁::Composition, c₂::Composition)
  x = components(c₁)
  y = components(c₂)
  D = length(x)
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
  show(io, join(components(c), ":"))
end

function Base.show(io::IO, mime::MIME"text/plain", c::Composition)
  names = parts(c)
  comps = components(c)
  x = Vector{Float64}()
  p = Vector{Symbol}()
  m = Vector{Symbol}()
  D = length(names)
  for i in 1:D
    if ismissing(comps[i])
      push!(m, names[i])
    else
      push!(p, names[i])
      push!(x, comps[i])
    end
  end
  plt = barplot(p, x, title="$D-part composition")
  isempty(m) || annotate!(plt, :t, "missing: $(join(m,", "))")
  show(io, mime, plt)
end
