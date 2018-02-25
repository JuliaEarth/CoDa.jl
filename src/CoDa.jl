# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

__precompile__()

module CoDa

using StatsBase
using StaticArrays
using UnicodePlots

import Base: +, -, *, ==
import Base.LinAlg: norm

include("composition.jl")
include("transforms.jl")

export
  # composition
  Composition,
  inner,
  distance,

  # transforms
  alr, alrinv,
  clr, clrinv,
  ilr, ilrinv

end
