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
struct Composition{D,PARTS}
  data::SVector{D,Union{Float64,Missing}}
end

Composition(data::NamedTuple) =
  Composition{length(data),keys(data)}(values(data))

Composition(; data...) = Composition((; data...))

Composition(parts::NTuple, comps) =
  Composition((; zip(parts, Tuple(comps))...))

Composition(comps) =
  Composition(ntuple(i->Symbol("w$i"), length(comps)), comps)

Composition(comp::Real, comps...) = Composition((comp, comps...))

"""
    parts(c)

Parts in the composition `c`.
"""
parts(::Composition{D,PARTS}) where {D,PARTS} = PARTS

"""
    components(c)

Components in the composition `c`.
"""
components(c::Composition) = getfield(c, :data)

"""
    getproperty(c, part)

Return the value of `part` in the composition `c`.
"""
function getproperty(c::Composition{D,PARTS}, PART::Symbol) where {D,PARTS}
  i = findfirst(isequal(PART), PARTS)
  if isnothing(i)
    throw(ArgumentError("invalid part"))
  else
    getfield(c, :data)[i]
  end
end

+(c₁::Composition{D,PARTS}, c₂::Composition{D,PARTS}) where {D,PARTS} =
  Composition(PARTS, 𝓒(components(c₁) .* components(c₂)))

-(c::Composition) = Composition(parts(c), 𝓒(1 ./ components(c)))

-(c₁::Composition, c₂::Composition) = c₁ + -c₂

*(λ::Real, c::Composition) = Composition(parts(c), 𝓒(components(c).^λ))

==(c₁::Composition, c₂::Composition) =
  parts(c₁) == parts(c₂) && 𝓒(components(c₁)) ≈ 𝓒(components(c₂))

"""
    dot(c₁, c₂)

Inner product between compositions `c₁` and `c₂`.
"""
function dot(c₁::Composition{D}, c₂::Composition{D}) where {D}
  x, y = components(c₁), components(c₂)
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

"""
    rand(Composition{D}, n=1)

Generates `D`-part composition at random according to a
balanced Dirichlet distribution.
"""
function rand(rng::Random.AbstractRNG,
              ::Random.SamplerType{<:Composition{D}}) where {D}
  α = fill(1.0, D)
  d = Dirichlet(α)
  x = rand(rng, d)
  Composition(x)
end

# -----------
# IO METHODS
# -----------

function Base.show(io::IO, c::Composition)
  w = [(@sprintf "%.03f" w) for w in components(c)]
  show(io, join(w, " : "))
end

function Base.show(io::IO, mime::MIME"text/plain",
                   c::Composition{D,PARTS}) where {D,PARTS}
  w = components(c)
  x = Vector{Float64}()
  p = Vector{Symbol}()
  m = Vector{Symbol}()
  for i in 1:D
    if ismissing(w[i])
      push!(m, PARTS[i])
    else
      push!(p, PARTS[i])
      push!(x, w[i])
    end
  end
  plt = barplot(p, x, title="$D-part composition")
  isempty(m) || annotate!(plt, :t, "missing: $(join(m,", "))")
  show(io, mime, plt)
end
