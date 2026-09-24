using StagnationDetection

import Random: Xoshiro, shuffle, shuffle!

## sorting functions

function sort_ascending!(rng, X::Vector)
    sort!(X, by = abs)
    return nothing
end

function sort_descending!(rng, X::Vector)
    sort!(X, by = abs, lt = Base.isgreater)
    return nothing
end

function sort_random!(rng, X::Vector)
    shuffle!(rng, X)
    return nothing
end

## main results function

function sumlengths(io, rng, L::Vector, X::Vector{T}, Y::Vector{U} = [1]) where {T <: FloatSD, U <: Union{Float32SD, Float16SD, Int}}
    maxlength = maximum(L)
    @assert maxlength == last(L)
    @assert issorted(L)
    @assert maxlength == length(X)
    @assert (length(Y) == 1 && first(Y) == 1) || length(Y) == length(X)

    Z = ifelse(length(X) == length(Y), X .* Y, X)

    sort_funcs = [
        sort_ascending!,
        sort_descending!,
        sort_random!
    ]

    STAG = zeros(Int, lastindex(L), lastindex(sort_funcs))
    RERR = zeros(Float64, lastindex(L), lastindex(sort_funcs))

    for fsort_idx in 1:lastindex(sort_funcs)
        fsort! = sort_funcs[fsort_idx]

        fsort!(rng, Z)

        accumulator = T(0)
        accumulator_high = Float64(0)

        i = 1        
        for len_idx in 1:lastindex(L)
            sumlength = L[len_idx]
            while i < sumlength
                accumulator += Z[i]
                accumulator_high += Float64(Z[i])
                i += 1
            end

            abserr = abs(accumulator - accumulator_high)
            relerr = abserr/abs(accumulator_high)

            RERR[len_idx, fsort_idx] = ifelse(abserr == 0, 0, relerr)
            STAG[len_idx, fsort_idx] = diff_absorptions(accumulator)

        end

    end 

    println(io, "n, stagn(asc), stagf(asc), relerr(asc), stagn(desc), stagf(desc), relerr(desc), stagn(rand), stagf(rand), relerr(rand)")
    
    for len_idx in 1:lastindex(L)
        n = L[len_idx]

        stag_asc = STAG[len_idx, 1]
        stag_dec = STAG[len_idx, 2]
        stag_rand = STAG[len_idx, 3]

        relerr_asc = RERR[len_idx, 1]
        relerr_dec = RERR[len_idx, 2]
        relerr_rand = RERR[len_idx, 3]

        println(io, n, ", ", stag_asc, ", ", stag_asc * 100 / (n - 1), ", ", relerr_asc, ", ", stag_dec, ", ", stag_dec * 100 / (n - 1), ", ", relerr_dec, ", ", stag_rand, ", ", stag_rand * 100 / (n - 1), ", ", relerr_rand)
    end
end


## data generation

function uniform32()
    lens = [500_000, 1_000_000, 2_000_000, 4_000_000, 8_000_000, 16_000_000, 32_000_000, 64_000_000, 128_000_000, 256_000_000]
    N = maximum(lens)

    rng = Xoshiro(1)

    U = rand(rng, Float32SD, N)

    fname = "stagu32.dat"
    io = open(fname, "w+")
    sumlengths(io, rng, lens, U)
    close(io)
end

function uniform16()
    lens = [100, 200, 400, 1_000, 2_000, 4_000, 10_000, 20_000, 40_000, 100_000, 200_000, 400_000]
    N = maximum(lens)
    rng = Xoshiro(1)

    U = rand(rng, Float16SD, N)

    fname = "stagu16.dat"
    io = open(fname, "w+")
    sumlengths(io, rng, lens, U)
    close(io)
end


function uu32()
    lens = [500_000, 1_000_000, 2_000_000, 4_000_000, 8_000_000, 16_000_000, 32_000_000, 64_000_000, 128_000_000, 256_000_000]
    N = maximum(lens)

    rng = Xoshiro(1)

    U = rand(rng, Float32SD, N) .* rand(rng, Float32SD, N)

    fname = "staguu32.dat"
    io = open(fname, "w+")
    sumlengths(io, rng, lens, U)
    close(io)
end

function uu16()
    lens = [100, 200, 400, 1_000, 2_000, 4_000, 10_000, 20_000, 40_000, 100_000, 200_000, 400_000]
    N = maximum(lens)
    rng = Xoshiro(1)

    U = rand(rng, Float16SD, N) .* rand(rng, Float16SD, N)

    fname = "staguu16.dat"
    io = open(fname, "w+")
    sumlengths(io, rng, lens, U)
    close(io)
end


## run results generation

uniform32()
uniform16()

uu32()
uu16()
