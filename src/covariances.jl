# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    designmatrix(comps)
    
Converts a vector of Composition objects into a Matrix of numbers.
"""
function designmatrix(comps)
    reduce(hcat, components.(comps))'
end

"""
    compvarmatrix(comps)

Returns the compositional variation array, from definition 4.3 of Aitchson - The Statistical Analysis of Compositional Data.
"""
function compvarmatrix(comps)
    X = designmatrix(comps)
    N, D = size(X)
    cva = zeros(D, D)

    for i in 1:D
        for j in i+1:D
            log_ratios = log.(X[:, i] ./ X[:, j])
            cva[j, i] = sum(log_ratios) / N
            cva[i, j] = sum((log_ratios .- cva[j, i]).^2 ) / N
        end
    end

    return cva
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
    
    return Τ
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