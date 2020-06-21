import Base: size, getindex, *, length

println("""
    1. A one-hot vector can be described by its length and the index of
    its hot bit.
""")

println("""
    2. A one-hot vector composite type is defined with the above two
    fields and an inner constructor method that throws an error when the
    arguments are in the wrong order.
""")

struct OneHot <: AbstractVector{Bool}
    index::Unsigned
    length::Unsigned
    function OneHot(index, length)
        if index > length
            error("index should be smaller than length")
        end
        new(index, length)
    end
end

println("""
    The size() and getindex() methods are defined to allow displaying
    the OneHot type.
""")

size(v::OneHot) = (v.length,)
getindex(v::OneHot, i::Integer) = i == v.index
getindex(v::OneHot, ::Colon) = OneHot(v.index, v.length)

display(OneHot(6, 9))

println("""
    3. Add a length() and a method for multiplying a matrix with a one-
    hot vector to make the innersum() function work.
""")

*(a::AbstractMatrix, v::OneHot) = a[v.index]
length(v::OneHot) = Int(v.length)

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
vs = [OneHot(rand(1:3), 3) for _ = 1:10]

display(innersum(A, vs))
