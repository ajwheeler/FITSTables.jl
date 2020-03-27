module FITSTables

using Tables
using FITSIO

const THDU = Union{FITSIO.TableHDU, FITSIO.ASCIITableHDU}

Tables.istable(::Type{<:THDU}) = true

#TODO understand how this interracts with TableHDU "private" fields

Tables.columnaccess(::Type{<:THDU}) = true
Tables.columns(t::THDU) = t
Tables.columnnames(t::THDU) = Symbol.(FITSIO.colnames(t))

"""reshape multidimensional array into array of (possibly multidimensional) arrays"""
function collapse(col::Array)
    dim = length(size(col))
    if dim == 1
        col
    else
        [view(col, vcat(repeat([:], dim-1), i)...) for i in 1:size(col, dim)]
    end
end
Tables.getcolumn(t::THDU, i::Int) = collapse(FITSIO.read(t, FITSIO.colnames(t)[i]))
Tables.getcolumn(t::THDU, s::Symbol) = collapse(FITSIO.read(t, String(s)))

end # module
