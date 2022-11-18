"Indicates the heat equation to be solved in stationary conditions"
struct Stationary
end



"
Indicates the heat equation to be solved in transitory conditions.

### fields

- `tₒ`: Starting time value.

- `tf`: Final time value.

- `n`: number of time steps.

"
struct Transitory
    t₀::Real
    tf::Real
    n::Int
end