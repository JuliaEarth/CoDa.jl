# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

# -------------
# COMPOSITIONS
# -------------

"""
    ilr(c)

Isometric log-ratio transformation of composition `c`.
"""
function ilr(c::Composition{D}) where {D}
  w = components(c) .+ eps()
  l = log.(w)
  T = eltype(w)
  x = MVector(ntuple(i->zero(T), D-1))
  for i in 1:D-1
    s = zero(T)
    sqrtinv = 1/sqrt(i*(i+1))
    for j in 1:i+1
      if j < i+1
        s += - sqrtinv * l[j]
      elseif j==i+1
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

# -------
# TABLES
# -------

"""
   ilr(table)

Isometric log-ratio transformation of `table`.
"""
function ilr(table)
  # design matrix
  X = Tables.matrix(table) .|> Float64
  n = Tables.columnnames(table)

  # new variable names
  vars = collect(n)[begin:end-1]

  # transformation
  Y = mapslices(ilr ∘ Composition, X, dims=2)

  # # return same table type
  T = (; zip(vars, eachcol(Y))...)
  T |> Tables.materializer(table)
end

"""
    ilrinv(table)

Inverse ilr transformation of `table`.
"""
function ilrinv(table)
  # design matrix
  Y = Tables.matrix(table) .|> Float64
  n = Tables.columnnames(table)

  # new variable names
  vars = [collect(n); Symbol("total_minus_"*join(n,""))]

  # trasformation
  D = size(Y, 2)
  f = components ∘ ilrinv ∘ SVector{D}
  X = mapslices(f, Y, dims=2)

  # return same table type
  T = (; zip(vars, eachcol(X))...)
  T |> Tables.materializer(table)
end