export Flow
export intervec, intermat, regime
export reynolds, grashoff, nusselt, _is_internal_flow, δCLt, δCLh


"""
Type containing flow properties and geometry

### Fields

- `fluid` Fluid that is flowing
- `speed` Speed at which the fluid is flowing
- `surface` Geometry that defines the shape of the flow

### Constructors

```
Flow(flu::AbstractFluid,v::Real,sup::AbstractSurface)
Flow(v::Real,sup::AbstractSurface,fluname::String,T::Real)
```
"""
struct Flow
    fluid::AbstractFluid
    speed::Real
    surface::AbstractSurface
end
function Flow(v::Real,sup::AbstractSurface,fluname::String,T::Real)
    flu = Fluid(fluname,T)
    flow = Flow(flu,v,sup)
    return flow
end

_surfacename(sup::Wall) = "Pared plana"
_surfacename(sup::Cylinder) = "Cilindro"
_surfacename(sup::AbstractPipeArray) = "Banco de tubos"
_surfacename(sup::CircularPipe) = "Tubo"
_surfacename(sup::Duct) = "Ducto"


_is_internal_flow(sup::AbstractSurface) = false
_is_internal_flow(sup::AbstractPipe) = true


function Base.show(io::IO,flow::Flow)
    sup = flow.surface
    flu = flow.fluid
    T = flu.T
    v = flow.speed
    Lc = char_length(sup)
    name = _fluid_name(flu)
    if _is_internal_flow(sup)
        println(io,"Flujo interno de ",name," a velocidad v=$v","m/s, y temperatura T=$T","K")
        println(io,"A traves de un ",_surfacename(sup)," de diametro hidráulico D=$Lc","m")
    else
        println(io,"Flujo externo de ",name," a velocidad v=$v","m/s, y temperatura T=$T","K")
        println(io,"Intercambiando con ",_surfacename(sup)," de longitud característica Lc=$Lc","m")
    end
end

"""
    flowgeo(x::Flow)

Returns the geometry defining a flows shape.
"""
flowgeo(x::Flow)=x.surface


"""
    flowspd(x::Flow)

Returns the module of the flow speed away from the surface.
"""
flowspd(x::Flow)=x.speed


"""
    flowflu(x::Flow)

Returns the fluid which is flowing.
"""
flowflu(x::Flow)=x.fluid



"""
    intervec(value::T, v1::Vector{S}, v2::Vector{D})::Float64 where T<:Number where S<:Number where D<:Number

Interpolates looking for `value` in a vector `v1`, linearly aproximating its corresponding value at vector `v2`

# Example

```julia-repl
julia> v1 = [3,2]
julia> v2 = [10,9]
julia> value = 2.5
julia> intervec(value,v1,v2)
9.5
```
"""
function intervec(value::T, v1::Vector{S}, v2::Vector{D})::Float64 where T<:Number where S<:Number where D<:Number
    i = 1
    if v1[1] > v1[2]
        while value < v1[i]
            i = i + 1
        end
        if value == v1[1]
            return v2[1]
        else
            return (v2[i] - v2[i-1]) / (v1[i] - v1[i-1]) * (value - v1[i-1]) + v2[i-1]
        end
    else
        while value > v1[i]
            i = i + 1
        end
        if value == v1[1]
            return v2[1]
        else
            return (v2[i] - v2[i-1]) / (v1[i] - v1[i-1]) * (value - v1[i-1]) + v2[i-1]
        end
    end
end

function intermat(value1,value2, v1::Vector{T}, v2::Vector{S},M::Matrix{D})::Float64 where T<:Number where S<:Number where D<:Number
    i = 1; j = 1
    while value1 ≥ v1[i]
        i = i + 1
    end
    while value2 ≥ v2[j]
        j = j + 1
    end
    valueⱼ = (M[i,j-1]+M[i-1,j-1])/(v1[i]-v1[i-1])*(value1-v1[i-1])+M[i-1,j-1]
    valueⱼ₊₁ = (M[i,j]+M[i-1,j])/(v1[i]-v1[i-1])*(value1-v1[i-1])+M[i-1,j]
    
    return (valueⱼ₊₁-valueⱼ)/(v2[j]-v2[j-1])*(value2-v2[j-1])+valueⱼ

end

"""
    reynolds(x::Flow)

Calculates the reynolds number from fluid properties, velocity and geometry.

### Methods

```
reynolds(surface::AbstractSurface, v::Real, fluid::AbstractFluid)
reynolds(x::Flow)
reynolds(x::ForcedConv)
reynolds(x::Real,v::Real,ν::Real)
```

# Example

```julia-repl
julia> geo = Cylinder(0.08)
julia> flu = Gas("air",300)
julia> v = 8
julia> flow = Flow(flu,v,geo)
julia> reynolds(flow)
40276.90371302705
```
"""
function reynolds(surface::AbstractSurface, v::Real, fluid::AbstractFluid)::Real
    ν = viscocidad(fluid)
    L = char_length(surface)
    V = char_speed(surface, v)
    re = V * L / ν
    return re
end
function reynolds(x::Flow)
    sup = flowgeo(x) ; v = flowspd(x) ; flu = flowflu(x)
    V = char_speed(sup,v) ; L = char_length(sup) ; ν = viscocidad(flu)
    re = V * L / ν
    return re
end
reynolds(x::Real,v::Real,ν::Real) = v*x/ν
   


"""
    regime(x::Flow)

Expresses the regime of a convective flow object type.

### Methods
```
regime(sup::AbstracSurface,re::Real)
regime(x::Flow)

```
# Example

```julia-repl
julia> geo = Wall(1)
julia> flu = Gas("air",300)
julia> v = 10
julia> flow = Flow(flu,v,geo)
julia> regime(flow)
"turbulent"
```
"""
function regime(wall::Wall,re::Real)
    re < 500000 ? reg = "laminar" : reg = "turbulent"
    return reg
end
function regime(cyl::Cylinder,re::Real)
    re < 10 ? reg = "laminar" : re < 1000 ? reg = "turbulentlow" : reg = "turbulenthigh"
    return reg
end
function regime(pipea::AbstractPipeArray,re::Real)
    re < 10 ? reg = "laminar" : re < 100 ? reg = "turbulentlow" : re < 1000 ? reg = "turbulentmed" : re < 200000 ? reg = "turbulenthigh" : reg = "turbulenthigher"
    return reg
end
function regime(pipe::AbstractPipe,re::Real)
    re < 2000 ? reg = "laminar" : re<10000 ? reg = "transition" : reg="turbulent"
    return reg
end
function regime(flow::Flow)
    re = reynolds(flow) ; sup = flowgeo(flow)
    reg = regime(sup,re)
    return reg
end
"""
    grashoff(flu::AbstractFluid,Tₛ::Real,sup::AbstractSurface) 

Calculates the Grashoff number for a fluid `flu` interacting with a surface `sup` at a temperature `Tₛ`.

# Example
```julia-repl
julia> geo = Cylinder(0.1)
julia> flu = Gas("agua",350)
julia> Tₛ = 320
julia> grashoff(flu,Tₛ,geo)
1.3405025566106656e9
```
"""
function grashoff(fluid::AbstractFluid,Tₛ::Real,x::AbstractSurface)
    L = char_length(x)
    k, ν, Pr, β, name, T = get_props(fluid)
    gr = 9.8*β*abs(T-Tₛ)*L^3/ν^2
    return gr
end

"""
Calculates the Rayleigh number for nusselt calculations.

### Methods
```julia-repl
rayleigh(gr::Real,flu::AbstractFluid)
rayleigh(gr::Real,pr::Real)

```

# Example
```julia-repl
julia> pr = 0.707
julia> gr = 2.0e9
julia> rayleigh(gr,pr)
1.414e9
```

"""
rayleigh(gr::Real,flu::AbstractFluid) = prandlt(flu)*gr
rayleigh(gr::Real,pr::Real) = gr*pr

"""
    nusselt(surf::AbstractSurface,v::Real,fluid::AbstractFluid,fluidₛ::AbstractFluid)

Calculates the nusselt number for the given fluid, flow and geometry properties

### Methods

```julia-repl
nusselt(wall::Wall,v::Real,fluid::AbstractFluid)
nusselt(sup::AbstracSurface,v::Real,fluid::AbstractFluid,fluidₛ::AbstractFluid)
```

# Example
```
julia> geo = Cylinder(0.05)
julia> flu = Gas("air",400)
julia> v = 5
julia> fluₛ = Gas("air",500)
julia> nusselt(geo,v,flu,fluₛ)
53.35272341539146
```
"""
function nusselt(wall::Wall,v::Real,fluid::AbstractFluid)::Real

    re = reynolds(wall, v, fluid)
    pr = prandlt(fluid)
    if re < 500000
        @assert 0.6 < pr throw("Prandlt out of range")
        return (0.664 * re^0.5) * pr^0.33
    else
        if re < 10^8
            @assert 0.6 < pr < 60 throw("Prandlt out of range")
            return (0.037 * re^0.8 - 871) * pr^0.33
        else
            error("Reynolds out of range")
        end
    end
end
function nusselt(cylinder::Cylinder,v::Real,fluid::AbstractFluid,fluidₛ::AbstractFluid)::Real
    θ  = [90, 80, 70, 60, 50, 40, 30, 20, 10]
    EΨ = [1, 1, 0.98, 0.94, 0.88, 0.78, 0.67, 0.52, 0.42]
    φ  = cylinder_angle(cylinder)
    Eφ = intervec(φ, θ, EΨ)
    re = reynolds(cylinder, v, fluid)
    pr = prandlt(fluid)
    prₛ = prandlt(fluidₛ)
    if 10 ≤ re < 1000
        return Eφ * 0.59 * re^0.47 * pr^0.38 * (pr/prₛ)^0.25
    else
        if re < 200000
            return Eφ * 0.21 * re^0.62 * pr^0.38 * (pr/prₛ)^0.25
        end
    end

end
function nusselt(ilpipe::Ilpipearray,v::Real,fluid::AbstractFluid,fluidₛ::AbstractFluid)::Real
    Cₙ = [0.99,0.98,0.97,0.95,0.92,0.9,0.86,0.8,0.7]
    n  = [16,13,10,7,5,4,3,2,1]
    Nₗ = array_NL(ilpipe)
    if Nₗ ≤ 16
        C  = intervec(Nₗ,n,Cₙ)
    else
        C = 1
    end
    re = reynolds(ilpipe,v,fluid)
    pr = prandlt(fluid)
    prₛ= prandlt(fluidₛ)
    if 10 ≤ re < 100
        nu = 0.8*C*re^0.4*pr^0.36*(pr/prₛ)^0.25
    else
        if re < 1000
            nu = 0.51*C*re^0.5*pr^0.36*(pr/prₛ)^0.25
        else
            if re < 200000
                nu = C*0.27*re^0.63*pr^0.36*(pr/prₛ)^0.25 
            else
                if re < 2000000
                    nu = 0.021*re^0.84*pr^0.36*(pr/prₛ)^0.25
                else
                    error("Reynolds out of range")
                end
            end
        end
    end

    return nu

end
function nusselt(ilpipe::Qupipearray,v::Real,fluid::AbstractFluid,fluidₛ::AbstractFluid)::Real
    Cₙ = [0.99,0.98,0.97,0.95,0.92,0.89,0.84,0.76,0.64]
    n  = [16,13,10,7,5,4,3,2,1]
    Nₗ = array_NL(ilpipe)
    if Nₗ ≤ 16
        C  = intervec(Nₗ,n,Cₙ)
    else
        C = 1
    end
    re = reynolds(ilpipe,v,fluid)
    pr = prandlt(fluid)
    prₛ= prandlt(fluidₛ)
    ST = array_St(ilpipe)
    SL = array_SL(ilpipe)
    if 10 ≤ re < 100
        nu = 0.9*C*re^0.4*pr^0.36*(pr/prₛ)^0.25
    else
        if re < 1000
            nu = 0.51*C*re^0.5*pr^0.36*(pr/prₛ)^0.25
        else
            if re < 200000
                nu = ST/SL < 2 ? C*0.35*(ST/SL)^0.2*re^0.6*pr^0.36*(pr/prₛ)^0.25 : C*0.4*re^0.6*pr^0.36*(pr/prₛ)^0.25
            else
                if re < 2000000
                    nu = 0.022*re^0.84*pr^0.36*(pr/prₛ)^0.25
                else
                    error("Reynolds out of range")
                end
            end
        end
    end

    return nu

end
function nusselt(pipe::AbstractPipe,v::Real,fluid::AbstractFluid,fluidₛ::AbstractFluid)::Real
    D  = char_length(pipe)
    R = curvradius(pipe)
    re = reynolds(pipe,v,fluid)
    Tₛ = fluidtemp(fluidₛ)
    l  = pipe_length(pipe)
    pr = prandlt(fluid)
    prₛ = prandlt(fluidₛ)
    

    lD = l/D
    
    if re < 2200
        ϵ = [1,1.02,1.05,1.13,1.18,128,1.44,1.7,1.9]
        ld = [50,40,30,20,15,10,5,2,1]
        ϵₗ =  lD ≥ 50 ? 1 : intervec(lD,ld,ϵ)
        gr = grashoff(fluid,Tₛ,pipe)
        nu = ϵₗ*0.17*re^0.33*pr^0.43*gr^0.1*(pr/prₛ)^0.25
    else
        if re < 10000
            K₀ = [33,30,27,24,20,16.5,12.2,10,7.5,4.9,3.6,2.2]
            Re = [10000,9000,8000,7000,6000,5000,4000,3500,3000,2500,2300,2200]
            Kₒ = intervec(re,Re,K₀)
            nu = Kₒ*pr^0.43*(pr/prₛ)^0.25
        else
            if re < 5000000 && 0.6<pr<2500
                Re = [10000,20000,50000,100000,1000000]
                ld = [1,2,5,10,15,20,30,40,50]
                ϵ = [
                        1.65 1.50 1.34 1.23 1.17 1.13 1.07 1.03 1
                        1.51 1.40 1.27 1.18 1.13 1.10 1.05 1.02 1
                        1.34 1.27 1.18 1.13 1.10 1.08 1.04 1.02 1
                        1.28 1.22 1.15 1.10 1.08 1.06 1.03 1.02 1
                        1.14 1.11 1.08 1.05 1.04 1.03 1.02 1.01 1
                    ]
                ϵₗ = (re>1000000 || lD ≥ 50) ? 1 : intermat(re,lD,Re,ld,ϵ)
                ϵᵣ = R==0 ? 1 : 1+1.77*D/R
                nu = ϵₗ*ϵᵣ*0.021*re^0.8*pr^0.43*(pr/prₛ)^0.25
            else
                error("Reynolds or Prandlt out of range")
            end
        end
    end

    return nu

end

function nusselt(wall::Wall,flu::AbstractFluid,Tₛ::Real)
    if _is_vertical(wall)
        gr = grashoff(flu,Tₛ,wall)
        pr = prandlt(flu)
        prs = prandlt(flu,Tₛ)
        ra = rayleigh(gr,pr)
        if ra < 10^3
            throw("Rayleigh out of range")
        else
            if ra < 10^9
                nu = 0.76*ra^0.25*(pr/prs)^0.25
            else
                nu = 0.15*ra^0.33*(pr/prs)^0.25
            end
        end
    elseif _is_horizontal(wall)
        T = fluidtemp(flu)
        if ((T < Tₛ) && (inclination(wall) == 0))||((Tₛ < T) && inclination(wall) == 180 )
            if 10e4 ≤ ra < 10e7
                nu = 0.54*ra^0.25
            else
                if 10e7 ≤ ra < 10e11
                    nu = 0.15*ra^0.33
                else
                    throw("rayleigh out of range")
                end
            end
        elseif ((T > Tₛ) && (inclination(wall) == 0))||((Tₛ > T) && inclination(wall) == 180)
            if 10e5 ≤ ra < 10e10
                nu = 0.27*ra^0.25
            else
                throw("rayleigh out of range")
            end
        end
    end
    return nu
end
#=
function nusselt(surf::Cylinder,flu::AbstractFluid,Tₛ::Real)
    
end
=#

function δCLh(flu::AbstractFluid,x::Real,v::Real)
    ν = viscocidad(flu)
    re = reynolds(x,v,ν)
    if re == 0
        δ = 0
    elseif re ≤ 500000
        δ = 5*x/re^0.5
    else
        δ = 0.37*x/re^(1/5)
    end
    return δ
end

function δCLt(flu::AbstractFluid,x::Real,v::Real)
    ν = viscocidad(flu) ; pr = prandlt(flu)
    re = reynolds(x,v,ν)
    if re == 0
        δ = 0
    elseif re ≤ 500000
        δ = 5*x/(re^0.5*pr^(1/3))
    else
        δ = 0.37*x/re^(1/5)
    end
    return δ
end