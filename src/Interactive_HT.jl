module Interactive_HT

using Gridap,
    Reexport,
    WriteVTK

include("Geometry/geo.jl")
include("Materials/Materials.jl")
@reexport using ..Materials

include("EquationConds/boundary.jl")
include("EquationConds/htproblem.jl")
include("Geometry/convsurfaces.jl")
include("Convection/Flow.jl")
include("Convection/Convection.jl")

end # module Interactive_HT
