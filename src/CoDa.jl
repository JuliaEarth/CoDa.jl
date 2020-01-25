# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

module CoDa

using StatsBase
using StaticArrays
using UnicodePlots

import Base: +, -, *, ==
import LinearAlgebra: norm, dot, ⋅

include("composition.jl")
include("transforms.jl")

export
  # composition
  Composition,
  norm, dot, ⋅
  distance,

  # transforms
  alr, alrinv,
  clr, clrinv,
  ilr, ilrinv

end
