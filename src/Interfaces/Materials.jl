# Materiales, como definirlos, que propiedades tienen y que funciones se les aplican

"Tipo que engloba a todos los materiales posibles"
abstract type AbstractMaterial end

"Tipo que engloba a todos los solidos posibles"
abstract type AbstractSolid  <:AbstractMaterial end


"Tipo que engloba a todos los fluidos posibles"
abstract type AbstractFluid <:AbstractMaterial end

"Definición de medio metálico para aplicar a un dominio

Se puede definir un metal de dos maneras diferentes:

Metal personalizado, asignando una a una las propiedades del metal

    Metal(ρ,C,k)
    
    ρ: Densidad del metal en kg/m³
    
    C: Calor específico del metal en kJ/kgºC
    
    k: Condictividad térmica del metal en W/mºC


A partir de su temperatura y su nombre codigo, tomando las propiedades de la bibliografía
   
Metal(name,T)

    Name: Nombre codigo del metal

    T: Temperatura del metal en K
    
    "
struct Metal <:AbstractSolid
    ρ::Real 
    C::Real
    k::Real
    α::Real
    function Metal(ρ,C,k)
        new(ρ,C,k,k/(ρ*C*1000))
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


A partir de su temperatura y su nombre codigo, tomando las propiedades de la bibliografía
   
Gas(name,T)

    Name: Nombre codigo del gas

    T: Temperatura del gas en K
    
    "
struct Gas <:AbstractFluid
    k  ::Real
    ν  ::Real
    Pr ::Real
    β  ::Real
end


"Definición de medio liquido para aplicar a un dominio

Se puede definir un liquido de dos maneras diferentes:

Liquido personalizado, asignando una a una las propiedades del liquido

    Liquid(k,ν,Pr,β)
    
    k: Condictividad térmica del metal en W/mºC
    
    ν: Viscocidad cinemática del gas en m²/s
    
    Pr: Número de Prandlt
    
    β: (1/ρ)(∂ρ/∂T)ₚ (coeficiente volumétrico de expansión termica) en 1/K 

A partir de su temperatura y su nombre codigo, tomando las propiedades de la bibliografía
   
Liquido(name,T)

    Name: Nombre codigo del liquido

    T: Temperatura del liquido en K
    
    "
struct Liquid <:AbstractFluid
    k  ::Real
    ν  ::Real
    Pr ::Real
    β  ::Real
end

# Algunas funciones aplicables a materiales

"Devuelve la conductividad del material x en W/mk"
conductividad(x::AbstractMaterial) = x.k

"Devuelve la viscocidad cinemática del fluido x en m²/s"
viscocidad(x::AbstractFluid) = x.ν

"Número de Prandlt del fluido x"
prandlt(x::AbstractFluid) = x.Pr

"Coeficiente volumétrico de expansión térmica del fluido x en 1/K"
beta(x::AbstractFluid) = x.β

"Calor específico del solido x en kJ/kgºC"
Calor_esp(x::AbstractSolid) = x.C

"Densidad del solido x en kg/m³"
densidad(x::AbstractSolid) = x.ρ

"Difusividad térmica del solido x en m²/s"
diff_term(x::AbstractSolid) = x.α

function props(x::AbstractFluid)
    
    char = Char(x)
    ν =viscocidad(x)
    k = conductividad(x)
    Pr = prandlt(x)
    β = beta(x)
    
    println("Propiedades:")
    println("--------------------------")
    println("ν  | $ν m²/s")
    println("k  | $k W/mk")
    println("Pr | $Pr ")
    println("β  | $β 1/K")
end

x=Liquid(1,1,1,1)

