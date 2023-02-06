
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

#=
"""

"""
struct Domain2D
    X::XRange
    f₁::Function
    f₂::Function
    function Domain2D(X::XRange,f1::Function,f2::Function)
        x₀ = _origin(X) , xₗ = _endpoint(X);
        @assert (max(f1(x₀),f1(xₗ),f2(x₀),f2(xₗ)) < Inf) & (min(f1(x₀),f1(xₗ),f2(x₀),f2(xₗ)) > -Inf) throw("Domain limits are not correctly defined")
    end
end
=#