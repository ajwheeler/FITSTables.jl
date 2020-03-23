using Test, Tables, FITSIO
using FITSTables

@testset "All Tests" begin
	mktempdir() do tmp
        FITS(tmp*"/smalltable.fits", "w") do f
            col1 = [1., 2., 3.]
            col2 = [1, 2, 3]
            write(f, ["col1", "col2"], [col1, col2])
            tab = f[2]

            @testset "types work out" begin
                @test Tables.istable(FITSIO.ASCIITableHDU)
                @test Tables.istable(FITSIO.TableHDU)
                @test Tables.istable(typeof(tab))
                @test Tables.columnaccess(typeof(tab))
            end

            @test Tables.columns(tab) === tab

            @testset "columnaccess with getcolumn" begin
                @test Tables.getcolumn(tab, :col1) == col1
                @test Tables.getcolumn(tab, :col2) == col2
                @test Tables.getcolumn(tab, 1) == col1
                @test Tables.getcolumn(tab, 2) == col2
            end

            @testset "column names match" begin
                @test Tables.columnnames(tab) == [:col1, :col2]
            end

            @testset "row iteration" begin
                row = first(Tables.rows(tab))
                #@test eltype(tab) == typeof(row) #TODO should this work?
                @test row.col1 == col1[1]
                @test Tables.getcolumn(row, :col1) == col1[1]
                @test Tables.getcolumn(row, 1) == col1[1]
                @test propertynames(row) == [:col1, :col2]
            end
        end
    end
end
