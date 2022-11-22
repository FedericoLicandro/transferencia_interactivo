using Interactive_HT, Gridap
# toy problem

    r  = 0.0095
    L  = 0.25
    A  = pi*r^2
    Cu = Metal("Cu", 300)
    D  = Cylider2D(r, L)
        
        source(x) = 0
        g1(x) = 0
        g2(x) = 0
        g3(x) = 24/A

            bcC1  = BCond(g1, "circulo", Dirichlet())
            bclat = BCond(g2, "cilindro", Newmann())
            bcC2  = BCond(g3, "circulo2", Newmann())

                bcA = CylBC([bcC1, bclat, bcC2])
                    
                    toyproblem = HTproblem(D, Cu, bcA, source)

        uₕ = _heateqsolve_stationary(toyproblem)

    Ω  = uₕ[1]
    uh = uₕ[2]

writevtk(Ω, "results", cellfields=["uh" => uh])
