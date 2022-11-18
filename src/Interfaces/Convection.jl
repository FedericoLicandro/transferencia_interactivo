#module Convection



using Interactive_HT.Materials
using Interactive_HT.Flow



struct Forced end
struct Natural end

_calculate_h(Nu::Real,L::Real,k::Real) = Nu*k/L
    
function _interface_fluid(flu::Liquid,T::Real,Tₛ::Real,::Film)

    name = flu.name
    codenames = keys(Tₗᵤ)
    
    if name ∈ codenames
        Tf = (T+Tₛ)/2
        flus = Liquid(name,Tf)
    else
        flus = flu
    end

    return flus

end

function _interface_fluid(flu::Liquid,Tₛ::Real,::Correction)

    name = flu.name
    codenames = keys(Tₗᵤ)
    
    if name ∈ codenames
        Tf = Tₛ
        flus = Liquid(name,Tf)
    else
        flus = flu
    end

    return flus
end


function _interface_fluid(flu::Gas,T::Real,Tₛ::Real,::Film)

    name = flu.name
    codenames = keys(Tₗᵤ)
    
    if name ∈ codenames
        Tf = (T+Tₛ)/2
        flus = Gas(name,Tf)
    else
        flus = flu
    end

    return flus

end

function _interface_fluid(flu::Gas,Tₛ::Real,::Correction)

    flus = flu
    return flus
end


function h_conv(v::Real,sup::AbstractSurface,flu::AbstractFluid,Tₛ::Real,::Forced)
    
    flus = _interface_fluid(flu,Tₛ,Correction())
    V    = char_speed(sup,v)
    Nu   = nusselt(sup,V,flu,flus)
    h    = _calculate_h(Nu::Real,L::Real,k::Real)

    return h

end


function h_conv(v::Real,sup::Wall,flu::AbstractFluid,T::Real,Tₛ::Real,::Forced)

    fluf = _interface_fluid(flu,T,Tₛ,Film())
    k    = conductividad(flu)
    L    = char_length(sup)
    V    = char_speed(sup,v)
    Nu   = nusselt(sup,V,fluf)
    h    = _calculate_h(Nu::Real,L::Real,k::Real)

    return h

end


#end

#= Toy example

T = 288
flu = Gas("air",T)
sup = Wall(0.5,90)
Tₛ = 299
v = 0.5
h_conv(v,sup,flu,T,Tₛ,Forced())
=#