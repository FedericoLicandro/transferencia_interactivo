using Interactive_HT, Plots

fluido = Fluid("air",500)
v = 10
X = 0:0.0005:2
Δt = []
Δh = []
n = length(X)
for i in 1:n
    x = X[i]
    δt = δCLt(fluido,x,v)*1000
    δh = δCLh(fluido,x,v)*1000
    push!(Δt,δt)
    push!(Δh,δh)
end

plot(X,[Δh,Δt], title="Capa limite", label=["Velocidad" "Temperatura"], linewidth=2)
#plot!(legend=:)
ylabel!("δ (mm)")
xlabel!("x (mm)")