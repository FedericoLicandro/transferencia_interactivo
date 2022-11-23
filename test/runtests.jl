using SafeTestsets

@safetestset "Material iteration tests" begin
    include("test_interfaces/materials.jl")
end

@safetest "Convection formula tests" begin
    include("test_interfaces/convection.jl")
end