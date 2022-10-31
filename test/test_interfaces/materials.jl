using Interactive_HT.Materials
using Test

@testset "Props cobre" begin
    @test k_solid("Cu",300) == 401.0
    @test k_solid("Cu",350) == 397.0
    @test C_solid("Cu",300) == 0.385
    @test C_solid("Cu",350) == 0.391
    @test ρ_solid("Cu") == 8933
end

@testset "Props cobre" begin
    @test k_solid("Cu",300) == 401.0
    @test k_solid("Cu",350) == 397.0
    @test C_solid("Cu",300) == 0.385
    @test C_solid("Cu",350) == 0.391
    @test ρ_solid("Cu") == 8933
    @test_throws "Temperature is out of range for the selected material" Metal("Cu",1500)
    @test_throws "Temperature is out of range for the selected material" Metal("Cu",10)
end
