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
  Composition(𝓒(vcat(exp.(x), SVector((one(T),)))))

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
  log_parts = log.(c.parts .+ eps())
  x = @MVector zeros(D-1)
  for i in 1:D-1
    s = 0.
    sqrt_denom = 1/sqrt(i*(i+1))
    for j in 1:i+1
      if j < i+1
        s += - sqrt_denom * log_parts[j]
      elseif j==i+1
        s += i * sqrt_denom * log_parts[j]
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
  z = @MVector zeros(D+1)
  for i in 1:D+1
    s = 0.
    for j in 1:D
      if i < j+1
        s += - 1/sqrt(j*(j+1)) * x[j]
      elseif i==j+1
        s += j * 1/sqrt(j*(j+1)) * x[j]
      end
    end
    z[i] = exp(s)
  end
  Composition(𝓒(SVector(z)))
end
