abstract type AbstractHTGeometry end

"""
type containig rectangular geometry for cartesian problems.

### fields
    
- `height`: height of the cylinder.
- `length`: length of the cylinder.   

"""
struct RectangularDomain <: AbstractHTGeometry
    height::Real
    length::Real
end

"""
type containig cylindrical geometry for axicymetrical problems.

### fields

- `radius`: radius of the cylinder.
- `length`: length of the cylinder.

"""
struct Cylider2D <: AbstractHTGeometry
    radius::Real
    length::Real
end
