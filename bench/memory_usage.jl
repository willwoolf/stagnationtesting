# memory usage of scalars, vectors and matrices.

using StagnationDetection


## define functions

function return_scalar(::Type{T}) where {T <: AbstractFloat}
    return rand(T)
end

function return_vector(::Type{T}, n::Integer) where {T <: AbstractFloat}
    return rand(T, n)
end

function return_matrix(::Type{T}, m::Integer, n::Integer) where {T <: AbstractFloat}
    return rand(T, m, n)
end


## memory usage for each

println("Scalars")
@btime return_scalar(Float64)
@btime return_scalar(Float64SD)

println("Vectors")
@btime return_vector(Float64, 100)
@btime return_vector(Float64, 200)
@btime return_vector(Float64, 400)
@btime return_vector(Float64, 1_000_000)
@btime return_vector(Float64SD, 100)
@btime return_vector(Float64SD, 200)
@btime return_vector(Float64SD, 400)
@btime return_vector(Float64SD, 1_000_000)

println("Matrices")
@btime return_matrix(Float64, 100, 100)
@btime return_matrix(Float64, 200, 100)
@btime return_matrix(Float64, 400, 100)
@btime return_matrix(Float64, 1000, 1000)
@btime return_matrix(Float64SD, 100, 100)
@btime return_matrix(Float64SD, 200, 100)
@btime return_matrix(Float64SD, 400, 100)
@btime return_matrix(Float64SD, 1000, 1000)

