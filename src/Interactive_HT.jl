module Interactive_HT

using Gridap,
    Reexport,
    WriteVTK,
    Gmsh,
    GridapGmsh,
    Gridap.Io

import Gmsh:gmsh


include("Materials/Materials.jl")
@reexport using ..Materials


include("Convection/Convection.jl")
@reexport using ..Convection

include("Solver/HeatEq.jl")
@reexport using ..HeatEq


end # module Interactive_HT
