# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

import Base: *, +
import LinearAlgebra: Diagonal
import FillArrays: Ones

abstract type AbstractElementaryMatrix{T} end
(*)(E::AbstractElementaryMatrix, A::AbstractArray) = E(size(A)[1]) * A
(*)(A::AbstractArray, E::AbstractElementaryMatrix) = A * E(size(A)[2])
(+)(E::AbstractElementaryMatrix, A::AbstractArray) = E(size(A)[1]) + A
(+)(A::AbstractArray, E::AbstractElementaryMatrix) = E + A

"""
    JMatrix{T}

Square matrix of ones.
"""
struct JMatrix{T} <: AbstractElementaryMatrix{T}
end
JMatrix{T}(d::Integer) where {T} = Ones{T}(d, d)
(J::JMatrix{T})(d::Integer) where {T} = JMatrix{T}(d)
const J = JMatrix{Bool}()

"""
    FMatrix{T}

`F` matrix, as defined by Aitchison 1986.
"""
struct FMatrix{T} <: AbstractElementaryMatrix{T}
end
FMatrix{T}(d::Integer) where {T} = [Diagonal(fill(one(T), d)) -Ones{T}(d)]
(F::FMatrix{T})(d::Integer) where {T} = FMatrix{T}(d)
const F = FMatrix{Int}()
# overwrite right side multiplication, since F ins't a square matrix
(*)(F::FMatrix, A::AbstractArray) = F(size(A)[1]-1) * A

"""
    GMatrix{T}(N)

`G` matrix, as defined by Aitchison 1986.
"""
struct GMatrix{T} <: AbstractElementaryMatrix{T}
end
GMatrix{T}(D::Integer) where {T} = -ones(T, D, D)/D + Diagonal(fill(one(T), D))
(G::GMatrix{T})(D::Integer) where {T} = GMatrix{T}(D)
const G = GMatrix{Float64}()

"""
    HMatrix{T}(d)

`H` matrix, as defined by Aitchison 1986.
"""
struct HMatrix{T} <: AbstractElementaryMatrix{T}
end
HMatrix{T}(d::Integer) where {T} = ones(T, d, d) + Diagonal(fill(one(T), d))
(H::HMatrix{T})(d::Integer) where {T} = HMatrix{T}(d)
const H = HMatrix{Int}()
