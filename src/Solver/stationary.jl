using Gridap
using WriteVTK

include("../EquationConds/htproblem.jl")
include("../EquationConds/boundary.jl")

"Solves the stationary (∂T/∂t = 0) heat equation for a rectangular domain, using FE on a triangulated homogeneous cartesian grid.

### entries

- `HTp`: Heat transfer problem, with a geometry, material, boundary condition and source term f.

- `n`: number of divisons on each direction.

- `order`: Finite Element order (indication of how many points per triangle evaluated on the FE method).

- `degree`: Degree with which triangulation measures are calculated.

returns in entry 1 the triangulation `Ω`, and in entry 2, the solution `uₕ`.

"
function _heateqsolve_stationary(HTp::HTproblem;n=100,order=1, degree = 2)
   
    k,L,h,f   = _get_data(HTp)   ;   domain = (0,L,0,h);
    model     = CartesianDiscreteModel(domain, (n,n))
    labels    = get_face_labeling(model)
    BCvec     = _get_boundaries(HTp)
    gvec      = _get_functions_from_boundaries(BCvec,k)
    
                _add_tags_from_bc!(labels,BCvec)

    dt, nt    = _build_tags(BCvec)
    df, nf    = _classify_functions(gvec,BCvec)
    Ω,dΩ,Vₕ,Ug = _triangulate_domain(model,order,degree,dt,df)
    dΓ        = _newmann_boundary(Ω, model, degree,nt)

    
    a(u,v) = ∫( ∇(v)⋅∇(u) )*dΩ 
    b(v)   = ∫( v*f )*dΩ + ∫(v*nf[1])*dΓ[1]+∫(v*nf[1])*dΓ[3]+∫(v*nf[2])*dΓ[2]+∫(v*nf[3])*dΓ[3]+∫(v*nf[4])*dΓ[4]
    op     = AffineFEOperator(a,b,Ug,Vₕ)
    ls     = LUSolver()
    solver = LinearFESolver(ls)

        uₕ = solve(solver,op)
    
    return [Ω , uₕ]

end

# toy problem
Cu = Metal("Cu",300)
D = RectangularDomain(1,1)
source(x) = 0
g1(x) = 0
g2(x) = 1-x[2]
g3(x) = 0
g4(x) = 1-x[1]

bcN = BCond(g1,"north",Dirichlet())
bcS = BCond(g4,"south",Dirichlet())
bcW = BCond(g2,"west",Dirichlet())
bcE = BCond(g3,"east",Dirichlet())

bcA = RectBC(bcN,bcE,bcS,bcW)
toyproblem = HTproblem(D,Cu,bcA,source)

uₕ = _heateqsolve_stationary(toyproblem)

Ω  = uₕ[1]
uh = uₕ[2]

writevtk(Ω,"results",cellfields=["uh"=>uh])




