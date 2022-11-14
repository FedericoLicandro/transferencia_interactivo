include("boundary.jl")
include("../Geometry/geo.jl")
using Interctive_HT.Materials


struct HTproblem{G<:AbstractHTGeometry, S<:AbstractSolid,B::AbstractBCGroup}
    geo::G
    mat::S
    BC ::B
    f  ::Function
end