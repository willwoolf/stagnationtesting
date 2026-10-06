using StagnationDetection

function harm(n::Int, T::Type = Float64)
    acc::T = 0
    for k in 1:n
        acc += one(T)/k
    end
    return acc
end

h = harm(4_000_000, Float32SD)

report(h)