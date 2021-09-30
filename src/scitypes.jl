# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

ST.scitype(::Composition{D}, ::ST.DefaultConvention) where {D} = ST.Compositional{D}

function ST.scitype(::CoDaArray{D}, ::ST.DefaultConvention) where {D}
  T = ST.Compositional{D}
  AbstractVector{T}
end