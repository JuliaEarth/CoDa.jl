## Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
##
## Permission to use, copy, modify, and/or distribute this software for any
## purpose with or without fee is hereby granted, provided that the above
## copyright notice and this permission notice appear in all copies.
##
## THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
## WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
## ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
## WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
## ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
## OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

"""
    Composition{D}(parts)

A D-part composition as defined by Aitchison 1986.
"""
struct Composition{D}
  parts::MVector{D,Float64}
end

Composition(parts) = Composition{length(parts)}(parts)

"""
    normalize!(c)

Normalize composition `c` in place.
"""
function normalize!(c::Composition)
  p = c.parts
  s = sum(p)
  for i in eachindex(p)
    p[i] /= s
  end
end

"""
    c₁ + c₂

Add (or perturb) compositions `c₁` and `c₂`.
"""
function +(c₁::Composition, c₂::Composition)
  c = Composition(c₁.parts .* c₂.parts)
  normalize!(c)
  c
end

"""
    α * c

Scale composition `c` with real number `α`.
"""
*(α::Real, c::Composition) = Composition(c.parts.^α)
