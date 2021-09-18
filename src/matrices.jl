# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    JMatrix{T}

Square matrix of ones. See also [`J`](@ref).
"""
struct JMatrix{T}
  λ::T
end

(J::JMatrix{T})(d::Integer) where {T} = J.λ * Ones{T}(d, d)

*(λ::Number, J::JMatrix) = JMatrix(J.λ * λ)

+(J::JMatrix{T}, A) where {T} = J.λ * Ones{T}(size(A)) + A
+(A, J::JMatrix{T}) where {T} = J + A

*(J::JMatrix, A) = repeat(J.λ * sum(A, dims=1), size(A, 1))
*(A, J::JMatrix) = (J*A')'

"""
    FMatrix{T}

`F` matrix, as defined by Aitchison 1986. See also [`F`](@ref).
"""
struct FMatrix{T} end
(F::FMatrix{T})(d::Integer) where {T} = [I(d) -Ones{T}(d)]
*(::FMatrix{T}, v::AbstractVector) where {T} = v[1:end-1] .- v[end]
*(v::Adjoint{<:Any, <:AbstractVector}, ::FMatrix) = [v -sum(v)]

"""
    GMatrix{T}

`G` matrix, as defined by Aitchison 1986. See also [`G`](@ref).
"""
struct GMatrix{T} end
(G::GMatrix{T})(D::Integer) where {T} = I(D) - (1/D) * J(D)
*(::GMatrix, v::AbstractVector) = v .- sum(v) / length(v)
*(v::Adjoint{<:Any, <:AbstractVector}, G::GMatrix) = (G*v')'

"""
    HMatrix{T}

`H` matrix, as defined by Aitchison 1986. See also [`H`](@ref).
"""
struct HMatrix{T} end
(H::HMatrix{T})(d::Integer) where {T} = I(d) + J(d)
*(::HMatrix, v::AbstractVector) = v .+ sum(v)
*(v::Adjoint{<:Any, <:AbstractVector}, H::HMatrix) = (H*v')'

"""
    J
    J(d)

User interface for [`JMatrix`](@ref), a `d` by `d` matrix of ones.

## Examples

```
julia> J(3)
julia> J*v
julia> v'*J
```
"""
const J = JMatrix{Bool}(true)

"""
    F
    F(d)

User interface for [`FMatrix`](@ref), as defined by Aitchison.

`F` is a `d` by `D` matrix that can be defined as

`F[i, j] = 1`, if `i==j`

`F[i, j] = -1`, if `j==D`

`F[i, j] = 0`, otherwise

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
    G(N)

User interface for [`GMatrix`](@ref), as defined by Aitchison.

`G` is an `N` by `N` (usually with `N:=D`) matrix that can be defined as

`G[i, j] = I[i, j] - J[i, j] / N`

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

User interface for [`HMatrix`](@ref), as defined by Aitchison.

`H` is a `d` by `d` matrix that can be defined as

`H[i, j] = I[i, j] + J[i, j]`

## Examples

```
julia> H(3)
julia> H*v
julia> v'*H
```
"""
const H = HMatrix{Int}()
