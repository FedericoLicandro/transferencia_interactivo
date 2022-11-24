using Interactive_HT

T = 550
Tₛ= 700
D = 0.4
v = 15
alg = Forced()
name ="air"
sup = Duct(D,b=D,l=50,R=2)
flu = Gas(name,T)
ν = viscocidad(flu)
pr = prandlt(flu)
k = conductividad(flu)
prs = pr
V = char_speed(sup,v)
re = V*D/ν
nu = (1+1.77*D/2)*0.021*re^0.8*pr^0.43*(pr/prs)^0.25
h = k*nu/D
struct Correction end
flus = _interface_fluid(flu,Tₛ,Interactive_HT.Correction())
lD = 8/0.4
#la wea qlfome