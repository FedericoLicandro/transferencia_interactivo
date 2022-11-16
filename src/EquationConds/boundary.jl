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
struct BCond{T<:AbstractBCond} 
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