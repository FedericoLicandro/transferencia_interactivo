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

# ╔═╡ b4dcf993-33f9-42c4-a58d-a8ebfb51f788
import Pkg

# ╔═╡ d5cabce2-dead-4d31-903f-cc592826656d
Pkg.activate("../Project.toml");

# ╔═╡ 08befdd8-8045-43de-b9f7-9bc02b3e9585
using PlutoUI

# ╔═╡ 1e06da8a-69e6-11ed-151e-417450c69e90
using Interactive_HT, Gridap

# ╔═╡ cef2cd71-5527-42f3-9df0-560efd392f37
#Markdown
md""" ### Introducción """

# ╔═╡ 9bf54786-4b32-438c-a996-a00693dfaa3d
#Markdown
md"El objetivo de este block de notas es mostrar una solución numérica de la ecuación de calor en un domino rectangular, con una malla cartesiana uniforme.

Se utiliza el paquete de Julia Interactive_HT, para resolver la ecuación de calor en un cilindro."

# ╔═╡ 0b5cc627-887c-45e4-9b84-e10a1c1aa384
# Markdown

md""" ### Teoría """

# ╔═╡ 7e383c93-07be-4828-81dd-a8646c38b229
# Markdown

md"Se utiliza el metodo numérico de ''elementos finitos'' para resolver la ecuación de calor. El metodo se basa en buscar la solución $T=u_h$, que proyectada en un espacio de funciones V, minimiza la distancia con la solución real. El metodo de elementos finitos escapa el alcanze del curso, si el estudiante está interesado, se recomienda el estudio de métodos numéricos. Siguiendo el desarrollo de elementos finitos la forma débil de la ecuación de calor es:

$$\int_{Ω}  \nabla (k.u) .\nabla v \, dV  = \int_Ω f.v \, dV$$

Donde $u$ es la solución a la ecuación, $v$ pertenece al espacio de funciones $V$ (para mas información estudiar el metodo de elementos finitos), $k$ es la conductividad del material, $Ω$ es el dominio y $f$ el término de generación volumétrica de calor.

El dominio se parte con una malla uniforme (es decir, espaciamiento equidistante entre puntos discretos a evaluar) y se construyen los elementos finitos (triángluos), tomando como vertices 3 puntos de la malla. La ecuación se resuelve para cada uno de los triángulos.

"



# ╔═╡ 068c4fb5-1344-4d94-95f5-12c50d38cd11
md""" ### Implementación """

# ╔═╡ 1762e3bb-21af-404e-867d-0580854e15e6
md""" Lo primero es cargar el paquete Interactive_HT que permite calcular la ecuación de calor, para eso debemos instalarlo: """

# ╔═╡ ac160f0a-4ea0-414f-b5c9-e1339e88bc08
md""" La linea de comando ''<Nombre del paquete>'' permite llamar a las funciones del módulo: """

# ╔═╡ 7b31f583-368b-4611-9798-42bd013c579c
md"""Se define el dominio en el que se va a resolver la ecuación de calor:"""

# ╔═╡ 9357b723-06f8-4302-b9d9-341b9c0f35dc
begin
a = 1 # Largo del rectángulo
b = 1 # Alto del rectángulo
D=RectangularDomain(a,b)
end

# ╔═╡ d1b5d9e6-5da2-4c5d-9f66-54e7076dc4e7
md"""Se define el medio (material) presente en el dominio, en el caso de la solución estacionaria de la ecuación de calor, nos interesa en especifico la conductividad del material:"""

# ╔═╡ b74b37ef-a68c-4c3f-8edc-98fd01ea6d9a
# Conductividad del material k en W/mk
 @bind k Slider(1:401,default =401 , show_value=true)

# ╔═╡ de6dadca-dcfb-4f05-8a54-43f53a80a75e
md""" El material solo lo vamos a definir a partir de la conductividad $k$, ya que es la unica propiedad que nos interesa para la solución"""

# ╔═╡ 0b5a8133-e66b-4beb-8c18-ed0cdf472238
Mat = Metal(1,1,k)

# ╔═╡ ec5eb436-c288-453d-8219-87465e6894a0
md""" Se define el termino de generación de calor $g₀$. Obs: para el notebook se consideran solamente generaciones volumetricas uniforme y constante, pero la generación podria ser función del espacio y del tiempo """

# ╔═╡ f77bd0d8-d2d0-432d-ba22-310cf00a3ab7

@bind g₀ Slider(0:500000, default = 0, show_value=true)



# ╔═╡ 1536eb29-538b-4a8d-ac95-a1d7d05ef109
f(x) = g₀

# ╔═╡ 1c9ebc34-9570-4589-8da8-1aead2b276f8
md"""Se imponenen las siguientes condiciones de borde:

- temperatura lineal, con máximo en $T(0,0)=Tₘₐₓ$ en el oeste.
- Condición adiabática en los bordes sur y este.
- Condición de temperatura igual a $Tₙ = 0ºC$ en el norte 

la siguiente palanca permite modificar $Tₘₐₓ$"""

# ╔═╡ ab84947e-2ecf-42e7-a653-97ba33559f00
@bind Tₘₐₓ Slider(0:100, default = 55, show_value = true)

# ╔═╡ 4c73857f-1798-42fe-9ee3-8ac59b440b2f
begin
g1(x) =	0;
g2(x) = Tₘₐₓ*(b-x[2])/b;
end

# ╔═╡ 17f9e17c-7c11-47fe-ae56-a9f1b2da8a2b
bcN = BCond(g1, "north", Dirichlet())

# ╔═╡ 33fa3211-6796-4f8e-abf8-e4bada0ae4de
bcW = BCond(g2, "west", Dirichlet())

# ╔═╡ ebad8a0d-e0f8-4732-9b81-2bfc462f9359
bcE = BCond(g1, "east", Newmann())

# ╔═╡ 1a350a90-79f0-4c6b-aeea-c015df8d1423
bcS = BCond(g1, "south", Newmann())

# ╔═╡ 776f3e5f-3b50-4636-9beb-b70aecac12ae
md""" Los argumentos finales ''Dirichlet'' y ''Newmann'' indican si la condición de borde es de temperatura impuesta (Dirichlet) o calor impuesto ''Newmann''."""

# ╔═╡ 644b1e9b-8c16-4c63-a0f6-def82c24d1e3
md""" A partir de todos los parametros definidos se plantea un problema a resolver con la ecuación de calor:"""

# ╔═╡ 6e2cae94-d218-4dd2-8558-4ae935ecf3cc
begin
bcA = RectBC(bcN, bcE, bcS, bcW);
hteq = HTproblem(D, Mat , bcA, f);
end

# ╔═╡ 15779fd4-6d0d-4417-8638-9553c800d9d3
md"""usamos la función de Interactive_HT que resuelve la ecuación de calor. Se puede modificar el número de discretizaciones en cada una de las direcciones:"""

# ╔═╡ 0ab9c977-cf67-4579-bd5f-75086652bd26
@bind ndisc Slider([10,20,30,40,50,60,70,80,90,100], default = 40, show_value = true)

# ╔═╡ 3a2f0992-c4b8-4c81-84bc-e5731f4297e4
uₕ = _heateqsolve_stationary(hteq, n=ndisc);

# ╔═╡ 6e29bc20-68ab-46c1-82e2-cf0c95874173
begin
	Ω = uₕ[1];
	T = uₕ[2];
end

# ╔═╡ 5eeb0a11-5ecc-4e49-85c9-a0eb6221c89a
md""" Para visualizar los resultados se necesitan usar otros paquetes:"""

# ╔═╡ Cell order:
# ╟─b4dcf993-33f9-42c4-a58d-a8ebfb51f788
# ╠═d5cabce2-dead-4d31-903f-cc592826656d
# ╟─08befdd8-8045-43de-b9f7-9bc02b3e9585
# ╟─cef2cd71-5527-42f3-9df0-560efd392f37
# ╟─9bf54786-4b32-438c-a996-a00693dfaa3d
# ╟─0b5cc627-887c-45e4-9b84-e10a1c1aa384
# ╟─7e383c93-07be-4828-81dd-a8646c38b229
# ╟─068c4fb5-1344-4d94-95f5-12c50d38cd11
# ╟─1762e3bb-21af-404e-867d-0580854e15e6
# ╟─ac160f0a-4ea0-414f-b5c9-e1339e88bc08
# ╠═1e06da8a-69e6-11ed-151e-417450c69e90
# ╟─7b31f583-368b-4611-9798-42bd013c579c
# ╟─9357b723-06f8-4302-b9d9-341b9c0f35dc
# ╟─d1b5d9e6-5da2-4c5d-9f66-54e7076dc4e7
# ╟─b74b37ef-a68c-4c3f-8edc-98fd01ea6d9a
# ╟─de6dadca-dcfb-4f05-8a54-43f53a80a75e
# ╟─0b5a8133-e66b-4beb-8c18-ed0cdf472238
# ╟─ec5eb436-c288-453d-8219-87465e6894a0
# ╟─f77bd0d8-d2d0-432d-ba22-310cf00a3ab7
# ╟─1536eb29-538b-4a8d-ac95-a1d7d05ef109
# ╟─1c9ebc34-9570-4589-8da8-1aead2b276f8
# ╟─ab84947e-2ecf-42e7-a653-97ba33559f00
# ╟─4c73857f-1798-42fe-9ee3-8ac59b440b2f
# ╟─17f9e17c-7c11-47fe-ae56-a9f1b2da8a2b
# ╟─33fa3211-6796-4f8e-abf8-e4bada0ae4de
# ╟─ebad8a0d-e0f8-4732-9b81-2bfc462f9359
# ╟─1a350a90-79f0-4c6b-aeea-c015df8d1423
# ╟─776f3e5f-3b50-4636-9beb-b70aecac12ae
# ╟─644b1e9b-8c16-4c63-a0f6-def82c24d1e3
# ╟─6e2cae94-d218-4dd2-8558-4ae935ecf3cc
# ╟─15779fd4-6d0d-4417-8638-9553c800d9d3
# ╟─0ab9c977-cf67-4579-bd5f-75086652bd26
# ╠═3a2f0992-c4b8-4c81-84bc-e5731f4297e4
# ╟─6e29bc20-68ab-46c1-82e2-cf0c95874173
# ╟─5eeb0a11-5ecc-4e49-85c9-a0eb6221c89a
