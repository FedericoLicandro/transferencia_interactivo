module Interactive_HT

using Gridap,
    Reexport,
    WriteVTK,
    Gmsh,
    GridapGmsh,
    Gridap.Io

import Gmsh:gmsh

include("Geometry/geo.jl")
include("Geometry/cylinder.jl")
include("Materials/Materials.jl")
@reexport using ..Materials

include("EquationConds/boundary.jl")
include("EquationConds/htproblem.jl")
include("Geometry/convsurfaces.jl")
include("Convection/Flow.jl")
include("Convection/Convection.jl")

include("Solver/stationarycyl.jl")
include("Solver//stationaryrect.jl")

end # module Interactive_HT
