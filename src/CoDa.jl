# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

module CoDa

using CSV: read
using StatsBase
using StaticArrays
using UnicodePlots

import Base: +, -, *, ==, names
import LinearAlgebra: norm, dot, ⋅

include("composition.jl")
include("transforms.jl")
include("utils.jl")

export
  # composition
  Composition,
  norm, dot, ⋅,
  distance,
  names,

  # transforms
  alr, alrinv,
  clr, clrinv,
  ilr, ilrinv,

  # utils
  readcoda,
  compose

end
