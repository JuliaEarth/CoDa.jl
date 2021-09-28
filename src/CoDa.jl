# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module CoDa

using CSV
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

import Base: +, -, *, ==
import Base: adjoint, inv
import LinearAlgebra: norm, ⋅
import Random: rand
import Tables

include("compositions.jl")
include("codaarrays.jl")
include("transforms.jl")
include("covariances.jl")
include("matrices.jl")

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
  HMatrix, H

end
