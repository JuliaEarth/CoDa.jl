# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    alr(c)

Additive log-ratio transformation of composition `c`.
"""
function alr(c::Composition)
  comps = components(c) .+ eps()
  D     = length(comps)
  SVector(ntuple(i -> log(comps[i] / comps[D]), D-1))
end

"""
    alrinv(x)

Inverse alr for coordinates `x`.
"""
alrinv(x::SVector{D,T}) where {D,T<:Real} =
  Composition(𝓒([exp.(x); SVector(one(T))]))

"""
    clr(c)

Centered log-ratio transformation of composition `c`.
"""
function clr(c::Composition)
  comps = components(c) .+ eps()
  gmean = geomean(comps)
  D     = length(comps)
  SVector(ntuple(i -> log(comps[i] / gmean), D))
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
  comps = components(c) .+ eps()
  logs  = log.(comps)
  T = eltype(comps)
  D = length(comps)
  x = MVector(ntuple(i->zero(T), D-1))
  for i in 1:D-1
    s = zero(T)
    sqrtinv = 1/sqrt(i*(i+1))
    for j in 1:i+1
      if j < i+1
        s += - sqrtinv * logs[j]
      elseif j==i+1
        s += i * sqrtinv * logs[j]
      end
    end
    x[i] = s
  end
  SVector(x)
end

"""
    ilrinv(x)

Inverse ilr for coordinates `x`.
"""
function ilrinv(x::SVector{D,T}) where {D,T<:Real}
  z = MVector(ntuple(i->zero(T), D+1))
  for i in 1:D+1
    s = zero(T)
    for j in 1:D
      sqrtinv = 1/sqrt(j*(j+1))
      if i < j+1
        s += - sqrtinv * x[j]
      elseif i == j+1
        s += j * sqrtinv * x[j]
      end
    end
    z[i] = exp(s)
  end
  Composition(𝓒(z))
end
