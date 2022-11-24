export AbstractSurface, AbstractPipeArray, AbstractPipe
export Wall, Cylinder, Il_pipe_array, Qu_pipe_array, CircularPipe, Duct
export char_length, pipe_length, inclination, cylinder_angle, array_NL ,array_SL, array_St, quaxy_sd, curvradius, char_speed

"Surfaces used for convection heat exchange"
abstract type AbstractSurface end

"Plain wall with paralel flow, characteristic length is the walls length in the flow direction"
Base.@kwdef struct Wall <: AbstractSurface
    Lc::Real
    φ::Real 
    function Wall(L::Real; φ = 0)
        new(L,φ)
    end
end

"Cilinder with crossed flow, characteristic length is the cilinders diameter"
Base.@kwdef struct Cylinder <: AbstractSurface
    Lc::Real
    φ::Real = 90
    function Cylinder(L::Real; φ = 90)
        new(L,φ)        
    end
end

"Envelopes all types of pipe array"
abstract type AbstractPipeArray <: AbstractSurface end

"In line pipe array external surface, characteristic length is the singular pipe diameter"
struct Il_pipe_array <: AbstractPipeArray
    Lc::Real
    Sₜ::Real
    Sₗ::Real
    Nₗ::Integer
end

"Quincunx pipe array external surface, characteristic length is the singular pipe diameter"
struct Qu_pipe_array <: AbstractPipeArray
    Lc::Real
    Sₜ::Real
    Sₗ::Real
    Nₗ::Int
end

"Envelopes all types of pipe"
abstract type AbstractPipe <: AbstractSurface end

"Traditional pipe geometry, characteristic length is the pipes diameter"
struct CircularPipe <: AbstractPipe
    Lc::Real
    l::Real
    R::Real
    function CircularPipe(D::Real)
        new(D,50,0)
    end
end

"Quadrangular pipe geometry, characteristic length is four times the pipe wall length"
struct Duct <: AbstractPipe
    a::Real
    b::Real
    l::Real
    R::Real
    function Duct(a::Real;b=a,l=50,R=0 )
        new(a,b,l,R)
    end
end



"Returns the length field of a pipe object"
pipe_length(x::AbstractPipe) = x.l;

"Returns the characteristic length field of an AbstractSurface type object"
char_length(x::AbstractSurface) = x.Lc;
char_length(x::Duct) = 4*x.a*x.b/(2*x.a+2*x.b);

"Returns inclination of a Wall object"
inclination(x::Wall) = x.φ

"Returns relative flow direction of a Cilinder object"
cylinder_angle(x::Cylinder) = x.φ;

"Returns the Sₜ field of an AbstractPipeArray type object"
array_St(x::AbstractPipeArray) = x.Sₜ;

"Returns the Sₗ field of an AbstractPipeArray type object"
array_SL(x::AbstractPipeArray) = x.Sₗ;

"Returns the Nₗ field of an AbstractPipeArray type object"
array_NL(x::AbstractPipeArray) = x.Nₗ;

"Calculates the SD of an Qu_pipe_array object"
quaxy_sd(x::Qu_pipe_array) = (x.Sₗ^2 + (x.Sₜ / 2)^2)^0.5;


curvradius(x::AbstractPipe) = x.R

"Calculates the characteristic speed of an AbstractSurface type object"
char_speed(x::Any, v::Real) = abs(v);
char_speed(x::Il_pipe_array, v::Real) = abs(v) * (x.Sₜ / (x.Sₜ - x.Lc));
char_speed(x::Qu_pipe_array, v::Real) = abs(v) * max(x.Sₜ / (x.Sₜ - x.Lc), x.Sₜ / (2 * (quaxy_sd(x) - x.Lc)));
