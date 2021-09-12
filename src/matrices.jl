# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    JColumn{T}(d)

Column of ones.
"""
struct JColumn{T} <: AbstractVector{T}
  d::Int
end
JColumn(d::Int) = JColumn{Bool}(d)
Base.size(A::JColumn) = (A.d,)
Base.IndexStyle(::Type{<:JColumn}) = IndexLinear()
Base.getindex(A::JColumn{T}, i::Integer) where {T} = one(T)


"""
    JMatrix{T}(d)

Square matrix of ones.
"""
struct JMatrix{T} <: AbstractMatrix{T}
  d::Int
end
JMatrix(d::Int) = JMatrix{Bool}(d)
Base.size(A::JMatrix) = (A.d, A.d)
Base.IndexStyle(::Type{<:JMatrix}) = IndexCartesian()
Base.getindex(A::JMatrix{T}, i::Integer, j::Integer) where {T} = one(T)


"""
    FMatrix{T}(d)

`F` matrix, as defined by Aitchison 1986.
"""
struct FMatrix{T} <: AbstractMatrix{T}
  d::Int
end
FMatrix(d::Int) = FMatrix{Int}(d)
F(d::Int) = FMatrix(d)
Base.size(A::FMatrix) = (A.d, A.d+1)
Base.IndexStyle(::Type{<:FMatrix}) = IndexCartesian()
Base.getindex(A::FMatrix{T}, i::Integer, j::Integer) where {T} =  one(T)*((i==j) - (j==(A.d+1)))


"""
    GMatrix{T}(N)

`G` matrix, as defined by Aitchison 1986.
"""
struct GMatrix{T} <: AbstractMatrix{T}
  N::Int
end
GMatrix(N::Int) = GMatrix{Float64}(N)
G(N::Int) = GMatrix(N)
Base.size(A::GMatrix) = (A.N, A.N)
Base.IndexStyle(::Type{<:GMatrix}) = IndexCartesian()
Base.getindex(A::GMatrix{T}, i::Integer, j::Integer) where {T} = one(T)*(i==j) - one(T)/A.N



"""
    HMatrix{T}(d)

`H` matrix, as defined by Aitchison 1986.
"""
struct HMatrix{T} <: AbstractMatrix{T}
  d::Int
end
HMatrix(d::Int) = HMatrix{Int}(d)
H(d::Int) = HMatrix(d)
Base.size(A::HMatrix) = (A.d, A.d)
Base.IndexStyle(::Type{<:HMatrix}) = IndexCartesian()
Base.getindex(A::HMatrix{T}, i::Integer, j::Integer) where {T} = one(T)*(i==j) + one(T)
