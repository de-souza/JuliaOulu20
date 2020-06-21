using BenchmarkTools
import Base: *, length, size, getindex

println("""
    1. A one-hot vector can be described by its length and the index of
    its hot bit.
""")

println("""
    2. A one-hot vector composite type is defined with the above two
    fields and an inner constructor method that throws an error when the
    arguments are in the wrong order.
""")

struct OneHot
    index::UInt
    length::UInt
    function OneHot(index, length)
        if index > length
            error("index should be smaller than length")
        end
        new(index, length)
    end
end

println("OneHot(6, 9) = $(OneHot(6, 9))\n")

println("""
    3. To make the innersum() function work, a length() and a getindex()
    methods are added along with a method for multiplying a matrix with
    a one-hot vector.
""")

*(a::AbstractMatrix, v::OneHot) = a[:, v.index]
length(v::OneHot) = v.length
getindex(v::OneHot, i::Integer) = i == v.index

function innersum(A, vs)
    t = zero(eltype(A)) # generic!
    for v in vs
        y = A * v
        for i = 1:length(vs[1])
            t += v[i] * y[i]
        end
    end
    return t
end

A = rand(3, 3)
vs = [rand(3) for _ = 1:10]
vs_onehot = [OneHot(rand(1:3), 3) for _ = 1:10]

println("innersum(A, vs) = $(innersum(A, vs))")
println("innersum(A, vs_onehot) = $(innersum(A, vs_onehot))\n")

println("""
    4. Comparison of the speed of innersum() with a OneHot and innersum()
    with a Vector{Float64}:
""")

print("@btime (innersum(A, vs)):")
@btime (innersum(A, vs))
print("@btime (innersum(A, vs_onehot)):")
@btime (innersum(A, vs_onehot))
println()

println("""
    5. A OneHotVector composite type is defined. It is identical to
    OneHot but is declared to be a subtype of AbstractVector{Bool}.
""")

struct OneHotVector <: AbstractVector{Bool}
    index::UInt
    length::UInt
    function OneHotVector(index, length)
        if index > length
            error("index should be smaller than length")
        end
        new(index, length)
    end
end

size(v::OneHotVector) = (v.length,)
getindex(v::OneHotVector, i::Integer) = i == v.index

println("OneHotVector(6, 9) = $(OneHotVector(6, 9))\n")

println("""
    6. Comparison of the speed of innersum() with a OneHot, with a
    OneHotVector and a Vector{Float64}.
""")

vs_onehotvector = [OneHotVector(rand(1:3), 3) for _ = 1:10]

print("@btime (innersum(A, vs)):")
@btime (innersum(A, vs))
print("@btime (innersum(A, vs_onehot)):")
@btime (innersum(A, vs_onehot))
print("@btime (innersum(A, vs_onehotvector)):")
@btime (innersum(A, vs_onehotvector))
