<p align="center">
  <img src="docs/CoDa.png" height="200"><br>
  <a href="https://travis-ci.org/juliohm/CoDa.jl">
    <img src="https://travis-ci.org/juliohm/CoDa.jl.svg?branch=master">
  </a>
  <a href="https://codecov.io/gh/juliohm/CoDa.jl">
    <img src="https://codecov.io/gh/juliohm/CoDa.jl/branch/master/graph/badge.svg">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-ISC-blue.svg">
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

```julia
# 3-part compositions
cₒ = Composition(1,2,3)
c  = Composition(4,5,6)

# composition line passing through cₒ in the direction of c
f(λ) = cₒ + λ*c
```

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

[travis-img]: https://travis-ci.org/juliohm/CoDa.jl.svg?branch=master
[travis-url]: https://travis-ci.org/juliohm/CoDa.jl

[codecov-img]: https://codecov.io/gh/juliohm/CoDa.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/juliohm/CoDa.jl
