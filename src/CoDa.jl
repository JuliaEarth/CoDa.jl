# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module CoDa

using Tables
using StatsBase
using Statistics
using Distributions
using LinearAlgebra
using StaticArrays
using FillArrays
using AxisArrays
using Random
using Printf

import Base: +, -, *, /, ==
import Base: zero, adjoint, inv
import Distances: Metric, result_type
import Statistics: mean, var, std
import LinearAlgebra: norm, dot
import Random: rand

include("compositions.jl")
include("codaarrays.jl")
include("distances.jl")
include("logratio.jl")
include("covariances.jl")
include("matrices.jl")

export
  # compositions
  Composition,
  parts,
  components,
  norm,
  dot,
  ⋅,
  smooth,
  𝒞,
  mean,
  var,
  std,

  # arrays
  CoDaArray,
  compose,

  # distances
  Aitchison,
  aitchison,

  # log-ratio
  alr,
  alrinv,
  clr,
  clrinv,
  ilr,
  ilrinv,

  # covariances
  variation,
  alrcov,
  clrcov,
  lrarray,

  # matrices
  Diagonal,
  I,
  JMatrix,
  J,
  FMatrix,
  F,
  GMatrix,
  G,
  HMatrix,
  H

end
