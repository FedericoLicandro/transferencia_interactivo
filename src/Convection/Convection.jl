

module Convection

using ..Materials

include("../Geometry/convsurfaces.jl")
include("flow.jl")


export Forced, Natural
export _calculate_h, _interface_fluid, h_conv
export iterateh
export ForcedConv
export intervec, intermat
export reynolds, grashoff, nusselt, arquimedes
export surface, regime, nusselt, reynolds, grashoff
export AbstractSurface, AbstractPipeArray, AbstractPipe
export Wall, Cylinder, Il_pipe_array, Qu_pipe_array, CircularPipe, Duct, ForcedConv
export char_length, pipe_length, inclination, cylinder_angle, array_NL ,array_SL, array_St, quaxy_sd, curvradius, char_speed



struct Forced end
struct Natural end



"""
    _calculate_h(Nu::Real, L::Real, k::Real)

Calculates the convection coefficient from three real numbers (Nusselt, characteristic length and conductivity).
"""
_calculate_h(Nu::Real, L::Real, k::Real) = Nu * k / L


"""
    _interface_fluid(flu::AbstractFluid, Tₛ::Real)

Generates the fluid from which properties are taken to calculete adimentional numbers and convection coefficient.

### Methods
```
_interface_fluid(flu::Liquid,T::Real,Tₛ::Real)
_interface_fluid(flu::Liquid,Tₛ::Real)
_interface_fluid(flu::Gas,T::Real,Tₛ::Real)
_interface_fluid(flu::Gas,Tₛ::Real)
```
"""
function _interface_fluid(flu::Liquid, T::Real, Tₛ::Real)

    name = flu.name
    codenames = keys(Tₗᵤ)

    if name ∈ codenames
        Tf = (T + Tₛ) / 2
        flus = Liquid(name, Tf)
    else
        flus = flu
    end

    return flus

end
function _interface_fluid(flu::Liquid, Tₛ::Real)

    name = flu.name
    codenames = keys(Tₗᵤ)

    if name ∈ codenames
        Tf = Tₛ
        flus = Liquid(name, Tf)
    else
        flus = flu
    end

    return flus
end
function _interface_fluid(flu::Gas, T::Real, Tₛ::Real)

    name = flu.name
    codenames = keys(Tₗᵤ)

    if name ∈ codenames
        Tf = (T + Tₛ) / 2
        flus = Gas(name, Tf)
    else
        flus = flu
    end

    return flus

end
function _interface_fluid(flu::Gas, Tₛ::Real)

    flus = flu
    return flus
end

"""
    h_conv(flow,Tₛ)

Calculates the convection coefficient from flow properties and surface temperature

### Methods
```
h_conv(v::Real,sup::AbstractSurface, flu::AbstractFluid,Tₛ::Real)
h_conv(v::Real,sup::Wall,flu::AbstractFluid,Tₛ::Real)
h_conv(flow::Flow,Tₛ::Real)
h_conv(x::ForcedConv)
```

# Examples
```julia-repl
julia> geo = Cylinder(0.08)
julia> flu = Gas("air",300)
julia> v = 8
julia> flow = Flow(flu,v,geo)
julia> Tₛ = 320
julia> h_conv(flow,Tₛ)
43.351008090576194
```
"""
function h_conv(v::Real, sup::Wall, flu::AbstractFluid, Tₛ::Real)

    T = fluidtemp(flu)
    fluf = _interface_fluid(flu, T, Tₛ)
    k  = conductividad(fluf)
    L  = char_length(sup)
    Nu = nusselt(sup, v, fluf)
    h  = _calculate_h(Nu, L, k)

    return h

end
function h_conv(v::Real, sup::AbstractSurface, flu::AbstractFluid, Tₛ::Real)

    L  = char_length(sup)
    flus = _interface_fluid(flu, Tₛ)
    k  = conductividad(flu)
    Nu = nusselt(sup, v, flu, flus)
    h  = _calculate_h(Nu::Real, L::Real, k::Real)

    return h

end
function h_conv(flow::Flow, Tₛ::Real)

    flu = flowflu(flow) ; sup = flowgeo(flow) ; v = flowspd(flow)
    T = fluidtemp(flu)
    flus = _interface_fluid(flu, Tₛ)
    fluf = _interface_fluid(flu, T, Tₛ)
    k  = typeof(sup) == Wall ? conductividad(fluf) : conductividad(flu)
    L  = char_length(sup)
    Nu = typeof(sup) == Wall ? nusselt(sup, v, fluf) : nusselt(sup, v, flu, flus)
    h  = _calculate_h(Nu, L, k)

    return h

end



"""
Type containig forced convection information.

### Fields
    
- `flu`: fluid.
- `sup`: surface.
- `Temp`: fluid temperature away form the surface.
- `Tempₛ`: surface temperature.
- `reynolds`: Reynolds number.
- `grashoff`: Grashoff number.
- `nusselt`: Nusselt number.
- `convcoef`: Convection Coefficent `h` [W/m²K].         

### Constructors

```julia-repl
ForcedConv(sup::AbstractSurface,T::Real,Tₛ::Real,v::Real,fluname::String)
ForcedConv(flow::Flow,Tₛ::Real)
```

# Example

```julia-repl
julia> geo = Cylinder(0.08)
julia> flu = Gas("air",300)
julia> v = 8
julia> flow = Flow(flu,v,geo)
julia> conv = ForcedConv(flow,Tₛ)
ForcedConv(Gas(0.0263, 1.5890000000000005e-5, 0.707, 0.0033333333333333335, "air", 300),
Cylinder(0.08, 90), 300, 320, 40276.90371302705, 1.324820327711904e6,
131.99706901721413, 43.39403643940914)
```
"""
struct ForcedConv
    flu::AbstractFluid
    sup::AbstractSurface
    Temp::Real
    Tempₛ::Real
    reynolds::Real
    grashoff::Real
    nusselt::Real
    convcoef::Real
end
function ForcedConv(sup::AbstractSurface,T::Real,Tₛ::Real,v::Real,fluname::String)
    flu₁ = Fluid(fluname,T) ; fluₛ = Fluid(fluname,Tₛ)
    flu = typeof(sup) == Wall ? _interface_fluid(flu₁,T,Tₛ) : flu₁
    Re = reynolds(sup,v,flu)
    Gr = grashoff(flu,Tₛ,sup)
    Nu = typeof(sup) == Wall ? nusselt(sup, v, flu) : nusselt(sup,v,flu,fluₛ)
    k = conductividad(flu)
    L = char_length(sup)
    h = Nu*k/L
    return ForcedConv(flu,sup,T,Tₛ,Re,Gr,Nu,h)
end
function ForcedConv(flow::Flow,Tₛ::Real)
    flu₁ = flowflu(flow)
    name = _get_fluid_name(flu₁)
    T = fluidtemp(flu₁)
    fluₛ = Fluid(name,Tₛ)
    sup = flowgeo(flow) ; v = flowspd(flow)
    flu =  typeof(sup) == Wall ?  _interface_fluid(flu₁,T,Tₛ) : flu₁      
    re = reynolds(sup,v,flu)
    Nu = typeof(sup) == Wall ? nusselt(sup,v,flu) : nusselt(sup,v,flu,fluₛ)
    k = conductividad(flu)
    Gr = grashoff(flu,Tₛ,sup)
    L = char_length(sup)
    h = _calculate_h(Nu,L,k)
    return ForcedConv(flu,sup,T,Tₛ,re,Gr,Nu,h)
end

fluid(x::ForcedConv)=x.flu
surface(x::ForcedConv) = x.sup
reynolds(x::ForcedConv) = x.reynolds
nusselt(x::ForcedConv) = x.nusselt
grashoff(x::ForcedConv) = x.grashoff
h_conv(x::ForcedConv) = x.convcoef
"""
    arquimedes(x::ForcedConv)

Calculetes the Arquimedes number `Ar` when given a `ForcedConv` type of object.

# Example

```julia-repl
julia> geo = Cylinder(0.08)
julia> flu = Gas("air",300)
julia> v = 8
julia> flow = Flow(flu,v,geo)
julia> conv = ForcedConv(flow,Tₛ)
julia> arquimedes(conv)
0.0008166666666666675
```
"""
function arquimedes(x::ForcedConv)
    re = reynolds(x)
    gr = grashoff(x)
    ar = gr/re^2
    return ar  
end
function regime(x::ForcedConv)
    sup = surface(x)
    reg = regime(sup)
    return reg
end


"""
    iterateh(flow₁::Flow,flow₂::Flow)

Calculates the convection coefficients and surface temperature from properties of two different flows

Results are presented in a vector where the first two entries are the convection coefficients for between each flow and the surface, and the last entrie is the surface temperature.

Optionaly, tollerance can be defined by the user with the argument tol=ϵ.

### Methods

```
iterateh(sup::AbstractSurface,flu₁::AbstractFluid,flu₂::AbstractFluid,v₁::Real,v₂::Real)
iterateh(sup::AbstractSurface,flu₁::AbstractFluid,flu₂::AbstractFluid,v₁::Real,v₂::Real;tol=0.01)
iterateh(flow₁::Flow,flow₂::Flow)
iterateh(flow₁::Flow,flow₂::Flow;tol=0.01)
```
# Example

```julia-repl
julia> geo₁ = Cylinder(0.08)
julia> flu₁ = Gas("air",300)
julia> v₁ = 8
julia> flow₁ = Flow(flu₁,v₁,geo₁)
julia> flu₂ = Gas("air",350)
julia> flow₂ = Flow(flu₂,v₂,geo₂)
julia> iterateh(flow₁,flow₂)
3-element Vector{Float64}:
  43.351008090576194
  41.54044645708764
 324.4668009745103
```
"""
function iterateh(sup::AbstractSurface,flu₁::AbstractFluid,flu₂::AbstractFluid,v₁::Real,v₂::Real;tol=0.01)
    T₁ = fluidtemp(flu₁) ; T₂ = fluidtemp(flu₂)
    Tₛ = (T₁ + T₂)/2 
    ϵ = 1 ; h₁ = 0 ; h₂ = 0
    while ϵ ≥ tol
        h₁ = h_conv(v₁,sup,flu₁,Tₛ)
        h₂ = h_conv(v₂,sup,flu₂,Tₛ)
        Tₛᵃ = Tₛ
        Tₛ = (h₁*T₁+h₂*T₂)/(h₂+h₁)
        ϵ = abs(Tₛ-Tₛᵃ)
    end
    return [h₁,h₂,Tₛ]    
end
function iterateh(flow₁::Flow,flow₂::Flow;tol=0.01)
    flu₁ = flowflu(flow₁) ; flu₂ = flowflu(flow₂)
    T₁ = fluidtemp(flu₁) ; T₂ = fluidtemp(flu₂)
    Tₛ = (T₁ + T₂)/2 
    ϵ = 1 ; h₁ = 0 ; h₂ = 0
    while ϵ ≥ tol
        h₁ = h_conv(flow₁,Tₛ)
        h₂ = h_conv(flow₂,Tₛ)
        Tₛᵃ = Tₛ
        Tₛ = (h₁*T₁+h₂*T₂)/(h₂+h₁)
        ϵ = abs(Tₛ-Tₛᵃ)
    end
    return [h₁,h₂,Tₛ]    
end


end