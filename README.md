Make `FITS` tables from `FITSIO.jl` conform to the `Tables.jl` interface.

With this package, you can do, e.g.
```julia
using FITSIO, FITSTables, DataFrames
df = FITS("table.fits") do f
    DataFrame(f[2])
end
```
