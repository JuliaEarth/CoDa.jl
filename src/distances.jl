# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    Aitchison

Aitchison distance between compositions.
"""
struct Aitchison <: Metric end

(::Aitchison)(c₁::Composition, c₂::Composition) = distance(c₁, c₂)

(d::Aitchison)(w₁, w₂) = d(Composition(w₁), Composition(w₂))

result_type(::Aitchison, w₁, w₂) = Float64