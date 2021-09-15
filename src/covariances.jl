# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    design_matrix(comps)
    
Converts a vector of Composition objects into a Matrix of numbers.
"""
function design_matrix(comps)
    matrix = reduce(hcat, components.(comps)[:,1])'
    return matrix
end

"""
    comp_var_array(comps)

Returns the compositional variation array, from definition 4.3 of Aitchson - The Statistical Analysis of Compositional Data.
"""
function comp_var_array(comps)
    dm = design_matrix(comps)
    N, D = size(dm)
    cva = zeros(D, D)

    for i in 1:D
        for j in i+1:D
            log_ratios = log.(dm[:, i] ./ dm[:, j])
            cva[j, i] = sum(log_ratios) / N
            cva[i, j] = sum((log_ratios .- cva[j, i]).^2 ) / N
        end
    end

    return cva
end

"""
    variation_matrix(comps)

Return the variation matrix, definition 4.4 of Aitchson - The Statistical Analysis of Compositional Data.
"""
function variation_matrix(comps)
    dm = design_matrix(comps)
    N, D = size(dm)
    va = zeros(D, D)
    
    for i in 1:D
        for j in 1:D
            va[i, j] = Statistics.var(log.(dm[:, i] ./ dm[:, j]), corrected=false)
        end
    end
    
    return va
end

"""
    lrcov_matrix(comps)

Return the log ratio covariance matrix, definition 4.5 of Aitchson - The Statistical Analysis of Compositional Data.
"""
function lrcov_matrix(comps)
    lrcomps = CoDa.alr.(comps)
    lrmatrix = reduce(hcat, lrcomps[:, 1])'

    return Statistics.cov(lrmatrix, corrected=false)
end

"""
    clrcov_matrix(comps)

Return the centered log ratio covariance matrix, definition 4.6 of Aitchson - The Statistical Analysis of Compositional Data.
"""
function clrcov_matrix(comps)
    clrcomps = CoDa.clr.(comps)
    clrmatrix = reduce(hcat, clrcomps[:, 1])'
    
    return Statistics.cov(clrmatrix, corrected=false)
end