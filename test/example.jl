
using Interactive_HT, Gridap


# toy problem


Cu = Metal("Cu", 300)
D = RectangularDomain(1, 1)
source(x) = 0
g1(x) = 0
g2(x) = 1 - x[2]
g3(x) = 0
g4(x) = 1 - x[1]

bcN = BCond(g1, "north", Dirichlet())
bcS = BCond(g4, "south", Dirichlet())
bcW = BCond(g2, "west", Dirichlet())
bcE = BCond(g3, "east", Dirichlet())

bcA = RectBC(bcN, bcE, bcS, bcW)
toyproblem = HTproblem(D, Cu, bcA, source)

uₕ = _heateqsolve_stationary(toyproblem)

Ω  = uₕ[1]
uh = uₕ[2]

writevtk(Ω, "results", cellfields=["uh" => uh])
