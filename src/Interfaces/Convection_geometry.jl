module Convection_geometry

"Surfaces used for convection heat exchange"
abstract type AbstractSurface end

"Plain wall with paralel flow, characteristic length is the walls length in the flow direction"
struct Pp_wall <:AbstractSurface
    Lc :: Real
end

"Cilinder with crossed flow, characteristic length is the cilinders diameter"
Base.@kwdef struct Cf_cilinder <:AbstractSurface
    Lc :: Real
    φ  :: Real = 1
end

"Envelopes all types of pipe array"
abstract type AbstractPipeArray <:AbstractSurface end

"In line pipe array external surface, characteristic length is the singular pipe diameter"
struct Il_pipe_array <:AbstractPipeArray
    Lc :: Real
    Sₜ :: Real
    Sₗ :: Real
    Nₗ :: Integer
end

"Quincunx pipe array external surface, characteristic length is the singular pipe diameter"
struct Qu_pipe_array <:AbstractPipeArray
    Lc :: Real
    Sₜ :: Real
    Sₗ :: Real
    Nₗ :: Int
end

"Envelopes all types of pipe"
abstract type AbstractPipe <:AbstractSurface end

"Traditional pipe geometry, characteristic length is the pipes diameter"
struct CircularPipe <:AbstractPipe
    Lc::Real
    l ::Real
end

"Quadrangular pipe geometry, characteristic length is four times the pipe wall length"
struct Duct <:AbstractPipe
    a ::Real
    l ::Real
end

pipe_length(x::AbstractPipe) = x.l
char_length(x::AbstractSurface) = x.Lc
char_length(x::Duct) = 4*x.a
cilinder_angle(x::Cf_cilinder) = x.φ
array_St(x::AbstractPipeArray) = x.Sₜ
array_SL(x::AbstractPipeArray) = x.Sₗ
array_NL(x::AbstractPipeArray) = x.Nₗ
quaxy_sd(x::Qu_pipe_array) = (x.Sₗ^2+(x.Sₜ/2)^2)^0.5
char_speed(x::AbstractSurface,v) = abs(v)
char_speed(x::Il_pipe_array) = abs(v)*(x.Sₜ/(x.Sₜ-x.Lc))
char_speed(x::Qu_pipe_array) = abs(v)*max(x.Sₜ/(x.Sₜ-x.Lc),x.Sₜ/(2*(quaxy_sd(x)-x.Lc)))

end