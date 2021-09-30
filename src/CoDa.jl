# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module CoDa

using Tables
using TableOperations
using Distributions
using StatsBase
using StaticArrays
using UnicodePlots
using LinearAlgebra
using FillArrays
using AxisArrays
using Statistics
using Random
using Printf

import Tables
import ScientificTypes as ST
import Distances: Metric, result_type
import Base: +, -, *, ==
import Base: adjoint, inv
import LinearAlgebra: norm, ⋅
import Random: rand

include("compositions.jl")
include("codaarrays.jl")
include("transforms.jl")
include("covariances.jl")
include("matrices.jl")
include("scitypes.jl")
include("distances.jl")

export
  # compositions
  Composition,
  parts, components,
  distance, norm, ⋅,

  # arrays
  CoDaArray,
  compose,

  # transforms
  alr, alrinv,
  clr, clrinv,
  ilr, ilrinv,

  # covariances
  variation,
  alrcov,
  clrcov,
  lrarray,

  # matrices
  Diagonal, I,
  JMatrix, J,
  FMatrix, F,
  GMatrix, G,
  HMatrix, H,

  # distances
  CoDaDistance

end
