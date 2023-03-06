export AbstractSurface, AbstractPipeArray, AbstractPipe
export Wall, Cylinder, Ilpipearray, Qupipearray, CircularPipe, Duct
export char_length, pipe_length, inclination, cylinder_angle, array_NL ,array_SL, array_St, quaxy_sd, curvradius, char_speed

"""
Surfaces used for convection heat exchange
"""
abstract type AbstractSurface end

"""
Plain wall with paralel flow, characteristic length is the walls length in the flow direction

### Fields

- `Lc`: Length of the wall in the flow direction.
- `φ`: attack angle

### Constructors
```
Wall(L::Real)
Wall(L::Real,φ=θ)
```

### Example
```julia-repl
julia> L = 1
julia> surface = Wall(L)
Wall(1, 0)
```

"""
Base.@kwdef struct Wall <: AbstractSurface
    Lc::Real
    φ::Real 
    function Wall(L::Real; φ = 0)
        new(L,φ)
    end
end

function Base.show(io::IO,sup::Wall)
    Lc = sup.Lc
    φ = sup.φ
    println("Pared plana de largo L=$Lc","m")
    println("Inclinación φ=$φ","º")
end

"""
Cylinder with crossed flow, characteristic length is the cilinders diameter

### Fields

- `Lc`: Cylinder diameter
- `φ`: attack angle

### Constructors
```
Cylinder(D::Real)
Cylinder(D::Real,φ=θ)
```

### Example
```julia-repl
julia> D = 0.05
julia> surface = Cylinder(D)
Cylinder(0.05, 90)
```
"""
Base.@kwdef struct Cylinder <: AbstractSurface
    Lc::Real
    φ::Real = 90
    function Cylinder(L::Real; φ = 90)
        new(L,φ)        
    end
end

function Base.show(io::IO,sup::Cylinder)
    Lc = sup.Lc
    φ = sup.φ
    println("Cilindro con flujo cruzado de diametro D=$Lc","m")
    println("Angulo de incidencia φ=$φ","º")
end

"""
Engloves all types of pipe array
"""
abstract type AbstractPipeArray <: AbstractSurface end

"""
In line pipe array external surface, characteristic length is the singular pipe external diameter

### Fields

- `Lc`: Pipe external diameter
- `Sₜ`: Separation between pipes of the same column
- `Sₗ`: Separation between pipes of the same line
- `Nₗ`: Number of pipe columns

### Constructor
```
Ilpipearray(L::Real,Sₜ::Real,Sₗ::Real,Nₗ::Integer)
```

### Example
```julia-repl
julia> D  = 0.01
julia> Sₜ = 0.03
julia> Sₗ = 0.03
julia> Nₗ = 10
julia> surface = Ilpipearray(D,Sₜ,Sₗ,Nₗ)
Ilpipearray(0.01,0.03,0.03,10)
```
"""
struct Ilpipearray <: AbstractPipeArray
    Lc::Real
    Sₜ::Real
    Sₗ::Real
    Nₗ::Integer
end

"""
Quincunx pipe array external surface, characteristic length is the singular pipe external diameter
### Fields

- `Lc`: Pipe external diameter
- `Sₜ`: Separation between pipes of the same column
- `Sₗ`: Separation between pipes of the same line
- `Nₗ`: Number of pipe columns

### Constructor
```
Qupipearray(L::Real,Sₜ::Real,Sₗ::Real,Nₗ::Integer)
```

### Example
```julia-repl
julia> D  = 0.01
julia> Sₜ = 0.03
julia> Sₗ = 0.03
julia> Nₗ = 10
julia> surface = Qupipearray(D,Sₜ,Sₗ,Nₗ)
Qupipearray(0.01,0.03,0.03,10)
```
"""
function Base.show(io::IO,sup::Ilpipearray)
    Lc = sup.Lc
    N = sup.Nₗ
    SL =sup.Sₗ
    St = sup.Sₜ
    println("Banco de tubos con disposición alineada de diametro D=$Lc","m")
    println("Cantidad de columnas N=$N")
    println("Separación entre columnas Sₗ=$SL","m")
    println("Separación entre filas Sₜ=$St","m")
end

struct Qupipearray <: AbstractPipeArray
    Lc::Real
    Sₜ::Real
    Sₗ::Real
    Nₗ::Int
end

function Base.show(io::IO,sup::Qupipearray)
    Lc = sup.Lc
    N = sup.Nₗ
    SL =sup.Sₗ
    St = sup.Sₜ
    println("Banco de tubos con disposición tresbolillo de diametro D=$Lc","m")
    println("Cantidad de columnas N=$N")
    println("Separación entre columnas Sₗ=$SL","m")
    println("Separación entre filas Sₜ=$St","m")
end

"""
Envelopes all types of pipe
"""
abstract type AbstractPipe <: AbstractSurface end

"""
Traditional pipe geometry, characteristic length is the pipes diameter
### Fields

- `Lc`: Pipe internal diameter
- `l` : Pipe length
- `R` : Curvature radius

### Constructors
```
CircularPipe(D::Real)
CircularPipe(D::Real;l=L,R=r)
CircularPipe(D::Real,l=L)
CircularPipe(D::Real,R=r)
```

### Example
```julia-repl
julia> D  = 0.01
julia> pipe = CircularPipe(D)
CircularPipe(0.01, 50, 0)
```

"""
struct CircularPipe <: AbstractPipe
    Lc::Real
    l::Real
    R::Real
    function CircularPipe(D::Real;l=50,R=0)
        new(D,50,0)
    end
end

function Base.show(io::IO,sup::CircularPipe)
    Lc = sup.Lc
    l = sup.l
    R = sup.R
    println("Tubo de diametro D=$Lc","m")
    println("Largo l=$l","m, ","radio de curvatura R=$R","m")
end

"""
Quadrangular pipe geometry, characteristic length is four times the pipe wall length.

By default width equals height, length is 50 meters and curvature radius is null.

### Fields

- `a` : Duct height
- `b` : Duct width
- `l` : Duct length
- `R` : Curvature radius

### Constructors
```
Duct(a::Real)
Duct(a::Real,b=w,l=L,R=r)
Duct(a::Real,b=w,R=r)
Duct(a::Real,b=w,l=L)
Duct(a::Real,l=L,R=r)
Duct(a::Real,l=L)
Duct(a::Real,R=r)
Duct(a::Real,b=w)
```

### Example
```julia-repl
julia> a  = 0.4
julia> pipe = Duct(a)
Duct(0.4, 0.4, 50, 0)
```

"""
struct Duct <: AbstractPipe
    a::Real
    b::Real
    l::Real
    R::Real
    function Duct(a::Real;b=a,l=50,R=0 )
        new(a,b,l,R)
    end
end

function Base.show(io::IO,sup::Duct)
    a = sup.a
    b = sup.b
    l = sup.l
    R = sup.R
    println("Tubo de altura a=$a","m, ","ancho b=$b")
    println("Largo l=$l","m, ","radio de curvatura R=$R","m")
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

"Calculates the SD of an Qupipearray object"
quaxy_sd(x::Qupipearray) = (x.Sₗ^2 + (x.Sₜ / 2)^2)^0.5;


curvradius(x::AbstractPipe) = x.R

"Calculates the characteristic speed of an AbstractSurface type object"
char_speed(x::Any, v::Real) = abs(v);
char_speed(x::Ilpipearray, v::Real) = abs(v) * (x.Sₜ /(x.Sₜ-x.Lc));
char_speed(x::Qupipearray, v::Real) = abs(v) * max(x.Sₜ / (x.Sₜ - x.Lc), x.Sₜ / (2 * (quaxy_sd(x) - x.Lc)));
