using StagnationDetection
using BenchmarkTools

# measuring vector summation
# foldl still has optimisations?
# foldl replaced with a rough copy of dot

function bsum(::Type{T}, n::Int) where {T <: AbstractFloat}
    U = UInt
    if T == Float64
        U = UInt64
    elseif T == Float32
        U = UInt32
    elseif T == Float16
        U = UInt16
    end
    @btime lrsum(X) setup = (
        begin;
            X = reinterpret.($T, rand($U, $n));
        end;
    )
end

function bsum(::Type{T}, n::Int) where {T <: FloatSD}
    U = UInt
    if T == Float64SD
        U = UInt64
        F = Float64
    elseif T == Float32SD
        U = UInt32
        F = Float32
    elseif T == Float16SD
        U = UInt16
        F = Float16
    end
    @btime lrsum(X) setup = (
        begin;
            X = FloatSD.(reinterpret.($F, rand($U, $n)));
        end;
    )
end


function main()
    for T in [Float64, Float64SD, Float32, Float32SD, Float16, Float16SD], N in [1_000_000, 2_000_000, 4_000_000, 8_000_000]
        println("Vector sum T = ", string(T), ", N = ", string(N))
        display(bsum(T, N))
        println()
    end
end

main()