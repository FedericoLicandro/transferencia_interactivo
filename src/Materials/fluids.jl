###############################################################
# Diccionario de propiedades de fluidos a presión atmosferica #
###############################################################

# Incluye, Aire, Agua

export kₗ, νₗ, Pr, Tₗᵤ, β

# Conductividad de fluidos en W/mk
"Dictionary containig conductivity of fluids"
kₗ = Dict();

# Viscocidad cinemática de fluidos en m²/s
"Dictionary containig cinematic viscocity of fluids"
νₗ = Dict();

# Número de Prandlt
"Dictionary containig Prandlt number of fluids"
Pr = Dict();

# Temperaturas de evaluación de props en K
"Dictionary containig temperature range of fluids properties"
Tₗᵤ = Dict();

# Coef β en 1/K
"Dictionary containig volumétrico coefficient of thermal expansion of fluids "
βₗ = Dict();
"Dictionary containing fluid names"
nameₗ = Dict();
# Propiedades en función de la temperatura; la primera entrada del diccionario indica el material, la segunda la temperatura en K

# Aire

kₗ["air",100] = 0.00934; kₗ["air",150] = 0.0138; kₗ["air",200]  = 0.0181; kₗ["air",250] = 0.0223; kₗ["air",300] = 0.0263; kₗ["air",350] = 0.0300; kₗ["air",400] = 0.0338; kₗ["air",450] = 0.0373;
kₗ["air",500] = 0.0407;  kₗ["air",550] = 0.0439; kₗ["air",600]  = 0.0469; kₗ["air",650] = 0.0497; kₗ["air",700] = 0.0524; kₗ["air",750] = 0.0549; kₗ["air",800] = 0.0573; kₗ["air",850] = 0.0596;
kₗ["air",900] = 0.0620;  kₗ["air",950] = 0.0643; kₗ["air",1000] = 0.0667;

νₗ["air",100] = 2.000*10^-6; νₗ["air",150] = 4.426*10^-6; νₗ["air",200]  = 7.590*10^-6; νₗ["air",250] = 11.44*10^-6; νₗ["air",300] = 15.89*10^-6; νₗ["air",350] = 20.92*10^-6; νₗ["air",400] = 26.41*10^-6; νₗ["air",450] = 32.39*10^-6;
νₗ["air",500] = 38.79*10^-6; νₗ["air",550] = 45.57*10^-6; νₗ["air",600]  = 52.69*10^-6; νₗ["air",650] = 60.21*10^-6; νₗ["air",700] = 68.10*10^-6; νₗ["air",750] = 76.37*10^-6; νₗ["air",800] = 84.93*10^-6; νₗ["air",850] = 93.80*10^-6;
νₗ["air",900] = 102.9*10^-6; νₗ["air",950] = 112.2*10^-6; νₗ["air",1000] = 121.9*10^-6;

Pr["air",100] = 0.786; Pr["air",150] = 0.758; Pr["air",200]  = 0.737; Pr["air",250] = 0.720; Pr["air",300] = 0.707; Pr["air",350] = 0.700; Pr["air",400] = 0.690; Pr["air",450] = 0.686;
Pr["air",500] = 0.684; Pr["air",550] = 0.683; Pr["air",600]  = 0.685; Pr["air",650] = 0.690; Pr["air",700] = 0.695; Pr["air",750] = 0.702; Pr["air",800] = 0.709; Pr["air",850] = 0.716;
Pr["air",900] = 0.720; Pr["air",950] = 0.723; Pr["air",1000] = 0.726;

βₗ["air"] = "gas";

Tₗᵤ["air"] = 100:50:1000;

nameₗ["air"] = "Aire"


# Agua

kₗ["agua",273.15] = 0.569; kₗ["agua",280] = 0.582; kₗ["agua",290]     = 0.598; kₗ["agua",300] = 0.613; kₗ["agua",310] = 0.628; kₗ["agua",320] = 0.640; kₗ["agua",330] = 0.650; kₗ["agua",340] = 0.660;
kₗ["agua",350]    = 0.668; kₗ["agua",360] = 0.674; kₗ["agua",373.15]  = 0.680; 

νₗ["agua",273.15] = 1.000*175.0*10^-8; νₗ["agua",280] = 1.000*142.2*10^-8; νₗ["agua",290]     = 1.001*108.0*10^-8; νₗ["agua",300] = 1.003*855*10^-9; νₗ["agua",310] = 1.007*695*10^-9; νₗ["agua",320] = 1.011*577*10^-9; νₗ["agua",330] = 1.018*489*10^-9; νₗ["agua",340] = 1.021*420*10^-9;
νₗ["agua",350]    = 1.027*365.0*10^-9; νₗ["agua",360] = 1.034*324.0*10^-9; νₗ["agua",373.15]  = 1.044*279.0*10^-9;

Pr["agua",273.15] = 12.99; Pr["agua",280] = 10.26; Pr["agua",290]     = 7.560; Pr["agua",300] = 5.830; Pr["agua",310] = 4.620; Pr["agua",320] = 3.770; Pr["agua",330] = 3.150; Pr["agua",340] = 2.660;
Pr["agua",350]    = 2.290; Pr["agua",360] = 2.020; Pr["agua",373.15]  = 1.760; 

Tₗᵤ["agua"] = [273.15,280,290,300,310,320,330,340,350,360,373.15];

βₗ["agua"] = "liquid";

βₗ["agua",273.15] = -68.05*10^-6; βₗ["agua",280] = 46.04*10^-6; βₗ["agua",290]     = 174.0*10^-6; βₗ["agua",300] = 276.1*10^-6; βₗ["agua",310] = 361.9*10^-6; βₗ["agua",320] = 436.7*10^-6; βₗ["agua",330] = 504.0*10^-6; βₗ["agua",340] = 566.0*10^-6;
βₗ["agua",350]    =  624.2*10^-6; βₗ["agua",360] = 697.9*10^-6; βₗ["agua",373.15]  = 750.1*10^-6; 

nameₗ["agua"] = "Agua"