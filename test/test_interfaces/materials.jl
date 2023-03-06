using Interactive_HT.Materials
using Test

@testset "Props cobre" begin
    @test k_solid("Cu",300) == 401.0
    @test k_solid("Cu",350) == 397.0
    @test C_solid("Cu",300) == 0.385
    @test C_solid("Cu",350) == 0.391
    @test ρ_solid("Cu") == 8933
    @test_throws "Temperature is out of range for the selected material" Metal("Cu",1500)
    @test_throws "Temperature is out of range for the selected material" Metal("Cu",10)
end

@testset "Props aire" begin
    @test k_fluid("air",300) == 0.0263
    @test k_fluid("air",325) == 0.0263/2+ 0.0300/2
    @test ν_fluid("air",300) == 15.89*10^-6
    @test ν_fluid("air",325) == (1/2)*15.89*10^-6 + (1/2)*20.92*10^-6
    @test β_fluid("air",500) == 1/500
    @test_throws "Temperature is out of range for the selected material" Gas("air",1500)
    @test_throws "Temperature is out of range for the selected material" Gas("air",10)
end

@testset "Material definitions" begin
    @test Metal(8933,0.385,401.0,name="Cu") == Metal("Cu",300)
    @test_throws "Material is not available, check keys(Tₘₑₜ) for correct definition of metallic materials." Metal("wrongname",300)
    @test Gas(0.0263,0.707,15.89*10^-6,1/300,"air",300) == Gas("air",300)
    @test Fluid("air",300) == Gas("air",300)
    @test Fluid("agua",300)==Liquid("agua",300)
end

@testset "fluid name" begin
    @test _fluid_name(Gas("air",300)) == "Aire"
    @test _fluid_name(Liquid("agua",300)) == "Agua"
    @test _fluid_name(Gas(1,1,1,1,"custom",300)) == "Fluido personalizado"
end

