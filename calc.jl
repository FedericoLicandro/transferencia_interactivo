using Interactive_HT

T = 295
Tₛ= 283
D = 0.01
v = 10
St = 0.02
Sl = 0.06
Nl = 6
flu = Gas("air",T)
sup = Qupipearray(D,St,Sl,Nl)
V = char_speed(sup,v)
h = h_conv(v,sup,flu,Tₛ,Forced())
lD = 8/0.4
#la wea qlfome

Tw = 283
Ts = 283
vw = 0.35
fluw =Liquid("agua",Tw)
supw = CircularPipe(D,l=0.35,R=0)
ν = viscocidad(fluw)
re = vw*D/ν
β = β_fluid("agua",Tw)
gr = 9.8*β*abs(Tw-Ts)*D^3/ν^2
h    = h_conv(vw,supw,fluw,Ts,Forced())
