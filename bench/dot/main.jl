using StagnationDetection
using BenchmarkTools

# measuring vector dot products

function bdot(::Type{T}, n::Int) where {T <: AbstractFloat}
    U = UInt
    if T == Float64
        U = UInt64
    elseif T == Float32
        U = UInt32
    elseif T == Float16
        U = UInt16
    end
    @btime lrdot(X, Y) setup = (
        begin;
            X = reinterpret.($T, rand($U, $n));
            Y = reinterpret.($T, rand($U, $n)); 
        end;
    )
end

function bdot(::Type{T}, n::Int) where {T <: FloatSD}
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
    @btime lrdot(X, Y) setup = (
        begin;
            X = FloatSD.(reinterpret.($F, rand($U, $n)));
            Y = FloatSD.(reinterpret.($F, rand($U, $n))); 
        end;
    )
end

function main()
    for T in [Float64, Float64SD], N in [1_000_000, 2_000_000, 4_000_000, 8_000_000]
        println("Vector inner product T = ", string(T), ", N = ", string(N))
        display(bdot(T, N))
        println()
    end
end

main()