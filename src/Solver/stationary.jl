using Gridap
using WriteVTK

n = 100
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

writevtk(Ω,"results",cellfields=["uₕ"=>uₕ])
