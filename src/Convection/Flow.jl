
struct Film end
struct Correction end

function intervec(value::T, v1::Vector{S}, v2::Vector{D})::Float64 where T<:Number where S<:Number where D<:Number
    i = 1
    while value ≤ v1[i]
        i = i + 1
    end
    return (v2[i] - v2[i+1]) / (v1[i] - v1[i+1]) * (value - v1[i+1]) + v2[i+1]
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


function reynolds(surface::AbstractSurface, v::Real, fluid::AbstractFluid)::Real
    ν = viscocidad(fluid)
    L = char_length(surface)
    re = v * L / ν
    println("Reynolds is ", re)
    return re
end

function grashoff(fluid::AbstractFluid,Tₛ::Real,x::AbstractSurface)
    L = char_length(x)
    k, ν, Pr, β, name, T = _get_props(fluid)
    gr = 9.8*β*abs(T-Tₛ)*L^3/ν^2
    return gr
end


function nusselt(wall::Wall, v::Real, fluid::AbstractFluid)::Real

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

function nusselt(cylinder::Cylinder, v::Real, fluid::AbstractFluid, fluidₛ::AbstractFluid)::Real
    θ  = [90, 80, 70, 60, 50, 40, 30, 20, 10]
    EΨ = [1, 1, 0.98, 0.94, 0.88, 0.78, 0.67, 0.52, 0.42]
    φ  = cylinder_angle(cylinder)
    Eφ = intervec(φ, θ, EΨ)
    re = reynolds(cylinder, v, fluid)
    pr = prandlt(fluid)
    prₛ = prandlt(fluidₛ)
    if 10 ≤ re < 1000
        return Eφ * 0.59 * re^0.47 * pr^0.38 * (pr / prₛ)^0.25
    else
        if re < 200000
            return Eφ * 0.21 * re^0.62 * pr^0.38 * (pr / prₛ)^0.25
        end
    end

end

function nusselt(ilpipe::Il_pipe_array, v::Real, fluid::AbstractFluid, fluidₛ::AbstractFluid)::Real
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


function nusselt(ilpipe::Qu_pipe_array, v::Real, fluid::AbstractFluid, fluidₛ::AbstractFluid)::Real
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