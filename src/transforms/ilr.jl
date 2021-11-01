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
   ILR([refvar])

Isometric log-ratio transform following the
[TableTransforms.jl](https://github.com/JuliaML/TableTransforms.jl)
interface.

Optionally, specify the reference variable `refvar` for the ratios.
Default to the last column of the input table.
"""
struct ILR <: LogRatio
  refvar::Union{Symbol,Nothing}
end

ILR() = ILR(nothing)

function apply(transform::ILR, table)
  # basic checks
  for assertion in assertions(transform)
    assertion(table)
  end

  # original variable names
  vars = Tables.columnnames(table)

  # reference variable
  refvar = isnothing(transform.refvar) ? last(vars) : transform.refvar

  @assert refvar ∈ vars "invalid reference variable"

  # permute columns if necessary
  ptable = tableperm(table, refvar)

  # design matrix
  X = Tables.matrix(ptable)
  n = Tables.columnnames(ptable)

  # new variable names
  nvars = collect(n)[begin:end-1]

  # transformation
  Y = mapslices(ilr ∘ Composition, X, dims=2)

  # return same table type
  𝒯 = (; zip(nvars, eachcol(Y))...)
  newtable = 𝒯 |> Tables.materializer(table)

  # save reference index to revert later
  refind = indexin([refvar], collect(vars)) |> first

  newtable, (refvar, refind)
end

function revert(::ILR, table, cache)
  # retrieve cache
  refvar, refind = cache

  # design matrix
  Y = Tables.matrix(table)
  n = Tables.columnnames(table)

  # original variable names
  vars = [collect(n); refvar]

  # trasformation
  D = size(Y, 2)
  f = components ∘ ilrinv ∘ SVector{D}
  X = mapslices(f, Y, dims=2)

  # permute reference variable
  vars[[refind,end]] .= vars[[end,refind]]
  X[:,[refind,end]]  .= X[:,[end,refind]]

  # return same table type
  𝒯 = (; zip(vars, eachcol(X))...)
  𝒯 |> Tables.materializer(table)
end