# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

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
constructor uses default names `w1`, `w2`, ..., `wD`:

```
julia> Composition(0.1, 0.8)
julia> Composition((0.1, 0.8))
```
"""
struct Composition{D,PARTS}
  data::NamedTuple{PARTS,NTuple{D,Union{Float64,Missing}}}
end

Composition{D,PARTS}(comps::Tuple) where {D,PARTS} = Composition{D,PARTS}(NamedTuple{PARTS}(comps))

Composition{D,PARTS}(comps::AbstractVector) where {D,PARTS} = Composition{D,PARTS}(ntuple(i -> comps[i], D))

Composition(data::NamedTuple{PARTS}) where {PARTS} = Composition{length(data),PARTS}(data)

Composition(; data...) = Composition(values(data))

Composition(parts::NTuple{D,Symbol}, comps::Tuple) where {D} = Composition{D,parts}(comps)

Composition(parts::NTuple{D,Symbol}, comps) where {D} = Composition{D,parts}(ntuple(i -> comps[i], D))

Composition(comps) = Composition(ntuple(i -> Symbol(:w, i), length(comps)), comps)

Composition(comps::Union{Real,Missing}...) = Composition(comps)

"""
    parts(c)

Parts in the composition `c`.
"""
parts(c::Composition) = parts(typeof(c))
parts(::Type{Composition{D,PARTS}}) where {D,PARTS} = PARTS

"""
    components(c)

Components in the composition `c`.
"""
components(c::Composition) = getfield(c, :data) |> values |> SVector

Base.getproperty(c::Composition, p::Symbol) = getproperty(getfield(c, :data), p)

# -------------
# VECTOR SPACE
# -------------

+(c₁::Composition{D,PARTS}, c₂::Composition{D,PARTS}) where {D,PARTS} =
  Composition(PARTS, 𝒞(components(c₁) .* components(c₂)))

-(c::Composition) = Composition(parts(c), 𝒞(1 ./ components(c)))

-(c₁::Composition, c₂::Composition) = c₁ + -c₂

*(λ::Real, c::Composition) = Composition(parts(c), 𝒞(components(c) .^ λ))

/(c::Composition, λ::Real) = inv(λ) * c

zero(c::Composition) = zero(typeof(c))
zero(T::Type{<:Composition{D}}) where {D} = Composition(parts(T), ntuple(i -> 1 / D, D))

==(c₁::Composition, c₂::Composition) = parts(c₁) == parts(c₂) && 𝒞(components(c₁)) ≈ 𝒞(components(c₂))

function dot(c₁::Composition{D}, c₂::Composition{D}) where {D}
  x, y = components(c₁), components(c₂)
  sum(log(x[i] / x[j]) * log(y[i] / y[j]) for j in 1:D for i in (j + 1):D) / D
end

norm(c::Composition) = √(c ⋅ c)

# ----------
# UTILITIES
# ----------

"""
    smooth(c, τ)

Add small value `τ` to all components of composition `c`
in order to remove essential zeros.
"""
smooth(c::Composition{D}, τ::Real) where {D} = Composition(parts(c), 𝒞(components(c) .+ τ))

"""
    𝒞(x)

Return closure of `x`.
"""
𝒞(x) = x ./ sum(x)

# ----------------
# SPECIALIZATIONS
# ----------------

function mean(cs::AbstractArray{<:Composition{D}}) where {D}
  k = 1 / length(cs)
  sum(k * c for c in cs)
end

function var(cs::AbstractArray{<:Composition{D}}; mean=nothing) where {D}
  μ = isnothing(mean) ? Statistics.mean(cs) : mean
  sum(aitchison(c, μ)^2 for c in cs)
end

function std(cs::AbstractArray{<:Composition{D}}; mean=nothing) where {D}
  σ² = var(cs, mean=mean)
  √σ²
end

# --------------------
# RANDOM COMPOSITIONS
# --------------------

"""
    rand(Composition{D}, n=1)

Generates `D`-part composition at random according to a
balanced Dirichlet distribution.
"""
function rand(rng::Random.AbstractRNG, ::Random.SamplerType{<:Composition{D}}) where {D}
  α = fill(1.0, D)
  d = Dirichlet(α)
  x = rand(rng, d)
  Composition(x)
end

# -----------
# IO METHODS
# -----------

Base.show(io::IO, c::Composition) =
  join(io, (ismissing(w) ? "missing" : @sprintf("%.06f", w) for w in components(c)), " : ")

function Base.show(io::IO, ::MIME"text/plain", c::Composition)
  keys = string.(parts(c))
  vals = components(c)

  # maximum name length and value
  klen = maximum(length, keys)
  vvec = collect(skipmissing(vals))
  vmax = isempty(vvec) ? 1.0 : maximum(vvec)

  width = 32 # width of the bar plot
  println(io, repeat(" ", klen + 1) * "┌" * repeat(" ", width + 9) * "┐")
  for (k, v) in zip(keys, vals)
    if ismissing(v)
      println(io, rpad(k, klen) * " ┤ missing")
    else
      len = round(Int, v / vmax * width)
      bar = repeat("■", len)
      pad = repeat(" ", width - len)
      val = @sprintf("%.06f", v)
      println(io, rpad(k, klen) * " ┤" * bar * pad * " " * val)
    end
  end
  print(io, repeat(" ", klen + 1) * "└" * repeat(" ", width + 9) * "┘")
end
