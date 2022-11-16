using Gridap
using WriteVTK

include("../EquationConds/htproblem.jl")
include("../EquationConds/boundary.jl")


function _get_data(HTp::HTproblem)
    k=HTp.mat.k
    L=HTp.geo.length    
    h=HTp.geo.height
    data = [k,L,h]
    return data
end


function _heateqsolve_stationary(HTp::HTproblem;n=100,order=1, degree = 2)
    data = _get_data(HTp); k = data[1], L = data[2], h=data[3]
    domain = (0,L,0,h)
    model = CartesianDiscreteModel(domain, (n,n))
    labels = get_face_labeling(model)
    BC = HTp.BC
    north = BC.north; east  = BC.east; south = BC.south; west  = BC.west
    auxn = north.g ;  auxs = south.g ;  auxw = west.g ;  auxe = east.g
    gₙ(x) = auxn(x)/k; gₛ(x) = auxs(x)/k; gₒ(x) = auxw(x)/k; gₑ(x) = auxe(x)/k;
    BCvec = [south,north,west,east]
    i=1
    dt = String[]
    df = []
    nt = []
    nf = []
    defnf(x)=0
    for bc in BCvec
        add_tag_from_tags!(labels,bc.label,[i+4,])
        i+=1
        if typeof(bc) == BCond{Dirichlet}
            push!(dt,bc.label)
            push!(df,bc.g)
            push!(nt,"empty")
            push!(nf,defnf)
        else
            push!(nt,bc.label)
            push!(nf,bc.g)
        end
        #    push!(nf,bc.g)
    end
    reffe = ReferenceFE(lagrangian,Float64,order)
    Vₕ = TestFESpace(model,reffe,conformity=:H1,dirichlet_tags=dt)
    Ug = TrialFESpace(Vₕ,df)
    Ω  = Triangulation(model)
    dΩ = Measure(Ω,degree)
    Γ  = []
    dΓ = []
    for i in eachindex(nt)
        if nt[i] == "empty"
            dγ = Measure(Ω,degree)
        else
            γ  = BoundaryTriangulation(model,tags=nt[i])
            dγ = Measure(γ,degree)
            push!(Γ,γ)
        end
        push!(dΓ,dγ)
    end

    source = HTp.f
    f(x)=source(x)/k
    a(u,v) = ∫( ∇(v)⋅∇(u) )*dΩ 
    b(v) = ∫( v*f )*dΩ + ∫(v*nf[1])*dΓ[1]+∫(v*nf[1])*dΓ[3]+∫(v*nf[2])*dΓ[2]+∫(v*nf[3])*dΓ[3]+∫(v*nf[4])*dΓ[4]
    op = AffineFEOperator(a,b,Ug,Vₕ)
    ls = LUSolver()
    solver = LinearFESolver(ls)
    uₕ = solve(solver,op)
    return [Ω , uₕ]
end




# toy problem

Cu = Metal("Cu",300)
D = RectangularDomain(1,1)
source(x) = 1000
gₙ(x) = 0
gₒ(x) = 1-x[2]
gₛ(x) = 0
gₑ(x) = 0

bcN = BCond(gₙ,"north",Dirichlet())
bcS = BCond(gₛ,"south",Newmann())
bcW = BCond(gₒ,"west",Dirichlet())
bcE = BCond(gₑ,"east",Newmann())

bcA = RectBC(bcN,bcE,bcS,bcW)

toyproblem = HTproblem(D,Cu,bcA,source)

uₕ = _heateqsolve_stationary(toyproblem)

Ω  = uₕ[1]
uh = uₕ[2]

writevtk(Ω,"results",cellfields=["uh"=>uh])




#=



n=100
domain = (0,1,0,2)
partition = (n,n)

    model = CartesianDiscreteModel(domain,partition)
    label = get_face_labeling(model)
    add_tag_from_tags!(label,"prueba",[3,4,6])
    add_tag_from_tags!(label,"prueba2",[5,1,7])
    add_tag_from_tags!(label,"prueba3",[2,8])

order = 1
reffe = ReferenceFE(lagrangian,Float64,order)
Vₕ = TestFESpace(model,reffe,conformity=:H1,dirichlet_tags=["prueba","prueba2","prueba3"])

g1(x)=2*x[1]
g2(x)=0
g3(x)=x[2]

Ug = TrialFESpace(Vₕ,[g1,g2,g3])

degree = 2
Ω = Triangulation(model)
dΩ = Measure(Ω,degree)

f(x) = 0
a(u,v) = ∫( ∇(v)⋅∇(u) )*dΩ
b(v) = ∫(v*f)*dΩ
op = AffineFEOperator(a,b,Ug,Vₕ)
ls = LUSolver()
solver = LinearFESolver(ls)
uₕ = solve(solver,op)


=#