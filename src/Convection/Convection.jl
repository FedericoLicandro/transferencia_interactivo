

module Convection

using ..Materials

include("../Geometry/convsurfaces.jl")
include("flow.jl")


export Forced, Natural
export _calculate_h, _interface_fluid, h_conv
export iterateh
export Film, Correction, ForcedConv
export intervec, intermat
export reynolds, grashoff, nusselt
export surface, regime, nusselt, reynolds, grashoff, hcoef
export AbstractSurface, AbstractPipeArray, AbstractPipe
export Wall, Cylinder, Il_pipe_array, Qu_pipe_array, CircularPipe, Duct, ForcedConv
export char_length, pipe_length, inclination, cylinder_angle, array_NL ,array_SL, array_St, quaxy_sd, curvradius, char_speed



struct Forced end
struct Natural end




_calculate_h(Nu::Real, L::Real, k::Real) = Nu * k / L

function _interface_fluid(flu::Liquid, T::Real, Tₛ::Real, ::Film)

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

function _interface_fluid(flu::Liquid, Tₛ::Real, ::Correction)

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


function _interface_fluid(flu::Gas, T::Real, Tₛ::Real, ::Film)

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

function _interface_fluid(flu::Gas, Tₛ::Real, ::Correction)

    flus = flu
    return flus
end


function h_conv(v::Real, sup::AbstractSurface, flu::AbstractFluid, Tₛ::Real)

    L  = char_length(sup)
    flus = _interface_fluid(flu, Tₛ, Correction())
    V  = char_speed(sup, v)
    k  = conductividad(flu)
    Nu = nusselt(sup, V, flu, flus)
    h  = _calculate_h(Nu::Real, L::Real, k::Real)

    return h

end


function h_conv(v::Real, sup::Wall, flu::AbstractFluid, T::Real, Tₛ::Real)

    fluf = _interface_fluid(flu, T, Tₛ, Film())
    k  = conductividad(fluf)
    L  = char_length(sup)
    V  = char_speed(sup, v)
    Nu = nusselt(sup, V, fluf)
    h  = _calculate_h(Nu::Real, L::Real, k::Real)

    return h

end


"""
type containig forced convection information.

### fields
    
- `flu`: fluid.
- `sup`: surface.
- `T`: fluid temperature away form the surface.
- `Tₛ`: surface temperature.
- `Re`: Reynolds number.
- `Gr`: Grashoff number.
- `Nu`: Nusselt number.
- `h`: Convection Coefficent [W/m²K].         

"""
struct ForcedConv
    flu::AbstractFluid
    sup::AbstractSurface
    T::Real
    Tₛ::Real
    Re::Real
    Gr::Real
    Nu::Real
    h::Real
end
function ForcedConv(sup::AbstractSurface,T::Real,Tₛ::Real,v::Real,fluname::String)
    flu₁ = Fluid(fluname,T) ; fluₛ = Fluid(fluname,Tₛ)
    V = char_speed(sup,v)
    typeof(sup) == Wall ? flu = _interface_fluid(flu₁,T,Tₛ,Film()) : flu = flu₁
    Re = reynolds(sup,V,flu)
    Gr = grashoff(flu,Tₛ,sup)
    typeof(sup) == Wall ? Nu = nusselt(sup, V, flu) : Nu = nusselt(sup,V,flu,fluₛ)
    k = conductividad(flu)
    L = char_length(sup)
    h = Nu*k/L
    return ForcedConv(flu,sup,T,Tₛ,Re,Gr,Nu,h)
end

surface(x::ForcedConv) = x.sup
reynolds(x::ForcedConv) = x.Re
nusselt(x::ForcedConv) = x.Nu
grashoff(x::ForcedConv) = x.Gr
hcoef(x::ForcedConv) = x.h
function archimedes(x::ForcedConv)
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


end