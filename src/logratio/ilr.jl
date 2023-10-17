# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    ilr(c)

Isometric log-ratio transformation of composition `c`.
"""
function ilr(c::Composition{D}) where {D}
  w = components(c) .+ eps()
  l = log.(w)
  T = eltype(w)
  x = MVector(ntuple(i -> zero(T), D - 1))
  for i in 1:(D - 1)
    s = zero(T)
    sqrtinv = 1 / sqrt(i * (i + 1))
    for j in 1:(i + 1)
      if j < i + 1
        s += -sqrtinv * l[j]
      elseif j == i + 1
        s += i * sqrtinv * l[j]
      end
    end
    x[i] = s
  end
  SVector(x)
end

"""
    ilrinv(x)

Inverse ilr transformation of coordinates `x`.
"""
function ilrinv(x::SVector{D}) where {D}
  z = MVector(ntuple(i -> 0.0, D + 1))
  for i in 1:(D + 1)
    s = 0.0
    for j in 1:D
      sqrtinv = 1 / sqrt(j * (j + 1))
      if i < j + 1
        s += -sqrtinv * x[j]
      elseif i == j + 1
        s += j * sqrtinv * x[j]
      end
    end
    z[i] = exp(s)
  end
  Composition(𝒞(z))
end

ilrinv(x::AbstractVector) = ilrinv(SVector{length(x)}(x))
