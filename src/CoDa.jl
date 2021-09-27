# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module CoDa

using CSV
using Tables
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
import Base: names, getproperty
import LinearAlgebra: norm, dot, ⋅
import Random: rand
import Tables

include("compositions.jl")
include("covariances.jl")
include("matrices.jl")
include("transforms.jl")
include("codaarrays.jl")
include("utils.jl")

export
  # composition
  Composition,
  parts, components,
  norm, dot, ⋅,
  distance,

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

  # transforms
  alr, alrinv,
  clr, clrinv,
  ilr, ilrinv,

  # arrays
  CoDaArray,

  # utils
  compose

end
