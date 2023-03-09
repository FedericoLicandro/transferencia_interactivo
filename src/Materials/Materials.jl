# Materiales, como definirlos, que propiedades tienen y que funciones se les aplican

module Materials

using Printf

export AbstractMaterial, AbstractSolid, AbstractFluid, Metal, Gas, Liquid, Fluid
export k_fluid, k_solid, C_solid, ν_fluid, Pr_fluid, β_fluid, ρ_solid, conductividad, prandlt, viscocidad, densidad, calor_esp, diff_term, beta, props, get_props, fluidtemp, _get_fluid_name, _is_liquid, _fluid_name
export kₗ, νₗ, Pr, Tₗᵤ, β, kₘ, C, Tₘₑₜ, ρₘ, nameₘ, nameₗ

include("metals.jl")
include("fluids.jl")

names = keys(Tₘₑₜ)
names_fl = keys(Tₗᵤ)

function interprops(name::String, T::Real, d::Dict, Tₘₑₜ=Tₘₑₜ)

    codenames = keys(Tₘₑₜ)
    if name ∈ codenames
        Table_Temp = Tₘₑₜ[name]
        Tₑ = extrema(Table_Temp)
        @assert Tₑ[1] ≤ T ≤ Tₑ[2] throw("Temperature is out of range for the selected material")
        index = 1

        while Table_Temp[index] < T
            index = index + 1
        end

        Tₗ = Table_Temp[index-1]
        Tₕ = Table_Temp[index]
        dₕ = d[name, Tₕ]
        dₗ = d[name, Tₗ]

        return (dₕ - dₗ) / (Tₕ - Tₗ) * (T - Tₗ) + dₗ
    else
        throw("Material is not available, check keys(Tₘₑₜ) for correct definition of metallic materials.")
    end
end


"Tipo que engloba a todos los materiales posibles"
abstract type AbstractMaterial end

"Tipo que engloba a todos los solidos posibles"
abstract type AbstractSolid <: AbstractMaterial end



"Interpola linealmente la conductividad de un solido en las tablas de la bibliografía en función de la temperatura.

Los solidos posibles son:

$names"
k_solid(name::String, T=300, kₘ=kₘ) = interprops(name, T, kₘ)

"Interpola linealmente el calor específico de un solido en las tablas de la bibliografía en función de la temperatura.

Los solidos posibles son:

$names"
C_solid(name::String, T=300, C=C) = interprops(name, T, C)

"Densidad de un solido según la bibliografía.

Los solidos posibles son:

$names"
function ρ_solid(name::String, ρₘ=ρₘ)
    codenames = keys(ρₘ)
    if name ∈ codenames
        return ρₘ[name]
    else
        throw("Material is not available, check keys(Tₘₑₜ) for correct definition of metallic materials.")
    end
end

"Definición de medio metálico para aplicar a un dominio

Se puede definir un metal de dos maneras diferentes:

Metal personalizado, asignando una a una las propiedades del metal

    Metal(ρ,C,k)
    
    ρ: Densidad del metal en kg/m³
    
    C: Calor específico del metal en kJ/kgºC
    
    k: Condictividad térmica del metal en W/mºC

    "
struct Metal <: AbstractSolid

    ρ::Real
    C::Real
    k::Real
    α::Real
    T::Real
    name::String

    function Metal(ρ::Real, C::Real, k::Real; name="custom", T=300)

        @assert min(ρ, C, k,T) > 0 throw("Properties must be positive real numbers")
        new(ρ, C, k, k / (ρ * C * 1000), T, name)

    end

end
"
A partir de su temperatura y su nombre codigo, tomando las propiedades de la bibliografía
   
    Metal(name,T)

    Name: Nombre codigo del metal

    T: Temperatura del metal en K
"
function Metal(nombre, Temp)::Metal

    ρ = ρ_solid(nombre)
    k = k_solid(nombre, Temp)
    C = C_solid(nombre, Temp)

    return Metal(ρ, C, k, T=Temp, name=nombre)
end

function Base.show(io::IO,met::Metal)
    k = met.k
    ρ = met.ρ
    C = met.C
    α = @sprintf("%.2e",k/(ρ*C*1000))
    T = met.T
    if met.name ∈ keys(nameₘ)
        name = nameₘ[met.name]
        println(name," a $T","K")
    else
        println("Metal personalizado")
    end
    println("=================")
    println("   Propiedades   ")
    println("=================")
    println("Densidad ρ=$ρ","kg/m³")
    println("Conductividad térmica k=$k","W/mK")
    println("Capacidad térmica C=$C","kJ/kgK")
    println("Difusividad térmica α=$α","m²/s")
end

function _props_sol(x::AbstractSolid)

    ρ = densidad(x)
    k = conductividad(x)
    C = trunc(Calor_esp(x), digits=3)

    println("Propiedades:")
    println("============")
    println("ρ  | $ρ kg/m³")
    println("k  | $k W/mk")
    println("C  | $C kJ/kgºC")

end


"Tipo que engloba a todos los fluidos posibles"
abstract type AbstractFluid <: AbstractMaterial end


"Interpola linealmente la conductividad de un fluido en las tablas de la bibliografía en función de la temperatura.

Los fluidos posibles son:

$names_fl"
k_fluid(name::String, T=300, kₗ=kₗ) = interprops(name, T, kₗ, Tₗᵤ)

"Interpola linealmente la viscocidad cinemática de un fluido en las tablas de la bibliografía en función de la temperatura.

Los fluidos posibles son:

$names_fl"
ν_fluid(name::String, T=300, νₗ=νₗ) = interprops(name, T, νₗ, Tₗᵤ)


"Interpola linealmente el número de Prandlt de un fluido en las tablas de la bibliografía en función de la temperatura.

Los fluidos posibles son:

$names_fl"
Pr_fluid(name::String, T=300, Pr=Pr) = interprops(name, T, Pr, Tₗᵤ)


"Interpola linealmente el coeficiente volumétrico de expansión térmica de un fluido en las tablas de la bibliografía en función de la temperatura.

Los fluidos posibles son:

$names_fl"
function β_fluid(name::String, T=300, βₗ=βₗ)
    if βₗ[name] == "gas"
        return 1 / T
    else
        interprops(name, T, βₗ, Tₗᵤ)
    end
end


"Definición de medio gaseoso para aplicar a un dominio

Se puede definir un gas de dos maneras diferentes:

Gas personalizado, asignando una a una las propiedades del gas

    Gas(k,ν,Pr,β)
    
    k: Condictividad térmica del metal en W/mºC
    
    ν: Viscocidad cinemática del gas en m²/s
    
    Pr: Número de Prandlt
    
    β: (1/ρ)(∂ρ/∂T) en 1/K
    
    "
struct Gas <: AbstractFluid
    k::Real
    ν::Real
    Pr::Real
    β::Real
    name::String
    T::Real

    function Gas(k, ν, Pr, β, name, T)

        @assert min(Pr, ν, k, T) > 0 throw("Properties must be positive real numbers")
        new(k, Pr, ν, β, name, T)
    end

end

"A partir de su temperatura y su nombre codigo, tomando las propiedades de la bibliografía
   
    Gas(name,T)

    Name: Nombre codigo del gas

    T: Temperatura del gas en K
    
    "
function Gas(name, T)::Gas

    k = k_fluid(name, T)
    Pr = Pr_fluid(name, T)
    ν = ν_fluid(name, T)
    β = β_fluid(name, T)
    named = name
    Temp = T

    return Gas(k, Pr, ν, β, named, Temp)

end

"Definición de medio liquido para aplicar a un dominio

Se puede definir un liquido de dos maneras diferentes:

Liquido personalizado, asignando una a una las propiedades del liquido

    Liquid(k,ν,Pr,β)
    
    k: Condictividad térmica del metal en W/mºC
    
    ν: Viscocidad cinemática del gas en m²/s
    
    Pr: Número de Prandlt
    
    β: (1/ρ)(∂ρ/∂T)ₚ (coeficiente volumétrico de expansión termica) en 1/K 

"
Base.@kwdef struct Liquid <: AbstractFluid
    k::Real
    Pr::Real
    ν::Real
    β::Real
    name::String
    T::Real


    function Liquid(k, ν, Pr, β, name, T)

        @assert min(Pr, ν, k, T) > 0 throw("Properties must be positive real numbers")
        new(k, Pr, ν, β, name, T)
    end
end

"A partir de su temperatura y su nombre codigo, tomando las propiedades de la bibliografía
   
    Liquid(name,T)

    Name: Nombre codigo del liquido

    T: Temperatura del liquido en K
    
    "
function Liquid(name, T)::Liquid

    k  = k_fluid(name, T)
    Pr = Pr_fluid(name, T)
    ν  = ν_fluid(name, T)
    β  = β_fluid(name, T)
    named = name
    Temp  = T

    return Liquid(k, ν, Pr, β, named,Temp)

end


"""
Gets fluid name in spansih for different struct shows

if properties are listed, returns the corresponding name value for the selected fluid.

if the fluid is not a preset material, returns "Fluido personalizado".

"""
function _fluid_name(flu::AbstractFluid)
    if flu.name ∈ keys(nameₗ)
        name = nameₗ[flu.name]
    else
        name = "Fluido personalizado"
    end
    return name    
end

function Base.show(io::IO,flu::AbstractFluid)
    k = flu.k
    Pr = flu.Pr
    ν = flu.ν
    β = flu.β
    T = flu.T
    name = _fluid_name(flu)
    println(name," a $T","K")
    println("=================")
    println("   Propiedades   ")
    println("=================")
    println("Viscocidad cinemática ν=$ν","m²/s")
    println("Conductividad térmica k=$k","W/mK")
    println("Número de Prandlt Pr=$Pr")
    println("Coeficiente de expansión β=$β","1/K")
end



function _is_liquid(name::String,dict=βₗ):Bool
    cond = (dict[name]=="liquid")
    return cond
end

function Fluid(name::String,T::Real)
    @assert name ∈ keys(Tₗᵤ)  throw("Name is not a valid fluid")
    _is_liquid(name) ? flu=Liquid(name,T) : flu=Gas(name,T)
    return flu
end


# Algunas funciones aplicables a materiales

"Devuelve la conductividad del material x en W/mk"
conductividad(x::AbstractMaterial) = x.k

"Devuelve la viscocidad cinemática del fluido x en m²/s"
viscocidad(x::AbstractFluid) = x.ν

""
_get_fluid_name(x::AbstractFluid) = x.name

"Número de Prandlt del fluido x"
prandlt(x::AbstractFluid) = x.Pr
function prandlt(x::AbstractFluid,Tₛ::Real)
   name = _get_fluid_name(x)
   if name ∈ keys(nameₗ)
        prs = Pr_fluid(name,Tₛ)
   else
        prs = prandlt(x)
   end
   return prs
end

fluidtemp(x::AbstractFluid) = x.T

"Coeficiente volumétrico de expansión térmica del fluido x en 1/K"
beta(x::AbstractFluid) = x.β

"Calor específico del solido x en kJ/kgºC"
calor_esp(x::AbstractSolid) = x.C

"Densidad del solido x en kg/m³"
densidad(x::AbstractSolid) = x.ρ

"Difusividad térmica del solido x en m²/s"
diff_term(x::AbstractSolid) = x.α

function _props_flu(x::AbstractFluid)

    ν = trunc(viscocidad(x), digits=8)
    k = conductividad(x)
    Pr = prandlt(x)
    β = beta(x)

    println("Propiedades:")
    println("============")
    println("ν  | $ν m²/s")
    println("k  | $k W/mk")
    println("Pr | $Pr ")
    println("β  | $β 1/K")

end

function _get_props_flu(x::AbstractFluid)
    ν = trunc(viscocidad(x), digits=8)
    k = conductividad(x)
    Pr = prandlt(x)
    β = beta(x)
    name = x.name
    T = fluidtemp(x)
    return [k, ν, Pr, β, name, T]
end

function _get_props_sol(x::AbstractSolid)
    ρ = densidad(x)
    k = conductividad(x)
    C = Calor_esp(x)
    return [ρ, k, C]
end


props(x::AbstractFluid) = _props_flu(x)
props(x::AbstractSolid) = _props_sol(x)

get_props(x::AbstractSolid) = _get_props_sol(x)
get_props(x::AbstractFluid) = _get_props_flu(x)




end
