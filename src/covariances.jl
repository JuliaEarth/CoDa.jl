# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    design(comps)
    
Converts a vector of `Composition{D}` objects into the N by D design matrix.
"""
design(comps) = reduce(hcat, components.(comps))'

"""
    variation(table)

Return the variation matrix `Τ` of the `table` such that:

- `Τ[i,j] = Var(log(x[i]/x[j]))` for `i, j = 1, ..., D`
"""
function variation(table)
  X = Tables.matrix(table)
  n = Tables.columnnames(table) |> collect
  D = size(X, 2)
  L = log.(X)

  T = [var(L[:,i] .- L[:,j]) for i in 1:D, j in 1:D]

  # return array with named axis
  AxisArray(T, row=n, col=n)
end

"""
    alrcov(table)

Return the log-ratio covariance matrix `Σ` of the `table` such that:

- `Σ[i,j] = cov(log(x[i]/x[D]), log(x[j]/x[D]))` for `i, j = 1, ..., d`
"""
function alrcov(table)
  X = Tables.matrix(table)
  n = Tables.columnnames(table) |> collect
  L = log.(X)

  Σ = cov(L[:,begin:end-1] .- L[:,end], dims=1)

  # return array with named axis
  AxisArray(Σ, row=n[begin:end-1], col=n[begin:end-1])
end

"""
    clrcov(table)

Return the centered log-ratio covariance matrix `Γ` of the `table` such that:

- `Γ[i,j] = cov(log(x[i]/g(x)), log(x[j]/g(x)))` for `i, j = 1, ..., D`,
where `g(x)` is the geometric mean.
"""
function clrcov(table)
  X = Tables.matrix(table)
  n = Tables.columnnames(table) |> collect
  g = geomean.(eachrow(X))
  L = log.(X)
  l = log.(g)

  Γ = cov(L .- l, dims=1)

  # return array with named axis
  AxisArray(Γ, row=n, col=n)
end

"""
    lrarray(table)

Return the variation array `A` of the `table` such that:

- `A[i,j] = E[log(x[i]/x[j])]` for `i > j`
- `A[i,j] = Var(log(x[i]/x[j]))` for `i < j`
- `A[i,j] = 0` for `i = j`
"""
function lrarray(table)
  X = Tables.matrix(table)
  n = Tables.columnnames(table) |> collect
  D = size(X, 2)
  L = log.(X)

  A = Matrix{Float64}(undef, D, D)
  for i in 1:D
    for j in i+1:D
      lr = L[:,i] .- L[:,j]
      A[j,i] = mean(lr)
      A[i,j] = var(lr)
    end
    A[i,i] = 0.0
  end

  A

  # return array with named axis
  AxisArray(A, row=n, col=n)
end