using Interactive_HT, Plots

fluido = Fluid("air",400)
v = 5
L = 2; X = 0:L/200:L
Tₛ = 300
δt = capalimt(fluido,L,v,Tₛ);
δh = capalimh(fluido,L,v,Tₛ);
h = convpunt(fluido,L,v,Tₛ);

#=
Δt = []; Δh = []; hc = []
n = length(X)
for i in 1:n
    x = X[i]
    δt = δCLt(fluido,x,v,Tₛ)*1000
    δh = δCLh(fluido,x,v,Tₛ)*1000
    h = h_conv(v,x,fluido,Tₛ)
    push!(Δt,δt)
    push!(Δh,δh)
    push!(hc,h)
end =#

plot(X,[δh,δt], title="Capa limite y coef de convección", label=["Velocidad" "Temperatura"], linewidth=2, ylabel = "δ [mm]", xlabel="x [m] ", ylims=(0,50),xlims=(0,2))
plot!(twinx(), X, h,color=:green, ylabel="h [W/m²K]",label="Coef. Conv.", ylims=(0,50),xlims=(0,2))
