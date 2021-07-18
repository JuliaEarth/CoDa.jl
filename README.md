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

This package is inspired by the R [compositions](https://cran.r-project.org/web/packages/compositions/index.html)
package for compositional data analysis. Currently, only **parts of the total** features
are implemented. Contributions are very welcome.

CoDa.jl defines a `Composition{D}` type representing a D-part composition as defined by
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
   part1 ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 1.0   
   part2 ┤■■■■ 0.1                                  
   part3 ┤■■■■ 0.1                                  
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

julia> distance(c, cₒ)
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

### Transformations

Currently, the following transformations are implemented:

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

### Utilities

It is often useful to compose `D` columns of a table into `D`-part compositions. The
package provides some utility functions for loading tabular data and for type conversion.

The function `readcoda(args...; codanames=[], kwargs...)` accepts the same arguments of
the `CSV.read` function from [CSV.jl](https://github.com/JuliaData/CSV.jl) plus an
additional keyword argument `codanames` that specifies the columns with the parts of
the composition.

Similarly, the function `compose(table, cols)` takes an already loaded table and converts
the specified columns into a single column with `Composition` objects.

## References

The most practical reference by far is the book
[*Analyzing Compositional Data With R*](http://www.springer.com/gp/book/9783642368080) by
van den Boogaart K. G. et al. 2013. The book contains the examples that I reproduced in
this README and is a good start for scientists who are seeing this material for the first
time.

A more theoretical exposition can be found in the book [*Modeling and Analysis of
Compositional Data*](https://www.wiley.com/en-us/Modeling+and+Analysis+of+Compositional+Data-p-9781118443064)
by Pawlowsky-Glahn, V. et al. 2015. It contains detailed explanations of the concepts
introduced by Aitchison in the 80s, and is co-authored by important names in the field.
