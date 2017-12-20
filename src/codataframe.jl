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
    CoDataFrame(data, parts=names(data), total=1)

A set of compositions from a dataframe `data` in which
only the columns in `p` are retained and normalized
by the total `t`.

## Parameters

* data  - DataFrame with raw data to be closed
* parts - Column names to retain in the closure
* total - Total amount of the composition
"""
struct CoDataFrame{DF<:AbstractDataFrame}
  data::DF
  total::Float64

  function CoDataFrame{DF}(data, total) where {DF<:AbstractDataFrame}
    @assert total > 0 "total must be non-negative"
    new(data, total)
  end
end

function CoDataFrame(data; parts=names(data), total=1.)
  cdata = data[parts]

  # TODO: convert to compositions

  CoDataFrame{typeof(cdata)}(cdata, total)
end
