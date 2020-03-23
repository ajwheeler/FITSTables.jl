module FITSTables

using Tables
using FITSIO

const THDU = Union{FITSIO.TableHDU, FITSIO.ASCIITableHDU}

Tables.istable(::Type{<:THDU}) = true

#TODO understand how this interracts with TableHDU "private" fields

Tables.columnaccess(::Type{<:THDU}) = true
Tables.columns(t::THDU) = t
Tables.columnnames(t::THDU) = Symbol.(FITSIO.colnames(t))
Tables.getcolumn(t::THDU, i::Int) = FITSIO.read(t, FITSIO.colnames(t)[i])
Tables.getcolumn(t::THDU, s::Symbol) = FITSIO.read(t, String(s))

end # module
