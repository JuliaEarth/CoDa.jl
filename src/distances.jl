# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    CoDaDistance

Distance between compositions in Aitchison geometry.
"""
struct CoDaDistance <: Metric end

(d::CoDaDistance)(x, y) = distance(x, y)
result_type(d::CoDaDistance, x, y) = Float64