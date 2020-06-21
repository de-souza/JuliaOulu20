println("""
    Create a function that takes any real matrix as an input and returns
    the element type of the matrix:
""")

realmatrixeltype(x::Matrix{<:Real}) = eltype(x)
display(realmatrixeltype)

println("""
    Matrix m filled with random integers from 0 to 9:
""")

m = rand(0:9, 3, 3)
display(m)

println("""
    Element type of m:
""")

display(realmatrixeltype(m))
