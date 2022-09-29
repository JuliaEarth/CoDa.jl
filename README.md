<p align="center">
  <img src="docs/CoDa.png" height="200"><br>
  <a href="https://github.com/JuliaEarth/CoDa.jl/actions">
    <img src="https://img.shields.io/github/workflow/status/JuliaEarth/CoDa.jl/CI?style=flat-square">
  </a>
  <a href="https://codecov.io/gh/JuliaEarth/CoDa.jl">
    <img src="https://img.shields.io/codecov/c/github/JuliaEarth/CoDa.jl?style=flat-square">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square">
  </a>
</p>

This package defines a `Composition{D}` type representing a D-part composition as defined by
[Aitchison 1986](https://www.jstor.org/stable/pdf/2345821.pdf). In Aitchison's geometry,
the D-simplex together with addition (a.k.a. pertubation) and scalar multiplication
(a.k.a. scaling) form a vector space, and important properties hold:

- Scaling invariance
- Pertubation invariance
- Permutation invariance
- Subcompositional coherence

In practice, this means that one can operate on compositional data (i.e.  vectors whose
entries represent parts of a total) without destroying the ratios of the parts.

## Installation

Get the latest stable release with Julia's package manager:

```julia
] add CoDa
```

## Usage

### Basics

Compositions are static vectors with named parts:

```julia
julia> using CoDa

julia> c = Composition(CO₂=2.0, CH₄=0.1, N₂O=0.3)
                  3-part composition
       ┌                                        ┐ 
   CO₂ ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 2.0   
   CH₄ ┤■■ 0.1                                    
   N₂O ┤■■■■■ 0.3                                 
       └                                        ┘ 

julia> parts(c)
(:CO₂, :CH₄, :N₂O)

julia> components(c)
3-element StaticArrays.SVector{3, Union{Missing, Float64}} with indices SOneTo(3):
 2.0
 0.1
 0.3

julia> c.CO₂
2.0
```

Default names are added otherwise:

```julia
julia> c = Composition(1.0, 0.1, 0.1)
                     3-part composition
      ┌                                        ┐ 
   w1 ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 1.0   
   w2 ┤■■■■ 0.1                                  
   w3 ┤■■■■ 0.1                                  
      └                                        ┘ 
```

and serve for internal compile-time checks.

Compositions can be added, subtracted, negated, and multiplied by
scalars. Other operations are also defined including dot product,
induced norm, and distance:

```julia
julia> cₒ = Composition(CO₂=1.0, CH₄=0.1, N₂O=0.1)
                  3-part composition
       ┌                                        ┐ 
   CO₂ ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 1.0   
   CH₄ ┤■■■■ 0.1                                  
   N₂O ┤■■■■ 0.1                                  
       └                                        ┘ 

julia> -cₒ
                  3-part composition
       ┌                                        ┐ 
   CO₂ ┤■■ 0.047619047619047616                   
   CH₄ ┤■■■■■■■■■■■■■■■■■■■ 0.47619047619047616   
   N₂O ┤■■■■■■■■■■■■■■■■■■■ 0.47619047619047616   
       └                                        ┘ 

julia> 0.5c
                  3-part composition
       ┌                                        ┐ 
   CO₂ ┤■■■■■■■■■■■■■■■■■■■■ 0.6207690197922022   
   CH₄ ┤■■■■ 0.13880817265812764                  
   N₂O ┤■■■■■■■■ 0.24042280754967013              
       └                                        ┘ 

julia> c - cₒ
                  3-part composition
       ┌                                        ┐ 
   CO₂ ┤■■■■■■■■■■■■■■■■■■■■■■■ 0.3333333333333333  
   CH₄ ┤■■■■■■■■■■■■ 0.16666666666666666          
   N₂O ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 0.5   
       └                                        ┘ 

julia> c ⋅ cₒ
3.7554028908352994

julia> norm(c)
2.1432393747688687

julia> aitchison(c, cₒ) # Aitchison distance
0.7856640352007868
```

More complex functions can be defined in terms of these
operations. For example, the function below defines the
composition line passing through `cₒ` in the direction of `c`:

```julia
julia> f(λ) = cₒ + λ*c
f (generic function with 1 method)
```

Finally, two compositions are considered to be equal when
their closure is approximately equal:

```julia
julia> c == c
true

julia> c == cₒ
false
```

### Transforms

Currently, the following transforms are implemented:

```julia
julia> alr(c)
2-element StaticArrays.SArray{Tuple{2},Float64,1,2} with indices SOneTo(2):
  1.8971199848858813
 -1.0986122886681096

julia> clr(c)
3-element StaticArrays.SArray{Tuple{3},Float64,1,3} with indices SOneTo(3):
  1.6309507528132907
 -1.3647815207407001
 -0.2661692320725906

julia> ilr(c)
2-element StaticArrays.SArray{Tuple{2},Float64,1,2} with indices SOneTo(2):
 -2.1183026052494185
 -0.3259894019031434
```

and their inverses `alrinv`, `clrinv` and `ilrinv`.

The package also defines transforms for tables following to the
[TableTransforms.jl](https://github.com/JuliaML/TableTransforms.jl) interface, including `Closure`, `Remainder`, `ALR`, `CLR`, `ILR`.
These transforms are functors that can be used as follows:

```julia
julia> table |> ILR()
```

### Arrays

It is often useful to compose `D` columns of a table into `D`-part compositions. The
package provides a `CoDaArray` type that implements the Julia array interface *and* the
Tables.jl interface. We recommend using the function `compose(table, cols)` to construct
such arrays:

```julia
julia> table = (a=[1,2,3], b=[4,5,6], c=[7,8,9])
(a = [1, 2, 3], b = [4, 5, 6], c = [7, 8, 9])

julia> ctable = compose(table, (:a,:b))
(c = [7, 8, 9], coda = Composition{2, (:a, :b)}["1.000 : 4.000", "2.000 : 5.000", "3.000 : 6.000"])

julia> ctable.coda[1]
                2-part composition
     ┌                                        ┐ 
   a ┤■■■■■■■■■ 1.0                             
   b ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 4.0   
     └                                        ┘ 
```

### Random

`D`-part compositions can be created at random from a Dirichlet distribution:

```julia
julia> rand(Composition{3})
                 3-part composition
      ┌                                        ┐ 
   w1 ┤■■■■■■■■■■■■■■■■■ 0.39938229705106565     
   w2 ┤■■■■■■ 0.1491859823748656                 
   w3 ┤■■■■■■■■■■■■■■■■■■■ 0.45143172057406883   
      └                                        ┘
```

### Plots

Separate packages are available for plotting compositional data:

- Relative variation biplots: [Biplots.jl](https://github.com/juliohm/Biplots.jl)
- Ternary plots [TernaryPlots.jl](https://github.com/jacobusmmsmit/TernaryPlots.jl)

## References

This package is heavily influenced by Aitchison's monograph:

- Aitchison, J. 1986. *The Statistical Analysis of Compositional Data*

and by other textbooks:

- den Boogaart, K. & Tolosana-Delgado. 2011. *Analyzing Compositional Data with R*
- Pawlowsky-Glahn et al. 2015. *Modeling and Analysis of Compositional Data*
- Pawlowsky-Glahn, V. & Buccianti, A. 2011. *Compositional Data Analysis - Theory and Applications*

### Notes

The unicode plot for composition objects can be obtained with the
following method:

```julia
using UnicodePlots
using CoDa

function Base.show(io::IO, mime::MIME"text/plain",
                   c::Composition{D,PARTS}) where {D,PARTS}
  w = components(c)
  x = Vector{Float64}()
  p = Vector{Symbol}()
  m = Vector{Symbol}()
  for i in 1:D
    if ismissing(w[i])
      push!(m, PARTS[i])
    else
      push!(p, PARTS[i])
      push!(x, w[i])
    end
  end
  plt = barplot(p, x, title="$D-part composition")
  isempty(m) || annotate!(plt, :t, "missing: $(join(m,", "))")
  show(io, mime, plt)
end
```

The method is not added to the CoDa.jl package itself because
the UnicodePlots.jl package has become a very heavy dependency, see
[UnicodePlots/issues/291](https://github.com/JuliaPlots/UnicodePlots.jl/issues/291).
