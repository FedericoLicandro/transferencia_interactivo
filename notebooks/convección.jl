### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ fb5fd8bb-cbf2-4df7-b982-10cada4dc231
import Pkg;

# ╔═╡ 4be4ba4a-2bdf-4dd1-8f80-36912a5361eb
Pkg.activate("../Project.toml");

# ╔═╡ 94211d49-15b3-4e96-9134-aa39e77c1743
using PlutoUI

# ╔═╡ 70a372cf-d9f0-4e12-9a1a-4c7638143e79
using Interactive_HT, Plots

# ╔═╡ dd51a900-6c85-11ed-12f3-e195f1415dc3
md"""### Material complementario e interactivo sobre Convección."""

# ╔═╡ 0873aec3-5c1e-435c-a965-eb74ddc3c551
md"""El material que se presenta en esta página es un complemento de las clases y bibliografía del curso Transferencia de Calor, el mismo no sustituye la bibluiografía recomendada. Los aspectos teóricos descriptos se presentan de manera resumida."""

# ╔═╡ bb14fae8-7e44-41ca-8a2e-5189041dab08
md"""La transferencia de calor por convección es el mecanismo de transferencia de energía térmica, que se da en un fluido cuando presenta diferente temperatura y movimiento relativo con un elemento del espacio (no necesariamente físico, puede ser una superficie imaginaria dentro del fluido). La convección es la convinación de la conducción en el medio fluido (difusión de energía con constante k) y la advección (transporte de enrgía). La conducción es la transferencia de energía que se da por las interacciones (choques, vibraciones, movimientos aleatorios entre capas de fluid) entre partículas de mayor energía cinética (zonas de mayor temperatura) con particulas de menor nivel energético. La advección es la transferencia de energía por transporte de particulas que tienen más energía cinética a zonas donde las particulas tienen menos energía cinética. En conclusión, para que se den los mecanismos de transferencia de calor por convección se necesitan: zonas con particulas con diferentes energías cinéticas, que se representa con la existencia de un gradiente de temperaturas, un medio que permita la conductividad de calor y un mecanismo de transporte que produzca la advección (movimiento relativo)."""

# ╔═╡ 7c22d65d-e3d9-41c5-9761-5d77ae33e5c2
md"""En el curso se le presta especial atención al intercambio entre un fluido en movimiento y una superficie física que lo limita, a diferentes temperaturas. En este caso, el contacto hidrodinámico entre la superficie y el fluido, por la condición de no deslizamiento, genera una capa limite de velocidades, donde la velocidad varia desde 0 y $u₀$, donde $u₀$ es la velocidad lejos de la superficie. Si además la temperatura de la superficie $Tₛ$ y la del fluido $T₀$ son diferentes, se genera una capa limite de temperaturas. La convección entre el fluido y la superficie se da por la difusión y advección del fluido en la capa limite de temperaturas. """

# ╔═╡ 70e784b2-4858-4241-95a2-8eab32618922
md"""La ley de enfriamiento de Newton modela la potencia calorífica intercambiada entre una superficie a una temperatura $Tₛ$ y un fluido a temperatura $Tₗ$:"""

# ╔═╡ 49e8ae4b-d68c-418b-b4f4-ae5f56877c75
md"""$q''=h(Tₗ-Tₛ)$"""

# ╔═╡ 24a105fd-4ae9-4a17-b8bc-5510021a85b2
md"""Donde $q''$ es la tasa de flujo calorifico (W/m²) y $h$ es el coeficiente de convección (W/m²K). El coeficiente $h$ depende de las condiciones de la capa límite, que engloban propiedades del fluido, características del flujo y de la geometría."""

# ╔═╡ ae77ceff-e972-414a-b359-8fbdcb3c48e7
md"""Los mecanismos difusivos de calor gobiernan la transferencia en las zonas de baja velocidad, ya que baja velocidad implica poco transporte. En particular, si se analiza la capa de fluido inmediatamente sobre la superficie (siendo $y$ la coordenada que mide la distancia perpendicular a la superficie en cada uno de sus puntos, es la capa correspondiente a $y=0$), por condición de adherencia del fluido, la velocidad es nula. En esa capa la convección esta dada completamente por la difusión de calor, que se puede modelar con la ley de Fourier."""

# ╔═╡ 98154d1d-e0d1-400b-8d23-ab344dc8093a
md"""$q''=-k∇T$"""

# ╔═╡ 49f52775-42bc-4c77-9ad4-3ab50b9da45b
md"""Si $x$ es la dirección perpendicular a y en la capa sobre la superficie, se puede ver facilmente que el gradiente de la temperatura es igual a la derivada en $y$, ya que T(x,y=0)=Tₛ"""

# ╔═╡ a341496c-8469-461e-a828-66746c622937
md"""Igualando la ley de enfriamiento de Newton a la ley de fourier en $y=0$ se obtiene"""

# ╔═╡ d5ffff65-56b2-4bda-b34c-e593c065d3ee
md"""$h=-k\frac{\frac{∂T}{∂y}|_{y=0}}{Tₗ-Tₛ}$"""

# ╔═╡ db33c58b-5987-49c7-b3c9-68a0a1e600f6
md""" Multiplicando ambos lados de la igualdad por una longitúd característica $L$ y definiendo la temperatura adimensional como:

$Tˣ = \frac{T-Tₛ}{Tₗ-Tₛ}$ 

Resulta 


$hL=-kL\frac{\frac{∂T}{∂y}|_{y=0}}{Tₗ-Tₛ} = k\frac{∂Tˣ}{∂yˣ}|_{y=0}$ 

Se define el número de Nusselt, que representa el gradiente de temperaturas adimensional en $y=0$:

$Nu=\frac{hL}{k}=\frac{∂Tˣ}{∂yˣ}|_{y=0}$"""

# ╔═╡ fbd6c1ff-fd43-4dc5-b19b-acb485620a48
md"""Para resolver los ejercicios del cruso, se cuenta con formulas para calcular el número de Nusselt en función de la geometría, el fluido y el flujo. Esta página presenta un recurso para visualizar la dependencia del coeficiente de convección con diferentes variables."""

# ╔═╡ ac37cb80-c00c-4261-a660-988b9135f178
md""" ### Placa plana con flujo paralelo"""

# ╔═╡ e809c5ba-0d68-498c-b367-7f2e1f20e6df
md"""El primer ejemplo que se va a analizar es el intercambio convectivo que induce una circulación de aire sobre una placa plana que está a temperatura uniforme. """

# ╔═╡ f09ff995-b136-4f3b-9656-c0182a416b85
md"""Los switches de abajo permiten modificar la temperatura y velocidad del aire que circula sobre la placa, más abajo se permite modificar los parametros de la placa."""

# ╔═╡ 62b260a4-07fa-4fd3-8a0e-491936815366
md"""velocidad $v$  [$m/s$]"""

# ╔═╡ dd328cf6-b219-4a7f-874e-d66b1a87f6c3
@bind v Slider(1:0.5:10, default = 6, show_value=true)

# ╔═╡ f2c4cea9-15ca-4707-adb2-5941ef976945
md"""Temperatura de aire $T$ [$K$]"""

# ╔═╡ 667d4720-a015-41aa-9f1b-b628da7cfb73
@bind T Slider(200:10:600, default = 300 , show_value = true)

# ╔═╡ 4a3f428e-a326-4b0d-b9fd-5c0d377f8088
air = Gas("air",T)

# ╔═╡ 0b01b523-56f1-4663-92b2-e1ddc481aa93
# ╠═╡ disabled = true
#=╠═╡
Show(MIME"image/png"(),read("paredplana.png"))
  ╠═╡ =#

# ╔═╡ 3f425661-daab-4d08-963d-e98d8abf092c
md"""Temperatura de superficie $Tₛ \ [K]$"""

# ╔═╡ af8579a4-f284-40ed-8782-dd8064b86cdd
@bind Tₛ Slider(200:10:600, default = 300, show_value = true)

# ╔═╡ 1a999f12-d7cd-4463-8864-34a8367ff92c
begin
Lₚ=2;
X=0:Lₚ/200:Lₚ;
δt = capalimt(air,Lₚ,v,Tₛ);
δh = capalimh(air,Lₚ,v,Tₛ);
hpx = convpunt(air,Lₚ,v,Tₛ);
plot(X,[δh,δt], title="Capa limite y coef de convección", label=["Velocidad" "Temperatura"], linewidth=2, ylabel = "δ [mm]", xlabel="x [m] ", ylims=(0,50),xlims=(0,2))
plot!(twinx(), X, hpx,color=:green, ylabel="h [W/m²K]",label="Coef. Conv.", ylims=(0,50),xlims=(0,2))
end

# ╔═╡ 2cd928c7-3b9f-4bc1-9c68-a23af7a8f4d1
md"""Para el caso de la placa plana, se puede estimar el espesor de las capas limites hidrodinámica $δ$ y termodinámica $δₜ$, utilizando las siguientes correlaciones para flujo laminar y turbulento.

Laminar:

$\frac{δ(x)}{x}=5Reₓ^{1/2} \ \ \ \ \ \ \frac{δ(x)}{δₜ(x)} \approx Pr^{1/3}$

Turbulento:

$\frac{δ(x)}{x}=0.37Reₓ^{1/5} \ \ \ \ \ δ(x) \approx δₜ(x)$

"""

# ╔═╡ 8ba59a86-3263-4f5e-8825-e72c096f83bd
md"""En el material practico del curso tambien se cuentan con formulaciones para calcular el número de Nusselt local en la placa plana, en regimenes laminar y turbulento.

Laminar:

$\frac{h(x)L}{k}=Nu(x)=0.334*Reₓ^{1/2}Pr^{1/3}$

Turbulento:

$\frac{h(x)L}{k}=Nu(x)=0.0296Reₓ^{4/5}Pr^{1/3}$

"""

# ╔═╡ e0368060-f709-4c49-bcab-7cfc0343c912
md"""Graficando en la plana definida, se obtiene:"""

# ╔═╡ b7f596c7-4bce-493a-8359-297797233f5b
md"""Largo de la placa $L$ [$m$]:"""

# ╔═╡ d8ca76b4-7289-4f9e-a838-34cc009a3a7b
@bind L Slider(0.1:0.1:2.0, default = 1, show_value = true)

# ╔═╡ ca197510-73c9-4629-b1f1-55d603c9a00c
pared = Wall(L)

# ╔═╡ 72275dc6-518d-4574-a5de-d9a584a646b5
begin
hₚ = trunc(h_conv(v,pared,air,Tₛ), digits=2);
md"$hₚ W/m²K"
end

# ╔═╡ 48416af6-5f8a-4bbe-b949-84c0f80c163f
md""" ### Cilindro """

# ╔═╡ b5741bdd-e14c-4e79-adeb-2c50d8626ebf
Show(MIME"image/png"(),read("cilindro.png"))

# ╔═╡ 90b8271b-8878-4341-a80f-3c09e40f5348
md"""Diametro del cilindro $D \ [m]$"""

# ╔═╡ fc57526a-180d-40a3-aa8f-53d7f5ddbccf
@bind Dᵪ Slider(0.05:0.01:0.35, default = 0.2, show_value = true)

# ╔═╡ a2088b4e-e7a2-431c-aba0-51ef82b4f6b6
md"""Ángulo de flujo $θ$ en º"""

# ╔═╡ 3a4a0463-c9dc-48a4-b90c-44fc82765a4f
@bind θ Slider(20:5:90, default = 90, show_value = true)

# ╔═╡ 703405b9-b59d-4bf8-baad-71a9d36b0fa2
cilindro = Cylinder(Dᵪ,φ =θ)

# ╔═╡ 288ad0f2-ba4c-472b-9a75-8ffcb2f5b895
md"""El coeficiente de intercambio de calor por convección resulta:"""

# ╔═╡ 9025afb7-6c89-4fb1-84eb-8c9dc084ceb8
hᵪ = trunc(h_conv(v,cilindro,air,T), digits = 2)

# ╔═╡ 458ddb7a-a58f-4d86-951e-a10b1af2defd
md""" ### Banco de tubos """

# ╔═╡ f20c7012-b898-4f66-9a7d-02952afeceb9
Show(MIME"image/png"(),read("banco.png"))

# ╔═╡ cc37e836-ca1f-4fef-8b37-2e936c302205
md"""Diametro del banco $D \ [m]$"""

# ╔═╡ 975cabe8-4fe8-4ae4-baec-01d4410fec8f
@bind Dᵦ Slider(0.01:0.001:0.050, default = 0.020, show_value = true)

# ╔═╡ 7eb312bf-877c-4fcf-81f3-82f09578e1dc
md"""Separación de tubos Sₜ (n veces diametro)"""

# ╔═╡ ba5a26bd-0ecb-4f9a-a85e-6bc00a50e8ff
@bind nₜ Slider(1.5:0.1:5, default = 2, show_value = true)

# ╔═╡ fe33fb9d-3dc6-4d92-af2c-5e833cdaebf8
Sₜ = nₜ*Dᵦ

# ╔═╡ 60e2affd-3be5-4c10-9ea7-5b172e59476d
md"""Separación de lineas de tubos $Sₗ$ (n veces diametro)"""

# ╔═╡ 2fa30b4d-f638-4167-b268-e8b4cc530c34
@bind nₗ Slider(1.5:0.1:5, default = 2, show_value = true)

# ╔═╡ 291708f5-ce75-4f2d-aec6-e85761180334
Sₗ = nₗ*Dᵦ

# ╔═╡ 7ffecefb-cd94-4e37-b642-6e1ca70bb6bd
md""" Cantidad de lineas de tubos $Nₗ$"""

# ╔═╡ 96d3c8d8-0529-46fd-9fd6-84630c2ff0c7
@bind Nₗ Slider(2:20, default = 10, show_value = true)

# ╔═╡ 593f61a1-6808-4c9d-a6c2-ce70348e4dd9
banco = Ilpipearray(Dᵦ,Sₜ,Sₗ,Nₗ)

# ╔═╡ 0c45cbd9-414a-4f1d-9b00-01b1b7dfac8d
md""" En este caso la velocidad máxima sería:"""

# ╔═╡ 10e5641f-9391-46ca-b65f-b063b85dcdc1
V = trunc(char_speed(banco,v), digits = 2)

# ╔═╡ a0367717-c69e-4b44-bbc4-fd83d096b55b
md"""El coeficiente de intercambio de calor por convección resulta:"""

# ╔═╡ 332a5915-2244-4357-aeb7-24efeb61ccb3
hᵦ = trunc(h_conv(v,banco,air,T), digits = 1)

# ╔═╡ Cell order:
# ╟─fb5fd8bb-cbf2-4df7-b982-10cada4dc231
# ╟─94211d49-15b3-4e96-9134-aa39e77c1743
# ╠═4be4ba4a-2bdf-4dd1-8f80-36912a5361eb
# ╠═70a372cf-d9f0-4e12-9a1a-4c7638143e79
# ╟─dd51a900-6c85-11ed-12f3-e195f1415dc3
# ╟─0873aec3-5c1e-435c-a965-eb74ddc3c551
# ╟─bb14fae8-7e44-41ca-8a2e-5189041dab08
# ╟─7c22d65d-e3d9-41c5-9761-5d77ae33e5c2
# ╟─70e784b2-4858-4241-95a2-8eab32618922
# ╟─49e8ae4b-d68c-418b-b4f4-ae5f56877c75
# ╟─24a105fd-4ae9-4a17-b8bc-5510021a85b2
# ╟─ae77ceff-e972-414a-b359-8fbdcb3c48e7
# ╟─98154d1d-e0d1-400b-8d23-ab344dc8093a
# ╟─49f52775-42bc-4c77-9ad4-3ab50b9da45b
# ╟─a341496c-8469-461e-a828-66746c622937
# ╟─d5ffff65-56b2-4bda-b34c-e593c065d3ee
# ╟─db33c58b-5987-49c7-b3c9-68a0a1e600f6
# ╟─fbd6c1ff-fd43-4dc5-b19b-acb485620a48
# ╟─ac37cb80-c00c-4261-a660-988b9135f178
# ╟─e809c5ba-0d68-498c-b367-7f2e1f20e6df
# ╟─f09ff995-b136-4f3b-9656-c0182a416b85
# ╟─62b260a4-07fa-4fd3-8a0e-491936815366
# ╟─dd328cf6-b219-4a7f-874e-d66b1a87f6c3
# ╟─f2c4cea9-15ca-4707-adb2-5941ef976945
# ╠═667d4720-a015-41aa-9f1b-b628da7cfb73
# ╠═4a3f428e-a326-4b0d-b9fd-5c0d377f8088
# ╟─0b01b523-56f1-4663-92b2-e1ddc481aa93
# ╟─3f425661-daab-4d08-963d-e98d8abf092c
# ╠═af8579a4-f284-40ed-8782-dd8064b86cdd
# ╠═1a999f12-d7cd-4463-8864-34a8367ff92c
# ╟─2cd928c7-3b9f-4bc1-9c68-a23af7a8f4d1
# ╟─8ba59a86-3263-4f5e-8825-e72c096f83bd
# ╟─e0368060-f709-4c49-bcab-7cfc0343c912
# ╟─b7f596c7-4bce-493a-8359-297797233f5b
# ╟─ca197510-73c9-4629-b1f1-55d603c9a00c
# ╟─d8ca76b4-7289-4f9e-a838-34cc009a3a7b
# ╟─72275dc6-518d-4574-a5de-d9a584a646b5
# ╟─48416af6-5f8a-4bbe-b949-84c0f80c163f
# ╟─b5741bdd-e14c-4e79-adeb-2c50d8626ebf
# ╟─90b8271b-8878-4341-a80f-3c09e40f5348
# ╟─fc57526a-180d-40a3-aa8f-53d7f5ddbccf
# ╟─a2088b4e-e7a2-431c-aba0-51ef82b4f6b6
# ╟─3a4a0463-c9dc-48a4-b90c-44fc82765a4f
# ╟─703405b9-b59d-4bf8-baad-71a9d36b0fa2
# ╟─288ad0f2-ba4c-472b-9a75-8ffcb2f5b895
# ╟─9025afb7-6c89-4fb1-84eb-8c9dc084ceb8
# ╟─458ddb7a-a58f-4d86-951e-a10b1af2defd
# ╟─f20c7012-b898-4f66-9a7d-02952afeceb9
# ╟─cc37e836-ca1f-4fef-8b37-2e936c302205
# ╟─975cabe8-4fe8-4ae4-baec-01d4410fec8f
# ╟─7eb312bf-877c-4fcf-81f3-82f09578e1dc
# ╟─ba5a26bd-0ecb-4f9a-a85e-6bc00a50e8ff
# ╟─fe33fb9d-3dc6-4d92-af2c-5e833cdaebf8
# ╟─60e2affd-3be5-4c10-9ea7-5b172e59476d
# ╟─2fa30b4d-f638-4167-b268-e8b4cc530c34
# ╟─291708f5-ce75-4f2d-aec6-e85761180334
# ╟─7ffecefb-cd94-4e37-b642-6e1ca70bb6bd
# ╟─96d3c8d8-0529-46fd-9fd6-84630c2ff0c7
# ╟─593f61a1-6808-4c9d-a6c2-ce70348e4dd9
# ╟─0c45cbd9-414a-4f1d-9b00-01b1b7dfac8d
# ╟─10e5641f-9391-46ca-b65f-b063b85dcdc1
# ╟─a0367717-c69e-4b44-bbc4-fd83d096b55b
# ╟─332a5915-2244-4357-aeb7-24efeb61ccb3
