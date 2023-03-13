
export AbstractHTGeometry, RectangularDomain, Cylider2D

abstract type AbstractHTGeometry end



"""
Type containig rectangular geometry for cartesian problems.

### fields
    
- `height`: height of the cylinder.
- `length`: length of the cylinder.   

"""
struct RectangularDomain <: AbstractHTGeometry
    height::Real
    length::Real
end

"""
Type containig cylindrical geometry for axicymetrical problems.

### fields

- `radius`: radius of the cylinder.
- `length`: length of the cylinder.

"""
struct Cylider2D <: AbstractHTGeometry
    radius::Real
    length::Real
end


"""
Definition of 1-dimentional ranges used to limit domains.
Default origin is xₒ = 0

### fields

- `xₒ`: range startpoint
- `xₗ`: range endpoint

### Constructors

Xrange(x1::Real)
Xrange(x1::Real; x0 = lₒ)

"""
struct XRange
    xₒ::Real
    xₗ::Real
    function XRange(x1::Real; x0 = 0)
        if x0 > x1
            new(x1,x0)
        else
            if x1 > x0
                new(x0,x1)
            else
                throw("Range limits must be different from one another")
            end
        end
    end
end

"""
Returns the startpoint of an XRange

### Example
```julia-repl
julia> X = XRange(1)
julia> xₒ = _origin(X)
0
```
"""
_origin(X::XRange) = X.xₒ

"""
Returns the endpoint of an XRange

### Example
```julia-repl
julia> X = XRange(1)
julia> xₗ = _endpoint(X)
1
```
"""
_endpoint(X::XRange) = X.xₗ


"""
Returns the length of an XRange

### Example
```julia-repl
julia> X = XRange(3,x0=1)
julia> l = _length(X)
2
```
"""
_length(X::XRange) = _endpoint(X) - _origin(X)

struct Point
    x::Real
    y::Real
end

function Base.show(io::IO,p::Point)
    px = p.x;
    py = p.y;
    print(io,"($px,$py)") 
end

"""

"""
struct Domain2D
    X::XRange
    ∂north::Function
    ∂south::Function
end

north(Ω::Domain2D) = Ω.∂north
south(Ω::Domain2D) = Ω.∂south
xrange(Ω::Domain2D) = Ω.X
xwest(Ω::Domain2D) = _origin(xrange(Ω))
xeast(Ω::Domain2D) = _endpoint(xrange(Ω))
_length(Ω::Domain2D) = _length(xrange(Ω))

function swcorner(Ω::Domain2D)
    fₛ = south(Ω)
    xw = xwest(Ω)
    return Point(xw,fₛ(xw))
end

function nwcorner(Ω::Domain2D)
    fₙ = north(Ω)
    xw = xwest(Ω)
    return Point(xw,fₙ(xw))
end

function necorner(Ω::Domain2D)
    fₙ = north(Ω)
    xe = xeast(Ω)
    return Point(xe,fₙ(xe))
end

function secorner(Ω::Domain2D)
    fₛ = south(Ω);
    xe = xeast(Ω);
    return Point(xe,fₛ(xe))
end

function corners(Ω)
    sw = swcorner(Ω::Domain2D);
    nw = nwcorner(Ω::Domain2D);
    ne = necorner(Ω::Domain2D);
    se = secorner(Ω::Domain2D);
    corners = [sw,nw,ne,se]
    return corners
end

nodeseparation(n::Int,L::Real) = L/(n-1)

function evpoint∂(p::Point,h::Real,n::Int,f::Function)
    pointvec = Point[]
    push!(pointvec,p)
    for i in 1:n-2
        xp = p.x + i*h
        yp = f(xp)
        pₒ = Point(xp,yp)
        push!(pointvec,pₒ)
    end
    return pointvec
end

function ∂N(Ω::Domain2D,n::Int,h::Real,nw::Point,ne::Point)
    fₙ  = north(Ω)
    ∂Nₙ = evpoint∂(nw,h,n,fₙ)
    push!(∂Nₙ,ne)
    return ∂Nₙ
end

function ∂S(Ω::Domain2D,n::Int,h::Real,sw::Point,se::Point)
    fₛ  = south(Ω)  
    ∂Sₙ = evpoint∂(sw,h,n,fₛ)
    push!(∂Sₙ,se)
    return ∂Nₙ
end

function ∂W(h::Real,sw::Point,nw::Point)
    px = sw.x
    py = sw.y + h
    ny = nw.y
    ∂Wₙ = Point[]
    while py < ny 
        p = Point(px,py)
        push!(∂Wₙ,p)
        py += h
    end
    return ∂Wₙ 
end

function ∂E(h::Real,se::Point,ne::Point)
    px = se.x
    py = se.y + h
    ny = ne.y
    ∂Eₙ = Point[]
    while py < ny
        p = Point(px,py)
        push!(∂Eₙ,p)
        py += h
    end
    return ∂Eₙ    
end

function borderpoints(Ω::Domain2D,n::Int)
    sw , nw , ne , se = corners(Ω);
    L = _length(Ω)
    h = nodeseparation(n,L)
    ∂Wₙ = ∂W(h,sw,nw)
    ∂Nₙ = ∂N(Ω,n,h,nw,ne)
    ∂Sₙ = ∂S(Ω,n,h,sw,se)
    ∂Eₙ = ∂E(h,se,ne)
end


f1(x) = x
f2(x) = 0
X    = XRange(2,x0 = 1 )
Ω    = Domain2D(X,f1,f2)
corn = corners(Ω)
se   = secorner(Ω);
n    = 20



