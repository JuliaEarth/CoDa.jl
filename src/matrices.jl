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

+(J::JMatrix, A) = J(size(A, 1)) + A
+(A, J::JMatrix) = J + A

-(J::JMatrix, A) = J + (-A)
-(A, J::JMatrix) = -(J - A)

*(J::JMatrix, A) = repeat(J.λ * sum(A, dims=1), size(A, 1))
*(A, J::JMatrix) = (J*A')'

adjoint(J::JMatrix) = J

"""
    FMatrix{T}

`F` matrix, as defined by Aitchison 1986. See also [`F`](@ref).
"""
struct FMatrix{T}
  λ::T
end

(F::FMatrix{T})(d::Integer) where {T} = F.λ * [I(d) -Ones{T}(d)]

*(λ::Number, F::FMatrix) = FMatrix(F.λ * λ)

+(F::FMatrix, A) = F(size(A, 1)) + A
+(A, F::FMatrix) = F + A

-(F::FMatrix, A) = F + (-A)
-(A, F::FMatrix) = -(F - A)

*(F::FMatrix, A) = begin
  R = F.λ * (A[begin:end-1,:] .- A[end:end,:])
  ndims(A) == 1 ? vec(R) : R
end
*(A, F::FMatrix) = F.λ * [A -sum(A, dims=2)]

adjoint(F::FMatrix) = F′Matrix(F.λ)

"""
    F′Matrix{T}

Lazy adjoint of `FMatrix{T}`.
"""
struct F′Matrix{T}
  λ::T
end

(F′::F′Matrix{T})(d::Integer) where {T} = F′.λ * [I(d); -Ones{T}(1,d)]

*(λ::Number, F′::F′Matrix) = F′Matrix(F′.λ * λ)

+(F′::F′Matrix, A) = F′(size(A, 2)) + A
+(A, F′::F′Matrix) = F′ + A

-(F′::F′Matrix, A) = F′ + (-A)
-(A, F′::F′Matrix) = -(F′ - A)

*(F′::F′Matrix, A) = F′.λ * [A; -sum(A, dims=1)]
*(A, F′::F′Matrix) = F′.λ * (A[:,begin:end-1] .- A[:,end:end])

adjoint(F′::F′Matrix) = FMatrix(F′.λ)

"""
    GMatrix{T}

`G` matrix, as defined by Aitchison 1986. See also [`G`](@ref).
"""
struct GMatrix{T}
  λ::T
end

(G::GMatrix{T})(D::Integer) where {T} = G.λ * I(D) - (G.λ / D) * J(D)

*(λ::Number, G::GMatrix) = GMatrix(G.λ * λ)

+(G::GMatrix, A) = G(size(A, 1)) + A
+(A, G::GMatrix) = G + A

-(G::GMatrix, A) = G + (-A)
-(A, G::GMatrix) = -(G - A)

*(G::GMatrix, A) = G.λ * (A .- sum(A, dims=1) / size(A, 1))
*(A, G::GMatrix) = (G*A')'

adjoint(G::GMatrix) = G

"""
    HMatrix{T}

`H` matrix, as defined by Aitchison 1986. See also [`H`](@ref).
"""
struct HMatrix{T}
  λ::T
end

(H::HMatrix{T})(d::Integer) where {T} = H.λ * I(d) +  H.λ * J(d)

*(λ::Number, H::HMatrix) = HMatrix(H.λ * λ)

+(H::HMatrix, A) = H(size(A, 1)) + A
+(A, H::HMatrix) = H + A

-(H::HMatrix, A) = H + (-A)
-(A, H::HMatrix) = -(H - A)

*(H::HMatrix, A) = H.λ * (A .+ sum(A, dims=1))
*(A, H::HMatrix) = H.λ * (A .+ sum(A, dims=2))

inv(H::HMatrix) = H⁻¹Matrix(inv(H.λ))

"""
    H⁻¹Matrix{T}

Lazy inverse of `HMatrix{T}`.
"""
struct H⁻¹Matrix{T}
  λ::T
end

(H⁻¹::H⁻¹Matrix{T})(d::Integer) where {T} = H⁻¹.λ * I(d) - (H⁻¹.λ / (d+1)) * J(d)

*(λ::Number, H⁻¹::H⁻¹Matrix) = H⁻¹Matrix(H⁻¹.λ * λ)

+(H⁻¹::H⁻¹Matrix, A) = H⁻¹(size(A, 1)) + A
+(A, H⁻¹::H⁻¹Matrix) = H⁻¹ + A

-(H⁻¹::H⁻¹Matrix, A) = H⁻¹ + (-A)
-(A, H⁻¹::H⁻¹Matrix) = -(H⁻¹ - A)

*(H⁻¹::H⁻¹Matrix, A) = H⁻¹.λ * (A .- sum(A, dims=1) / (size(A, 1) + 1))
*(A, H⁻¹::H⁻¹Matrix) = H⁻¹.λ * (A .- sum(A, dims=2) / (size(A, 2) + 1))

inv(H⁻¹::H⁻¹Matrix) = HMatrix(inv(H⁻¹.λ))

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
const F = FMatrix{Int}(1)


"""
    G
    G(D)

User interface for [`GMatrix`](@ref), as defined by Aitchison.

`G` is an `D` by `D` matrix that can be defined as

`G[i, j] = I[i, j] - J[i, j] / D`

## Examples

```
julia> G(3)
julia> G*v
julia> v'*G
```
"""
const G = GMatrix{Float64}(1.0)

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
const H = HMatrix{Int}(1)
