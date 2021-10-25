# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    variation(table)

Return the variation matrix `Τ` of the `table` such that:

- `Τ[i,j] = Var(log(x[i]/x[j]))` for `i, j = 1, ..., D`
"""
function variation(table)
  X = Tables.matrix(table)
  n = Tables.columnnames(table) |> collect
  D = size(X, 2)
  L = log.(X .+ eps())

  T = Matrix{Float64}(undef, D, D)
  for j in 1:D
    for i in j+1:D
      lr = L[:,i] .- L[:,j]
      T[i,j] = var(lr)
    end
    T[j,j] = 0.0
    for i in 1:j-1
      T[i,j] = T[j,i]
    end
  end

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
  L = log.(X .+ eps())

  Σ = cov(L[:,begin:end-1] .- L[:,end], dims=1)

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
  L = log.(X .+ eps())
  l = log.(g .+ eps())

  Γ = cov(L .- l, dims=1)

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
  L = log.(X .+ eps())

  A = Matrix{Float64}(undef, D, D)
  for i in 1:D
    for j in i+1:D
      lr = L[:,i] .- L[:,j]
      A[j,i] = mean(lr)
      A[i,j] = var(lr)
    end
    A[i,i] = 0.0
  end

  AxisArray(A, row=n, col=n)
end