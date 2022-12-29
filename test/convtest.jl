using Interactive_HT

L   = 1;
sup = Wall(L)

name = "agua"
v    = -2
T    = 300
Tₛ    = 320

conv = ForcedConv(sup,T,Tₛ,v,name)