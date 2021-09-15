# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    JMatrix{T}

Square matrix of ones.
"""
struct JMatrix{T} end
(J::JMatrix{T})(d::Integer) where {T} = Ones{T}(d, d)
*(::JMatrix, v::AbstractVector) = Fill(sum(v), length(v))
*(v::Adjoint{<:Any, <:AbstractVector}, J::JMatrix) = (J*v')'

"""
    FMatrix{T}

`F` matrix, as defined by Aitchison 1986.
"""
struct FMatrix{T} end
(F::FMatrix{T})(d::Integer) where {T} = [I(d) -Ones{T}(d)]
*(::FMatrix{T}, v::AbstractVector) where {T} = v[1:end-1] .- v[end]
*(v::Adjoint{<:Any, <:AbstractVector}, ::FMatrix) = [v -sum(v)]

"""
    GMatrix{T}(N)

`G` matrix, as defined by Aitchison 1986.
"""
struct GMatrix{T} end
(G::GMatrix{T})(D::Integer) where {T} =  I(D) - (1/D) * J(D)
*(::GMatrix, v::AbstractVector) = v .-sum(v)/length(v)
*(v::Adjoint{<:Any, <:AbstractVector}, G::GMatrix) = (G*v')'

"""
    HMatrix{T}(d)

`H` matrix, as defined by Aitchison 1986.
"""
struct HMatrix{T} end
(H::HMatrix{T})(d::Integer) where {T} = I(d) + J(d)
*(::HMatrix, v::AbstractVector) = v .+ sum(v)
*(v::Adjoint{<:Any, <:AbstractVector}, H::HMatrix) = (H*v')'

"""
    J
    J(d)

User interface for JMatrix, the matrix of ones.

## Examples

```
julia> J(3)
julia> J*v
julia> v'*J
```
"""
const J = JMatrix{Bool}()

"""
    F
    F(d)

User interface for FMatrix, as defined by Aitchison.

## Examples

```
julia> F(3)
julia> F*v
julia> v'*F
```
"""
const F = FMatrix{Int}()


"""
    G
    G(d)

User interface for GMatrix, as defined by Aitchison.

## Examples

```
julia> G(3)
julia> G*v
julia> v'*G
```
"""
const G = GMatrix{Float64}()

"""
    H
    H(d)

User interface for HMatrix, as defined by Aitchison.

## Examples

```
julia> H(3)
julia> H*v
julia> v'*H
```
"""
const H = HMatrix{Int}()
