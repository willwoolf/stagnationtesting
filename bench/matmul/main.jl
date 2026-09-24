using StagnationDetection
using BenchmarkTools

# measuring matrix multiplication
# scaling with output size (allocs grows)
# scaling with problem size (what happens)

"""
Example call
bmatmul(Float64, 1000, 2000) for 1000×1000 matrix with inner compute dot product length m = 2000
"""
function bmatmul(::Type{T}, m::Int, n::Int) where {T <: AbstractFloat}
    U = UInt
    if T == Float64
        U = UInt64
    elseif T == Float32
        U = UInt32
    elseif T == Float16
        U = UInt16
    end
    return @benchmark lrmatmul(A, B) setup = (
        begin;
            A = (reinterpret.($T, rand($U, $m, $n)));
            B = (reinterpret.($T, rand($U, $n, $m)));
        end;
    )
end

function bmatmul(::Type{T}, m::Int, n::Int) where {T <: FloatSD}
    U = UInt
    F = Float64
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
    return @benchmark lrmatmul(A, B) setup = (
        begin;
            A = FloatSD.(reinterpret.($F, rand($U, $m, $n)));
            B = FloatSD.(reinterpret.($F, rand($U, $n, $m)));
        end;
    )
end

function main()
    for T in [Float64, Float64SD], M in [1_000, 2_000], N in [1_000, 2_000, 4_000]
        println("Matrix multiply T = ", string(T))
        println("M = ", string(M), "(output size M×M)")
        println("N = ", string(N), "(inner product length N)")
        display(bmatmul(T, M, N))
        println()
    end
end

main()
