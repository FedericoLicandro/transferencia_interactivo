

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
export Wall, Cylinder, Ilpipearray, Qupipearray, CircularPipe, Duct, ForcedConv
export char_length, pipe_length, inclination, cylinder_angle, array_NL ,array_SL, array_St, quaxy_sd, curvradius, char_speed, _is_internal_flow, _is_vertical, _is_horizontal
export δCLh, δCLt, capalimt, capalimh, convpunt


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
h_conv(v::Real,x::Real,flu::AbstractFluid,Ts::Real)
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
function h_conv(v::Real,x::Real,flu::AbstractFluid,Ts::Real)
    T = fluidtemp(flu)
    Tf = (T+Ts)/2
    name = _get_fluid_name(flu)
    fluf = Fluid(name,Tf)
    ν = viscocidad(fluf) ; pr = prandlt(fluf) ; k = conductividad(fluf)
    re = x*v/ν
    if re ≤ 500000
        nu = 0.332*re^0.5*pr^0.33
    elseif re < 10e8
        nu = 0.0296*re^0.8*pr^0.33
    end
    h = nu*k/x
    return h
end



"""
Type containig forced convection information.

### Fields
    
- `flu`: fluid.
- `sup`: surface.
- `Temp`: fluid temperature away form the surface[K].
- `Tempₛ`: surface temperature [K].
- `v`: fluid velocity [m/s].
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
julia> Tₛ = 320
julia> conv = ForcedConv(flow,Tₛ)
El coeficiente de convección forzada entre Aire que circula a v=8m/s y T=300K
y una superficie del tipo Cilindro de longitud característica Lc=0.08m, que se encuentra a una temperatura Tₛ=320K
es h=43.39403643940914W/m²K
============================
   Números adimencionales
============================
Número de Reynolds Re=40276.90371302705
Número de Grashoff Gr=1.324820327711904e6
Número de Nusselt Nu=131.99706901721413

=       h=43.39403643940914W/m²K       =
```
"""
struct ForcedConv
    flu::AbstractFluid
    sup::AbstractSurface
    Temp::Real
    Tempₛ::Real
    v::Real
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
    return ForcedConv(flu,sup,T,Tₛ,v,Re,Gr,Nu,h)
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
    return ForcedConv(flu,sup,T,Tₛ,v,re,Gr,Nu,h)
end

function Base.show(io::IO,fconv::ForcedConv)
    flu = fluid(fconv)
    sup = surface(fconv)
    fluname = _fluid_name(flu)
    v = speed(fconv)
    Tf = fconv.Temp
    Lc = char_length(sup)
    Ts = fconv.Tempₛ
    h=h_conv(fconv)
    Re = reynolds(fconv)
    Nu = nusselt(fconv)
    Gr = grashoff(fconv)
    println(io,"El coeficiente de convección forzada entre ",fluname," que circula a v=$v","m/s y T=$Tf","K")
    println(io,"y una superficie del tipo ",_surfacename(sup)," de longitud característica Lc=$Lc","m, que se encuentra a una temperatura Tₛ=$Ts","K")
    println(io,"es h=$h","W/m²K")
    println(io,"============================")
    println(io,"   Números adimencionales   ")
    println(io,"============================")
    println(io,"Número de Reynolds Re=$Re")
    println(io,"Número de Grashoff Gr=$Gr")
    println(io,"Número de Nusselt Nu=$Nu")
    println(io,"")
    println(io,"=       h=$h","W/m²K       =")
    println(io,"")
end

fluid(x::ForcedConv)=x.flu
surface(x::ForcedConv) = x.sup
speed(x::ForcedConv) = x.v
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

function convpunt(flu∞::AbstractFluid,L::Real,v::Real,Tₛ::Real;n=200)
    dx = L/n
    X = 0:dx:L
    hc = []
    for i in 1:n+1
        x = X[i]
        h = h_conv(v,x,flu∞,Tₛ)
        push!(hc,h)
    end
    return hc
end


end