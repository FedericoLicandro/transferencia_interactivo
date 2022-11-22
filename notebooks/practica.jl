### A Pluto.jl notebook ###
# v0.19.16

using Markdown
using InteractiveUtils

# ╔═╡ b4dcf993-33f9-42c4-a58d-a8ebfb51f788
import Pkg

# ╔═╡ 288ebdb6-8b03-4286-9afc-ca0b365a5589
Pkg.add("PlutoUI")

# ╔═╡ 23c9d23c-dba2-4ba9-a9d6-bbada4965b35
Pkg.add(url="https://github.com/FedericoLicandro/transferencia_interactivo.git")

# ╔═╡ dbb0dd68-4b78-4c00-a236-30756dd5304c
using PlutoUI

# ╔═╡ 1e06da8a-69e6-11ed-151e-417450c69e90
using Interactive_HT

# ╔═╡ cef2cd71-5527-42f3-9df0-560efd392f37
#Markdown
md""" ### Introducción """

# ╔═╡ 9bf54786-4b32-438c-a996-a00693dfaa3d
#Markdown
md"El objetivo de este block de notas es mostrar una solución numérica de la practica experimental de transferencia de calor en una barra de cobre, realizada en la actividad obligatoria del curso.

Se utiliza el paquete de Julia Interactive_HT, para resolver la ecuación de calor en un cilindro."

# ╔═╡ 0b5cc627-887c-45e4-9b84-e10a1c1aa384
# Markdown

md""" ### Teoría """

# ╔═╡ 7e383c93-07be-4828-81dd-a8646c38b229
# Markdown

md"Se utiliza el metodo numérico de ''elementos finitos'' para resolver la ecuación de calor. El metodo se basa en buscar la solución $u_h$, que proyectada en un espacio de funciones V, minimiza la distancia con la solución real.

Para plantear el metodo de elementos finitos se debe llegar a la formualción ''debil'' de la ecuación diferencial. Se parte del balance de energía al volumen de control Ω (barra de cobre):

$$\frac{dE_{alm}}{dt}=\dot{Q}|_{∂ Ω}+\dot{G}$$

Donde $E_{alm}$ es la energía almacenada, $\dot{Q}|_{∂ Ω}$ es el flujo de calor en el borde del volumen de control y $\dot{G}$ es el calor generado en el volumen de control. Escribiendo los terminos en su forma integral, y en regimen permanente de estado estacionario resulta:

$$-\int_{∂Ω} \dot{q}''.\vec{n}dS = \int_Ω g_0 dV$$

Donde $\dot{q}''$ es el flujo de calor y $g_0$ la generación de calor volumétrica. El flujo de calor se calcula utilizando la ley de Fourier, conociendo además la generación volumétrica $g_0(x,y,z)=f(x,y,z)$:

$$\int_{∂Ω} k \nabla T . \vec{n} dS = \int_Ω f dV$$

Donde $k$ es la conductividad del medio y $T$ el campo de temperaturas. Sea $v$ una función ($v∈V$) y $u$ la solución de la ecuación, es decir $T=u$, la ecuación es analoga a:

$$k\int_{∂Ω} v \nabla u . \vec{n} dS = \int_Ω fv dV  \  \ , \  \  ∀v∈V$$

Es decir, busco el problema es analogo a encontrar $u$, tal que para toda $v∈V$, se cumpla la ecuación de arriba. Usando la regla de la cadena e imponiendo $v|_{∂Ω} = 0$, se obtiene la forma debil de la ecuación del calor en estado estacionario:

$$k\int_{Ω}  \nabla u \nabla v dV  = \int_Ω fv dV$$



"



# ╔═╡ Cell order:
# ╟─cef2cd71-5527-42f3-9df0-560efd392f37
# ╟─9bf54786-4b32-438c-a996-a00693dfaa3d
# ╟─0b5cc627-887c-45e4-9b84-e10a1c1aa384
# ╟─7e383c93-07be-4828-81dd-a8646c38b229
# ╟─288ebdb6-8b03-4286-9afc-ca0b365a5589
# ╟─dbb0dd68-4b78-4c00-a236-30756dd5304c
# ╟─b4dcf993-33f9-42c4-a58d-a8ebfb51f788
# ╟─23c9d23c-dba2-4ba9-a9d6-bbada4965b35
# ╠═1e06da8a-69e6-11ed-151e-417450c69e90
