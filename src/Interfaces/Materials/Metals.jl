#########################################
# Diccionario de propiedades de metales #
#########################################

# Incluye, AISI 1010, Cobre puro



# Conductividad de metales en W/mk
kₘ = Dict();

# Calor específico metales en kJ/kgK
C = Dict();

# Temperaturas de evaluación de props en K
Tₘₑₜ = Dict();

# Densidad en kg/m³
ρₘ = Dict();

# Propiedades en función de la temperatura; la primera entrada del diccionario indica el material, la segunda la temperatura en K

# Cobre puro

kₘ["Cu",100] = 482; kₘ["Cu",200] = 413; kₘ["Cu",300] = 401; kₘ["Cu",400] = 393; kₘ["Cu",600] = 379; kₘ["Cu",800] = 366; kₘ["Cu",1000] = 352; kₘ["Cu",1200] = 339;
C["Cu",100] = 0.252; C["Cu",200] = 0.356; C["Cu",300] = 0.385; C["Cu",400] = 0.397; C["Cu",600] = 0.417; C["Cu",800] = 0.433; C["Cu",1000] = 0.451; C["Cu",1200] = 0.480;
Tₘₑₜ["Cu"] = [100,200,300,400,600,800,1000,1200];
ρₘ["Cu"] = 8933;

# AISI 1010

kₘ["AISI1010",300] = 63.9; kₘ["AISI1010",400] = 58.7; kₘ["AISI1010",600] = 48.8; kₘ["AISI1010",800] = 39.2; kₘ["AISI1010",1000] = 31.3;
C["AISI1010",300] = 0.434; C["AISI1010",400] = 0.487; C["AISI1010",600] = 0.559; C["AISI1010",800] = 0.685; C["AISI1010",1000] = 1.168;
Tₘₑₜ["AISI1010"] = [300,400,600,800,1000];
ρₘ["AISI1010"] = 7832;