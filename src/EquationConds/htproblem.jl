export HTproblem
export _get_data, _get_boundaries, _triangulate_domain

"""
Defined Heat transfer problem.

### Fields

- `geo`: Geometry in which the Heat Transfer problem is solved
- `mat`: Material occupying the domain
- `BC`: Group of boundary conditions
- `f`: source term of the equation (-`kΔT`= `f`)
"""
struct HTproblem{G<:AbstractHTGeometry,S<:AbstractSolid,B<:AbstractBCGroup}
    geo::G
    mat::S
    BC::B
    f::Function
end

"""
Returns fields of a Heat Transfer problem `k` (conductivity) , `L` (length) , `h` (height) , `f` (source term)

returns `[k,L,h,f]`
"""
function _get_data(HTp::HTproblem{RectangularDomain, Metal, RectBC})
    k = HTp.mat.k
    L = HTp.geo.length
    h = HTp.geo.height
    source = HTp.f
    f(x) = source(x) / k
    data = [k, L, h, f]
    return data
end

function _get_data(HTp::HTproblem{Cylider2D, Metal, CylBC})
    k = HTp.mat.k
    L = HTp.geo.length
    r = HTp.geo.radius
    source = HTp.f
    f(x) = source(x) / k
    data = [k, L, r, f]
    return data
end


"""
Returns the boundary conditions of a heat transfer problem.

returns `[south,north,west,east]`

"""
function _get_boundaries(HTp::HTproblem)
    BC = HTp.BC
    north = BC.north
    east = BC.east
    south = BC.south
    west = BC.west
    return [south, north, west, east]
end


"""

Returns the triangulation `Ω` and its measure `dΩ`, test space for the finite element method `Vₕ`, and Trial space `Ug`  of a discretemodel 

returns `[Ω, dΩ, Vₕ, Ug]`

"""
function _triangulate_domain(model::DiscreteModel, order::Int64, degree::Int64, dt::Vector{String}, df::Vector{Any})
    reffe = ReferenceFE(lagrangian, Float64, order)
    Vₕ = TestFESpace(model, reffe, conformity=:H1, dirichlet_tags=dt)
    Ug = TrialFESpace(Vₕ, df)
    Ω = Triangulation(model)
    dΩ = Measure(Ω, degree)
    return [Ω, dΩ, Vₕ, Ug]
end
