abstract type AbstractHTGeometry end


struct RectangularDomain <:AbstractHTGeometry
    height::Real
    length::Real
end

struct Cilider2D <:AbstractHTGeometry
    radius::Real
    length::Real
end