# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    JMatrix{T}

Square matrix of ones.
"""
struct JMatrix{T} end
(J::JMatrix{T})(d::Integer) where {T} = Ones{T}(d, d)
(*)(::JMatrix, v::AbstractVector) = Fill(sum(v), length(v))
(*)(v::Adjoint{<:Any, <:AbstractVector}, J::JMatrix) = (J*v')'

"""
    FMatrix{T}

`F` matrix, as defined by Aitchison 1986.
"""
struct FMatrix{T} end
(F::FMatrix{T})(d::Integer) where {T} = [Diagonal(fill(one(T), d)) -Ones{T}(d)]
(*)(::FMatrix{T}, v::AbstractVector) where {T} = Fill(-last(v), length(v)-1) + v[1:end-1]
(*)(v::Adjoint{<:Any, <:AbstractVector}, ::FMatrix) = [v -sum(v)]

"""
    GMatrix{T}(N)

`G` matrix, as defined by Aitchison 1986.
"""
struct GMatrix{T} end
(G::GMatrix{T})(D::Integer) where {T} = -ones(T, D, D)/D + Diagonal(fill(one(T), D))
(*)(::GMatrix, v::AbstractVector) = Fill(-sum(v)/length(v), length(v)) + v
(*)(v::Adjoint{<:Any, <:AbstractVector}, G::GMatrix) = (G*v')'

"""
    HMatrix{T}(d)

`H` matrix, as defined by Aitchison 1986.
"""
struct HMatrix{T} end
(H::HMatrix{T})(d::Integer) where {T} = ones(T, d, d) + Diagonal(fill(one(T), d))
(*)(::HMatrix, v::AbstractVector) = Fill(sum(v), length(v)) + v
(*)(v::Adjoint{<:Any, <:AbstractVector}, H::HMatrix) = (H*v')'

"""
    J(d)
    J
    F(d)
    F
    G(D)
    G
    H(d)
    H

User interfaces for the matrices JMatrix, FMatrix, GMatrix and HMatrix, as
defined by Aitchison 1986.

## Examples

Ordinary constructors of matrices
```
julia> H(3)
julia> G(3)
```

Sizeless linear transformations
```
julia> v'*F
julia> G*v
```
"""
const J = JMatrix{Bool}()
const F = FMatrix{Int}()
const G = GMatrix{Float64}()
const H = HMatrix{Int}()
