# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module CoDa

using CSV
using Tables
using DataFrames
using StatsBase
using StaticArrays
using UnicodePlots

import Base: +, -, *, ==
import Base: names, getproperty
import LinearAlgebra: norm, dot, ⋅

include("composition.jl")
include("transforms.jl")
include("utils.jl")

export
  # composition
  Composition,
  parts, components,
  norm, dot, ⋅,
  distance,

  # transforms
  alr, alrinv,
  clr, clrinv,
  ilr, ilrinv,

  # utils
  readcoda,
  compose

end
