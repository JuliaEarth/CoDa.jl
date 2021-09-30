# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    CoDaDistance

Distance object based on Metric by Distances.jl.
"""
struct CoDaDistance <: Metric end

"""
    CoDaDistance()(x,y)

With an object d of CoDaDistance instantiated, CoDaDistance
simply is d(x,y), where x and y are compositions.
"""
(dist::CoDaDistance)(x,y) = distance(x, y)