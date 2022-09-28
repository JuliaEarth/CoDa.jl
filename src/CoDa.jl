# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module CoDa

using Tables
using TableTransforms
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
import TableTransforms: TableTransform
import TableTransforms: StatelessTableTransform
import TableTransforms: assertions, isrevertible
import TableTransforms: applyfeat, revertfeat
import TableTransforms: preprocess, reapply
import Distances: Metric, result_type
import Base: +, -, *, /, ==
import Base: zero, adjoint, inv
import Statistics: mean, var, std
import LinearAlgebra: norm, ⋅
import Random: rand

include("compositions.jl")
include("codaarrays.jl")
include("scitypes.jl")
include("distances.jl")
include("transforms.jl")
include("covariances.jl")
include("matrices.jl")

export
  # compositions
  Composition,
  parts, components,
  norm, ⋅,
  smooth, 𝒞,
  mean, var, std,

  # arrays
  CoDaArray,
  compose,

  # distances
  Aitchison,
  aitchison,

  # transforms
  Closure,
  Remainder,
  LogRatio,
  ALR, CLR, ILR,
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
