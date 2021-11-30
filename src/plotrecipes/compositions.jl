# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

@recipe function f(c::Composition{D}) where {D}
  p = parts(c)
  w = components(c)

  # handle missing components
  s = string.(p)
  m = ismissing.(w)
  x = [m[i] ? s[i]*" (missing)" : s[i] for i in 1:D]
  y = [m[i] ? NaN : w[i] for i in 1:D]

  seriestype --> :bar
  legend --> false
  xticks --> (1:length(x), x)
  xrotation --> 30
  yguide --> "components"

  y
end