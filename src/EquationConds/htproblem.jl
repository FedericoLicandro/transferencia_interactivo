using Gridap

include("boundary.jl")
include("../Geometry/geo.jl")
using Interactive_HT.Materials


struct HTproblem{G<:AbstractHTGeometry, S<:AbstractSolid,B<:AbstractBCGroup}
    geo::G
    mat::S
    BC ::B
    f  ::Function
end

function _get_data(HTp::HTproblem)
    k=HTp.mat.k
    L=HTp.geo.length    
    h=HTp.geo.height
    source = HTp.f
    f(x) = source(x)/k
    data = [k,L,h,f]
    return data
end

function _get_boundaries(HTp::HTproblem)
    BC=HTp.BC
    north = BC.north; east  = BC.east; south = BC.south; west  = BC.west
    return [south,north,west,east]
end


function _triangulate_domain(model::CartesianDiscreteModel,order::Int64,degree::Int64,dt::Vector{String},df::Vector{Any}) 
    reffe = ReferenceFE(lagrangian,Float64,order)
    Vₕ = TestFESpace(model,reffe,conformity=:H1,dirichlet_tags=dt)
    Ug = TrialFESpace(Vₕ,df)
    Ω  = Triangulation(model)
    dΩ = Measure(Ω,degree)
    return [Ω, dΩ, Vₕ, Ug]
end