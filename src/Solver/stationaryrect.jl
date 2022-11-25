export _heateqsolve_stationary

"""
Solves the stationary (∂T/∂t = 0) heat equation for a rectangular domain, using FE on a triangulated homogeneous cartesian grid.
### entries
- `HTp`: Heat transfer problem, with a geometry, material, boundary condition and source term f.
- `n`: number of divisons on each direction.
- `order`: Finite Element order (indication of how many points per triangle evaluated on the FE method).
- `degree`: Degree with which triangulation measures are calculated.
returns in entry 1 the triangulation `Ω`, and in entry 2, the solution `uₕ`.
"""
function _heateqsolve_stationary(HTp::HTproblem{RectangularDomain, Metal, RectBC}; n=20, order=1, degree=2)

    k, L, h, f = _get_data(HTp)
    domain = (0, L, 0, h)
    model = CartesianDiscreteModel(domain, (n, n))
    labels = get_face_labeling(model)
    BCvec = _get_boundaries(HTp)
    gvec = _get_functions_from_boundaries(BCvec, k)

    _add_tags_from_bc!(labels, BCvec)

    dt, nt = _build_tags(BCvec)
    df, nf = _classify_functions(gvec, BCvec)
    Ω, dΩ, Vₕ, Ug = _triangulate_domain(model, order, degree, dt, df)
    dΓ = _newmann_boundary(Ω, model, degree, nt)


    a(u, v) = ∫(∇(v) ⋅ ∇(u)) * dΩ
    b(v) = ∫(v * f) * dΩ + ∫(v * nf[1]) * dΓ[1] + ∫(v * nf[1]) * dΓ[3] + ∫(v * nf[2]) * dΓ[2] + ∫(v * nf[3]) * dΓ[3] + ∫(v * nf[4]) * dΓ[4]
    op = AffineFEOperator(a, b, Ug, Vₕ)
    ls = LUSolver()
    solver = LinearFESolver(ls)

    uₕ = solve(solver, op)

    return [Ω, uₕ]

end



