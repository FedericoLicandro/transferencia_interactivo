using Interactive_HT;

T = 400 ; fluid = "air" ; v = 5 ; D = 0.05;
Tₛ = 500;
flu = Fluid(fluid,T);
fluₛ = Fluid(fluid,Tₛ);
geo = Cylinder(D);
flow = Flow(flu,v,geo);
gr = grashoff(flu,Tₛ,geo)
nu = nusselt(geo,v,flu,fluₛ)

T₂ = 350;
flu₂ = Fluid(fluid,T₂);
flow₂ = Flow(flu₂,v,geo);

vec = iterateh(flow,flow₂)


h1 = h_conv(flow,Tₛ);
conv = ForcedConv(flow,Tₛ);
h2 = h_conv(conv);
h3 = h_conv(v, geo, flu, Tₛ);

v1 = [3,2]
v2 = [10,9]
value = 2.5
intervec(value,v1,v2)


v3 =[5,6]
value2 = 5.2
f2 = intervec(value2,v3,v2)