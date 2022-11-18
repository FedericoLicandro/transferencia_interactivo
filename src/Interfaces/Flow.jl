

module Flow

export Film, Correction
export intervec, reynolds, nusselt
export pipe_length, char_length, inclination, cylinder_angle, array_St, array_SL, array_NL, quaxy_sd, char_speed
export AbstractSurface, AbstractPipeArray, AbstractPipe
export Wall, Cylinder, Il_pipe_array, Qu_pipe_array, CircularPipe, Duct

include("../Geometry/convsurfaces.jl")



using Interactive_HT.Materials

struct Film end
struct Correction end


    function intervec(value::Float64,v1::Vector{Float64},v2::Vector{Float64})::Float64
        i = 1
        while value ≤ v1[i]
            i = i + 1 
        end
        return (v2[i]-v2[i+1])/(v1[i]-v1[i+1])*(value-v1[i+1])+v2[i+1]
    end

    function reynolds(surface::AbstractSurface,v::Real,fluid::AbstractFluid)::Real
        ν = viscocidad(fluid)
        L = char_length(surface)
        return v*L/ν
    end

    function nusselt(wall::Wall,v::Real,fluid::AbstractFluid)::Real
        
        re=reynolds(wall,v,fluid)
        pr=prandlt(fluid)
        if re < 500000
            @assert 0.6 < pr throw("Prandlt out of range")
            return (0.664*re^0.5)*pr^0.33
        else
            if re < 10^8
                @assert 0.6 < pr < 60 throw("Prandlt out of range")
                return (0.037*re^0.8-871)*pr
            else
                error("Reynolds out of range")
            end
        end
    end
    

    function nusselt(cylinder::Cylinder,v::Real,fluid::AbstractFluid,fluidₛ::AbstractFluid)::Real
        θ  = [90,80,70,60,50,40,30,20,10];
        EΨ = [1,1,0.98,0.94,0.88,0.78,0.67,0.52,0.42];
        φ = cilinder_angle(cilinder)
        Eφ = intervec(φ,θ,EΨ)
        re = reynolds(wall,v,fluid)
        pr = prandlt(fluid)
        prₛ= prandlt(fluidₛ)
        if 10 < re < 1000
            return Eφ*0.59*re^0.47*pr^0.38*(pr/prₛ)^0.25
        else
            if re < 200000
                return Eφ*0.21*re^0.62*pr^0.38*(pr/prₛ)^0.25  
            end
        end    

    end

end