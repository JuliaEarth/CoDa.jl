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
using LinearAlgebra
using FillArrays
using Statistics

import Base: +, -, *, ==
import Base: names, getproperty
import LinearAlgebra: norm, dot, ⋅

include("composition.jl")
include("covariances.jl")
include("matrices.jl")
include("transforms.jl")
include("utils.jl")

export
  # covariances
  designmatrix,
  compvarmatrix,
  variationmatrix,
  lrcovmatrix,
  clrcovmatrix,

  # composition
  Composition,
  parts, components,
  norm, dot, ⋅,
  distance,

  # matrices
  JMatrix, J,
  FMatrix, F,
  GMatrix, G,
  HMatrix, H,

  # transforms
  alr, alrinv,
  clr, clrinv,
  ilr, ilrinv,

  # utils
  readcoda,
  compose

end
