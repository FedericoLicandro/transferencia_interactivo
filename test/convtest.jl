using Interactive_HT

T₁ = 300
T₂ = 350
flu₁ = Gas("air",T₁)
flu₂ = Liquid("agua",T₂)
v₁ = 0.5
v₂ = 0.5
D = 0.03
sup = Cylinder(D)
ϵ = 0.00001

hs = iterateh(sup,flu₁,flu₂,v₁,v₂,tol=ϵ)