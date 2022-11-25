module HeatEq

using ..Materials
using Gridap, GridapGmsh, Gridap.Io, WriteVTK, Gmsh

export _heateqsolve_stationary
export AbstractBCond, AbstractBCGroup, Dirichlet, Newmann
export BCond, RectBC, CylBC
export _is_newmman, _get_functions_from_boundaries, _add_tags_from_bc!, classify_functions, _newmann_boundary
export HTproblem
export _get_data, _get_boundaries, _triangulate_domain
export AbstractHTGeometry, RectangularDomain, Cylider2D
export create_cylinder

include("../Geometry/geo.jl")
include("../Geometry/cylinder.jl")
include("../EquationConds/boundary.jl")
include("../EquationConds/htproblem.jl")
include("stationarycyl.jl")
include("stationaryrect.jl")
    
end