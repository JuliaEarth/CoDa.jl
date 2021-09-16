# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    designmatrix(comps)
    
Converts a vector of `Composition{D}` objects into the N by D design matrix.
"""
designmatrix(comps) = reduce(hcat, components.(comps))'

"""
    compvarmatrix(comps)

Returns the variation array `A` such that:

- `A[i,j] = E[log(x[i]/x[j])]` for `i > j`
- `A[i,j] = Var(log(x[i]/x[j]))` for `i < j`
- `A[i,j] = 0` for `i = j`
"""
function compvarmatrix(comps)
  X = designmatrix(comps)
  N, D = size(X)
  Α = zeros(D, D)

  for i in 1:D
    for j in i+1:D
      lr = log.(X[:, i] ./ X[:, j])
      Α[j,i] = mean(lr)
      Α[i,j] = var(lr, corrected=false)
    end
  end

  Α
end

"""
    variationmatrix(comps)

Return the variation matrix, definition 4.4 of Aitchson - The Statistical Analysis of Compositional Data.
"""
function variationmatrix(comps)
  X = designmatrix(comps)
  N, D = size(X)
  Τ = zeros(D, D)

  for i in 1:D
    for j in 1:D
      Τ[i, j] = var(log.(X[:, i] ./ X[:, j]), corrected=false)
    end
  end

  Τ
end

"""
    lrcovmatrix(comps)

Return the log ratio covariance matrix, definition 4.5 of Aitchson - The Statistical Analysis of Compositional Data.
"""
function lrcovmatrix(comps)
  lrcomps = alr.(comps)
  lrmatrix = reduce(hcat, lrcomps)'
  Σ = cov(lrmatrix, corrected=false)
end

"""
    clrcovmatrix(comps)

Return the centered log ratio covariance matrix, definition 4.6 of Aitchson - The Statistical Analysis of Compositional Data.
"""
function clrcovmatrix(comps)
  clrcomps = clr.(comps)
  clrmatrix = reduce(hcat, clrcomps)'
  Γ = cov(clrmatrix, corrected=false)
end