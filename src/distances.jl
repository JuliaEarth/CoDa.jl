# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    CoDaDistance

Distance between compositions in Aitchison geometry.
"""
struct CoDaDistance <: Metric end

(dist::CoDaDistance)(x,y) = distance(x, y)