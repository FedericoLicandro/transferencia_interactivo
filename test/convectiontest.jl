using Interactive_HT

L = 1.65
wall = Wall(L)
T = 300  # K
Tₛ = 350 # K
v = 2    # m/s
air = Liquid("agua",T)
type = Forced()
h    = h_conv(v,wall,air,T,Tₛ,type)


D = 0.25
Cyl = Cylinder(D)
T = 300
Tₛ = 350
v = 6 
aire = Gas("air",T)
props(aire)
type = Forced()

h = h_conv(v,Cyl,aire,Tₛ,type)

Nₗ = 5
D = 0.02
Sₜ = 0.03
Sₗ = 0.04
banco1 = Qupipearray(D,Sₜ,Sₗ,Nₗ) 

T = 600
Tₛ = 310
v = 20

aire = Gas("air",T)
type = Interactive_HT.Forced()

h = h_conv(v,banco1,aire,Tₛ,type)

a = 0.1
b = 0.05
l = 10
R = 0.2
pipe = Duct(a, b=b , l=l , R=R)
T  = 288
Tₛ = 313
v = 2
agua = Liquid("agua", T)
type = Forced()

h = h_conv(v,pipe,agua,Tₛ,type)
