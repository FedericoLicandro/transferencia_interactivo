using Interactive_HT.Materials
using Test

@testset "Props cobre" begin
    @test k_solid("Cu",300) == 401.0
    @test k_solid("Cu",350) == 397.0
end