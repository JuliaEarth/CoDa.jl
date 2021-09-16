# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    design(comps)
    
Converts a vector of `Composition{D}` objects into the N by D design matrix.
"""
design(comps) = reduce(hcat, components.(comps))'

"""
    variation(comps)

Returns the variation matrix `Τ` such that:

- `Τ[i,j] = Var(log(x[i]/x[j]))` for `i, j = 1, ..., D`
"""
function variation(comps)
  X = design(comps)
  N, D = size(X)

  Τ = Matrix{Float64}(undef, D, D)
  for i in 1:D
    for j in 1:D
      Τ[i,j] = var(log.(X[:,i] ./ X[:,j]))
    end
  end

  Τ
end

"""
    alrcov(comps)

Returns the logratio covariance matrix `Σ` such that:

- `Σ[i,j] = Cov(log(x[i]/x[D]), log(x[j]/x[D]))` for `i, j = 1, ..., d`
"""
alrcov(comps) = cov(reduce(hcat, alr.(comps)), dims=2)

"""
    clrcov(comps)

Returns the centred logratio covariance matrix `Γ` such that:

- `Γ[i,j] = Cov(log(x[i]/g(x)), log(x[j]/g(x)))` for `i, j = 1, ..., D`,
where g(x) is the geometric mean.
"""
clrcov(comps) = cov(reduce(hcat, clr.(comps)), dims=2)

"""
    lrarray(comps)

Returns the variation array `A` such that:

- `A[i,j] = E[log(x[i]/x[j])]` for `i > j`
- `A[i,j] = Var(log(x[i]/x[j]))` for `i < j`
- `A[i,j] = 0` for `i = j`
"""
function lrarray(comps)
  X = design(comps)
  N, D = size(X)

  Α = Matrix{Float64}(undef, D, D)
  for i in 1:D
    for j in i+1:D
      lr = log.(X[:,i] ./ X[:,j])
      Α[j,i] = mean(lr)
      Α[i,j] = var(lr)
    end
    A[i,i] = 0.0
  end

  Α
end