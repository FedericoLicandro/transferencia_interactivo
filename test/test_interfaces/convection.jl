using Interactive_HT.Convection
using Interactive_HT.Materials
using Test

@testset "definición de superficies" begin
    @test Wall(1) == Wall(1,φ=0)
    @test Cylinder(1) == Cylinder(1,φ=90)
    @test CircularPipe(1) == CircularPipe(1,l=50,R=0)
    @test Duct(1,b=1,l=50,R=0) == Duct(1)
end

@testset "reynolds criticos" begin
    @test regime(Wall(1),500001) == "turbulent"
    @test regime(Wall(1),499999) == "laminar"
    @test regime(Cylinder(1),9) == "laminar"
    @test regime(Cylinder(1),11) == "turbulentlow"
    @test regime(Cylinder(1),999) == "turbulentlow"
    @test regime(Cylinder(1),1001) == "turbulenthigh"
    @test regime(Il_pipe_array(1,1,1,1),9) == "laminar"
    @test regime(Il_pipe_array(1,1,1,1),11) == "turbulentlow"
    @test regime(Qu_pipe_array(1,1,1,1),99) == "turbulentlow"
    @test regime(Il_pipe_array(1,1,1,1),101) == "turbulentmed"
    @test regime(Qu_pipe_array(1,1,1,1),999) == "turbulentmed"
    @test regime(Qu_pipe_array(1,1,1,1),1001) == "turbulenthigh"
    @test regime(Il_pipe_array(1,1,1,1),199999) == "turbulenthigh"
    @test regime(Qu_pipe_array(1,1,1,1),200001) == "turbulenthigher"
end

@testset "Formulas de convección" begin
    @test h_conv(5.6,Wall(1.2),Gas("air",310),310,290,Forced()) ≈ 8.44 atol=0.01
    @test h_conv(12,Wall(1.2),Gas("air",300),300,350,Forced()) ≈ 21.88 atol=0.01
    @test h_conv(2,Wall(1.65),Liquid("agua",300),300,350,Forced()) ≈ 5360 atol = 50
    @test h_conv(6,Cylinder(0.25),Gas("air",300),350,Forced()) ≈ 23.52 atol = 0.1
    @test h_conv(14,Il_pipe_array(0.025,0.04,0.04,7),Gas("air",400),350,Forced()) ≈ 222.6 atol = 0.1
    @test h_conv(14,Qu_pipe_array(0.025,0.04,0.04,7),Gas("air",400),350,Forced()) ≈ 210.7 atol = 0.1
    @test h_conv(1.7,CircularPipe(0.04),Liquid("agua",300),290,Forced()) ≈ 5346 atol = 1
    @test h_conv(15,Duct(0.4,b = 0.4,l = 50,R =2),Gas("air",550),700,Forced()) ≈ 33 atol = 0.1
end 
