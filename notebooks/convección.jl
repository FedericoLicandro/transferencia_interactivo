### A Pluto.jl notebook ###
# v0.19.16

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
using Interactive_HT

# ╔═╡ dd51a900-6c85-11ed-12f3-e195f1415dc3
md"""### Convección """

# ╔═╡ bb14fae8-7e44-41ca-8a2e-5189041dab08
md"""Notebook interactivo para calculo de formulas de convección en aire"""

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

# ╔═╡ ac37cb80-c00c-4261-a660-988b9135f178
md""" ### Placa plana"""

# ╔═╡ 0b01b523-56f1-4663-92b2-e1ddc481aa93
Show(MIME"image/png"(),read("paredplana.png"))

# ╔═╡ b7f596c7-4bce-493a-8359-297797233f5b
md"""Largo de la placa $L$ [$m$]:"""

# ╔═╡ d8ca76b4-7289-4f9e-a838-34cc009a3a7b
@bind L Slider(0.1:0.1:2.0, default = 1, show_value = true)

# ╔═╡ ca197510-73c9-4629-b1f1-55d603c9a00c
pared = Wall(L)

# ╔═╡ 3f425661-daab-4d08-963d-e98d8abf092c
md"""Temperatura de superficie $Tₛ \ [K]$"""

# ╔═╡ af8579a4-f284-40ed-8782-dd8064b86cdd
@bind Tₛ Slider(200:10:600, default = 300, show_value = true)

# ╔═╡ 2cd928c7-3b9f-4bc1-9c68-a23af7a8f4d1
md"""El coeficiente de intercambio de calor por convección resulta:"""

# ╔═╡ 72275dc6-518d-4574-a5de-d9a584a646b5
hₚ = trunc(h_conv(v,pared,air,T,Tₛ,Forced()), digits=2)

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
hᵪ = trunc(h_conv(v,cilindro,air,T,Forced()), digits = 2)

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
banco = Il_pipe_array(Dᵦ,Sₜ,Sₗ,Nₗ)

# ╔═╡ 0c45cbd9-414a-4f1d-9b00-01b1b7dfac8d
md""" En este caso la velocidad máxima sería:"""

# ╔═╡ 10e5641f-9391-46ca-b65f-b063b85dcdc1
V = trunc(char_speed(banco,v), digits = 2)

# ╔═╡ a0367717-c69e-4b44-bbc4-fd83d096b55b
md"""El coeficiente de intercambio de calor por convección resulta:"""

# ╔═╡ 332a5915-2244-4357-aeb7-24efeb61ccb3
hᵦ = trunc(h_conv(v,banco,air,T,Forced()), digits = 1)

# ╔═╡ Cell order:
# ╟─fb5fd8bb-cbf2-4df7-b982-10cada4dc231
# ╟─94211d49-15b3-4e96-9134-aa39e77c1743
# ╟─4be4ba4a-2bdf-4dd1-8f80-36912a5361eb
# ╟─70a372cf-d9f0-4e12-9a1a-4c7638143e79
# ╟─dd51a900-6c85-11ed-12f3-e195f1415dc3
# ╟─bb14fae8-7e44-41ca-8a2e-5189041dab08
# ╟─62b260a4-07fa-4fd3-8a0e-491936815366
# ╟─dd328cf6-b219-4a7f-874e-d66b1a87f6c3
# ╟─f2c4cea9-15ca-4707-adb2-5941ef976945
# ╟─667d4720-a015-41aa-9f1b-b628da7cfb73
# ╟─4a3f428e-a326-4b0d-b9fd-5c0d377f8088
# ╟─ac37cb80-c00c-4261-a660-988b9135f178
# ╟─0b01b523-56f1-4663-92b2-e1ddc481aa93
# ╟─b7f596c7-4bce-493a-8359-297797233f5b
# ╟─d8ca76b4-7289-4f9e-a838-34cc009a3a7b
# ╟─ca197510-73c9-4629-b1f1-55d603c9a00c
# ╟─3f425661-daab-4d08-963d-e98d8abf092c
# ╟─af8579a4-f284-40ed-8782-dd8064b86cdd
# ╟─2cd928c7-3b9f-4bc1-9c68-a23af7a8f4d1
# ╟─72275dc6-518d-4574-a5de-d9a584a646b5
# ╟─48416af6-5f8a-4bbe-b949-84c0f80c163f
# ╟─b5741bdd-e14c-4e79-adeb-2c50d8626ebf
# ╟─90b8271b-8878-4341-a80f-3c09e40f5348
# ╠═fc57526a-180d-40a3-aa8f-53d7f5ddbccf
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
