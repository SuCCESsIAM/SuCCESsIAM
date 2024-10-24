
***************************************************************************************************
*
*   Temporary fixes, technologies etc.
*


* Temporary processes to provide wood and scrap materials before the material sector is completed:
set     PROCESS / 
TEMP_RecyPaper
TEMP_SteelScrap
/;

set TEMP_TECH(P)/
TEMP_RecyPaper
TEMP_SteelScrap
/;


* Lifetimes, source: 
Parameter data_TEMP_lifetime(P) /
TEMP_RecyPaper    9999
TEMP_SteelScrap   9999
/;


Parameter data_TEMP_varcost(p) /
TEMP_RecyPaper    10
TEMP_SteelScrap   10
/;

* Process output
Parameter data_TEMP_output(p,c) /
TEMP_RecyPaper     .  ScrapPaper   1   
TEMP_SteelScrap    .  ScrapSteel  1
/;

* Availability factor
Parameter data_TEMP_availability(P)/
TEMP_RecyPaper        1
TEMP_SteelScrap       1
/;

* Capacity factor
Parameter data_TEMP_capacityfactor(P)/
TEMP_RecyPaper         1
TEMP_SteelScrap        1
/;

* Max 40% steel from scrap:
ActivityAnnualByMode.UP(r,'TEMP_SteelScrap',mdfl,t) =  0.4 * data_demand(t,'steel');



* Temporary CCS_CO2 storage technologys:
set     PROCESS / TEMP_CCS_Storage /;
set TEMP_TECH(P)/ TEMP_CCS_Storage /;

Parameter data_TEMP_varcost(p)          / TEMP_CCS_Storage             50 /;
Parameter data_TEMP_input(p,c)          / TEMP_CCS_Storage . CO2_CCS    1 /;
Parameter data_TEMP_availability(P)     / TEMP_CCS_Storage              1 /;
Parameter data_TEMP_capacityfactor(P)   / TEMP_CCS_Storage              1 /;
Parameter data_TEMP_lifetime(P)         / TEMP_CCS_Storage           9999 /;



* Temporary processes to provide wood and scrap materials before the material sector is completed:
set     PROCESS / TEMP_PlasticCO2Sink /;
set TEMP_TECH(P)/ TEMP_PlasticCO2Sink /;

* Assume 80% carbon content and 70% of the carbon is retained permanently in solid form: 0.8*0.7*44/12 = 2.05 tCO2/t plastic
Parameter data_TEMP_emission(p,e) / TEMP_PlasticCO2Sink . CO2FFI    -2.05 /;

Parameter data_TEMP_availability(P)     / TEMP_PlasticCO2Sink       1 /;
Parameter data_TEMP_capacityfactor(P)   / TEMP_PlasticCO2Sink       1 /;
Parameter data_TEMP_lifetime(P)         / TEMP_PlasticCO2Sink       9999 /;


Equation EQ_TEMP_PlasticCO2Sink(r,t,mdfl);
EQ_TEMP_PlasticCO2Sink(r,t,mdfl).. ActivityAnnualByMode(r,'TEMP_PlasticCO2Sink',mdfl,t) =E= OutputAnnual(r,'ThermoPlst',t) + OutputAnnual(r,'ThermoSets',t);


***************************************************************************************************
*
*   Assign input data to techs 
*

OperationalLife(r,p)$TEMP_TECH(P) = data_TEMP_lifetime(P);
VariableCost(r,p,mdfl,t)$(TEMP_TECH(P) and data_TEMP_varcost(p)) = data_TEMP_varcost(P);

AvailabilityFactor(r,p,t)$TEMP_TECH(P) = data_TEMP_availability(P);
CapacityFactor(r,p,l,t)$TEMP_TECH(P) = data_TEMP_capacityfactor(P);

CapacityToActivityUnit(r,p)$TEMP_TECH(P) = 1;

InputActivityRatio(r,p,c,mdfl,t)$(TEMP_TECH(P) and data_TEMP_input(p,c)) = data_TEMP_input(p,c);
OutputActivityRatio(r,p,c,mdfl,t)$(TEMP_TECH(P) and data_TEMP_output(p,c)) = data_TEMP_output(p,c);

EmissionActivityRatio(r,p,e,mdfl,t)$(TEMP_TECH(P) and data_TEMP_emission(p,e)) = data_TEMP_emission(p,e);


