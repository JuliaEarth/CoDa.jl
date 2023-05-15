# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    aitchison(c₁, c₂)

Return the Aitchison distance between compositions `c₁` and `c₂`.
"""
aitchison(c₁::Composition, c₂::Composition) = norm(c₁ - c₂)

"""
    Aitchison()

Aitchison distance following the Distances.jl API.
"""
struct Aitchison <: Metric end

(::Aitchison)(c₁::Composition, c₂::Composition) = aitchison(c₁, c₂)

(d::Aitchison)(w₁, w₂) = d(Composition(w₁), Composition(w₂))

result_type(::Aitchison, w₁, w₂) = Float64
