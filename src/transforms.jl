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
  Composition(𝓒([exp.(x); SVector(one(T))]))

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
function ilr(c::Composition{D,SYMS}) where {D,SYMS}
  T = eltype(c.parts)
  logparts = log.(c.parts .+ eps())
  x = MVector(ntuple(i->zero(T), D-1))
  for i in 1:D-1
    s = zero(T)
    sqrtinv = 1/sqrt(i*(i+1))
    for j in 1:i+1
      if j < i+1
        s += - sqrtinv * logparts[j]
      elseif j==i+1
        s += i * sqrtinv * logparts[j]
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
