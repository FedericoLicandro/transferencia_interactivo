using Interactive_HT, Plots

fluido = Fluid("agua",320)
v = 5
X = 0:0.0005:0.1
Δ = []
n = length(X)
for i in 1:n
    x = X[i]
    δ = δCLt(fluido,x,v)
    push!(Δ,δ)
end

plot(X,Δ)