using Gridap

"Abstract type containing all Boundary condition types available"
abstract type AbstractBCond end
abstract type AbstractBCGroup end



struct Dirichlet <:AbstractBCond end
struct Newmann <:AbstractBCond end


"
Boundary condition type.

### fields


- `g`: boundary function (for the solution or the gradient of the solution depending on the `type(T)`, `T ∈ {Newmann,Dirichlet} ` of BC).

- `label`: Identifier for the boundary condition.

- `type`: Type of the Boundary condition, `Newmann()` for gradient condition, `Dirichlet()` for imposed value condition.


"
struct BCond{T<:AbstractBCond} <:AbstractBCond
    g::Function
    label::String
    type::T
end



"
Boundary conditions for a Recatangular domain

### fields

- `north`: Boundary condition for the northen face.

- `east`: Boundary condition for the eastern face.

- `south`: Boundary condition for the souhern face.

- `west`: Boundary condition for the western face.


"
struct RectBC  <:AbstractBCGroup
    north::BCond
    east ::BCond
    south::BCond
    west ::BCond 
end

f(x)=x
bc = BCond(f,"name",Dirichlet())


_is_newmman(BC::BCond) = BC.type == Newmann()

function _get_functions_from_boundaries(BCvec::Vector{T},k::Real) where T<:Union{AbstractBCond,BCond,BCond{Newmann},BCond{Dirichlet}}
    south,north,west,east = BCvec
    auxn = north.g; auxs = south.g; auxw = west.g; auxe = east.g
        gₙ(x) = _is_newmman(north) ? -auxn(x)/k : auxn(x) 
        gₛ(x) = _is_newmman(south) ? -auxs(x)/k : auxs(x) 
        gₒ(x) = _is_newmman(west) ? -auxw(x)/k : auxw(x)
        gₑ(x) = _is_newmman(east) ? -auxe(x)/k : auxe(x)
    return [gₛ,gₙ,gₒ,gₑ]
end


function _add_tags_from_bc!(labels::Gridap.Geometry.FaceLabeling,BC::Vector{T}) where T<:Union{AbstractBCond,BCond,BCond{Newmann},BCond{Dirichlet}}
    i=1
    for bc in BC
        add_tag_from_tags!(labels,bc.label,[i+4,])
        i+=1
    end
end


function _classify_functions(fvec::Vector{Function},BC::Vector{T}) where T<:Union{AbstractBCond,BCond,BCond{Newmann},BCond{Dirichlet}}
    
    df = Function[]; nf = []
    defnf(x)=0
    
    for i in 1:4
        if typeof(BC[i]) == BCond{Dirichlet}
            push!(df,fvec[i])
            push!(nf,defnf)
        else
            push!(nf,fvec[i])
        end
    end
    
    return [df,nf]
    
end


function _build_tags(BC::Vector{T}) where T<:Union{AbstractBCond,BCond,BCond{Newmann},BCond{Dirichlet}}
    dt = String[]; nt = String[]
    for bc in BC
        if typeof(bc) == BCond{Dirichlet}
            push!(dt,bc.label)
            push!(nt,"empty")
        else
            push!(nt,bc.label)
        end
    end

    return [dt,nt]

end

function _newmann_boundary(Ω::Triangulation, model::CartesianDiscreteModel, degree::Int64, nt::Vector{String})
    dΓ = []
    for i in eachindex(nt)
        if nt[i] == "empty"
            dγ = Measure(Ω,degree)
        else
            γ  = BoundaryTriangulation(model,tags=nt[i])
            dγ = Measure(γ,degree)
        end
        push!(dΓ,dγ)
   end

   return dΓ

end