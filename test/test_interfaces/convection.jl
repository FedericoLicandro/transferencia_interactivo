using Interactive_HT.Convection;
using Interactive_HT.Materials;
using Test;

@testset "definición de superficies" begin
    @test Wall(1) == Wall(1,φ=0)
    @test Cylinder(1) == Cylinder(1,φ=90)
    @test CircularPipe(1) == CircularPipe(1,l=50,R=0)
    @test Duct(1,b=1,l=50,R=0) == Duct(1)
end;

@testset "funciones de superficies" begin
    @test _is_vertical(Wall(1,φ=90)) == true
    @test _is_vertical(Wall(1)) == false
end

@testset "convección interna o externa" begin
    sup1 = Duct(0.3)
    sup2 = Wall(1)
    sup3 = Cylinder(0.05)
    sup4 = Ilpipearray(0.025,0.04,0.04,7)
    sup5 = Qupipearray(0.020,0.035,0.035,5)
    sup6 = CircularPipe(0.0254)
    @test _is_internal_flow(sup1) == true
    @test _is_internal_flow(sup2) == false
    @test _is_internal_flow(sup3) == false
    @test _is_internal_flow(sup4) == false
    @test _is_internal_flow(sup5) == false
    @test _is_internal_flow(sup6) == true
end;

@testset "reynolds criticos" begin
    @test regime(Wall(1),500001) == "turbulent"
    @test regime(Wall(1),499999) == "laminar"
    @test regime(Cylinder(1),9) == "laminar"
    @test regime(Cylinder(1),11) == "turbulentlow"
    @test regime(Cylinder(1),999) == "turbulentlow"
    @test regime(Cylinder(1),1001) == "turbulenthigh"
    @test regime(Ilpipearray(1,1,1,1),9) == "laminar"
    @test regime(Ilpipearray(1,1,1,1),11) == "turbulentlow"
    @test regime(Qupipearray(1,1,1,1),99) == "turbulentlow"
    @test regime(Ilpipearray(1,1,1,1),101) == "turbulentmed"
    @test regime(Qupipearray(1,1,1,1),999) == "turbulentmed"
    @test regime(Qupipearray(1,1,1,1),1001) == "turbulenthigh"
    @test regime(Ilpipearray(1,1,1,1),199999) == "turbulenthigh"
    @test regime(Qupipearray(1,1,1,1),200001) == "turbulenthigher"
    gas = Gas("air",300) ; sup = Wall(1) ; v = 12; flow = Flow(gas,v,sup)
    re = reynolds(sup,v,gas)
    @test regime(flow) == regime(sup,re)
    @test reynolds(flow) == re
end;

@testset "interface fluid" begin
    @test _interface_fluid(Gas("air",300),350)==Gas("air",300)
    @test _interface_fluid(Liquid("agua",300),340)==Liquid("agua",340)
    @test _interface_fluid(Liquid("agua",300),300,350)==Liquid("agua",325.0)
    @test _interface_fluid(Gas("air",300),300,350)==Gas("air",325.0)
end;

@testset "Formulas de convección" begin
    @test h_conv(5.6,Wall(1.2),Gas("air",310),290) ≈ 8.44 atol=0.01
    @test h_conv(12,Wall(1.2),Gas("air",300),350) ≈ 21.88 atol=0.01
    @test h_conv(2,Wall(1.65),Liquid("agua",300),350) ≈ 5360 atol = 50
    @test h_conv(6,Cylinder(0.25),Gas("air",300),350) ≈ 23.52 atol = 0.1
    @test h_conv(14,Ilpipearray(0.025,0.04,0.04,7),Gas("air",400),350) ≈ 222.6 atol = 0.1
    @test h_conv(14,Qupipearray(0.025,0.04,0.04,7),Gas("air",400),350) ≈ 210.7 atol = 0.1
    @test h_conv(1.7,CircularPipe(0.04),Liquid("agua",300),290) ≈ 5346 atol = 1
    @test h_conv(15,Duct(0.4,b = 0.4,l = 50,R =2),Gas("air",550),700) ≈ 33 atol = 0.1
    gas = Gas("air",300) ; sup = Wall(1) ; v = 12; flow = Flow(gas,v,sup)
    @test h_conv(flow,320) == h_conv(v,sup,gas,320)
    agüita = Liquid("agua",360) ; sup2 = CircularPipe(0.025) ; v2 = 1; flow2 = Flow(agüita,v2,sup2)
    @test h_conv(flow2,343) == h_conv(v2,sup2,agüita,343)
    conv = ForcedConv(sup,300,320,v,"air")
    @test conv == ForcedConv(flow,320)
    @test h_conv(conv) == h_conv(flow,320)
    @test h_conv(conv) == h_conv(v,sup,gas,320)
    conv2 = ForcedConv(sup2,360,343,v2,"agua")
    @test conv2 == ForcedConv(flow2,343)
    @test h_conv(conv2) == h_conv(flow2,343)
    @test h_conv(conv2) == h_conv(v2,sup2,agüita,343)
end;
