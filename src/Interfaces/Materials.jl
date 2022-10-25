# Materiales, como definirlos, que propiedades tienen y que funciones se les aplican


abstract type AbstractMaterial end
abstract type AbstractSolid  <:AbstractMaterial end
abstract type AbstractFluid <:AbstractMaterial end


struct Metal <:AbstractSolid
    ρ::Real
    C::Real
    k::Real
    α::Real
    function Metal(ρ,C,k)
        new(ρ,C,k,k/(ρ*C*1000))
    end
end
    #prueba