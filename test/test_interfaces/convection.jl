using Interactive_HT
using Test

@testset "definición de superficies" begin

end

#=@testset "Formulas de convección" begin
    @test h_conv(5.6,Wall(1.2),Gas("air",310),310,290,Forced()) ≈ 8.44 atol=0.01
    @test h_conv(12,Wall(1.2),Gas("air",300),300,350,Forced()) ≈ 21.88 atol=0.01
    @test h_conv(2,Wall(1.65),Liquid("agua",300),300,350,Forced()) ≈ 5360 atol = 50
    @test h_conv(6,Cylinder(0.25),Gas("air",300),350,Forced()) ≈ 23.42 atol = 0.1
end =#
