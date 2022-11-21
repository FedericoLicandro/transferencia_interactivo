export _heateqsolve_stationary


function _heateqsolve_stationary(HTp::HTproblem{Cylider2D, Metal, CylBC}; n=100, order=1, degree=2)

    println("Entered the right function")
    k, L, r, f = _get_data(HTp)
    model = create_cylinder(r,L,n=n)
    
    BCvec = HTp.BC.conds
    nt = String[]; dt = String[] ; nf = [];  df = []
    for i in eachindex(BCvec)
        name = BCvec[i].label
        local aux = BCvec[i].g
        if _is_newmman(BCvec[i])
            g(x) = aux(x)/k
            push!(nf,g)
            push!(nt,name)
        else
            push!(df,aux)
            push!(dt,name)
            cero(x) = 0
            push!(nf, cero)
            push!(nt, name)
        end
    end

    Ω, dΩ, Vₕ, Ug = _triangulate_domain(model, order, degree, dt, df)
    dΓ = _newmann_boundary(Ω, model, degree, nt)


    a(u, v) = ∫(∇(v) ⋅ ∇(u)) * dΩ
    b(v) = ∫(v * f) * dΩ + ∫(v * nf[1]) * dΓ[1] + ∫(v * nf[1]) * dΓ[3] + ∫(v * nf[2]) * dΓ[2] + ∫(v * nf[3]) * dΓ[3]
    op = AffineFEOperator(a, b, Ug, Vₕ)
    ls = LUSolver()
    solver = LinearFESolver(ls)


    uₕ = solve(solver, op)
    uh = uₕ
    return [Ω, uₕ]

end