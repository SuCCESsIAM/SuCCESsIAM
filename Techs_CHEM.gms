

***************************************************************************************************
*
*   Input data - plastic and other chemical production 
*

set     PROCESS / 
CHEM_ThermoPlst
CHEM_ThermoSets
CHEM_SolventsEtc
CHEM_OtherPetro
CHEM_NitroFertil
CHEM_OtherChemDmd
/;

set CHEM_TECH(P)/
CHEM_ThermoPlst
CHEM_ThermoSets
CHEM_SolventsEtc
CHEM_OtherPetro
CHEM_NitroFertil
CHEM_OtherChemDmd
/;


* Investment cost ($/t output):
table data_CHEM_capcost_t(P,t) "Investment cost ($/t output) over the years 2020-2100"
              2020      2030      2040      2050      2060      2070      2080      2090      2100
;

* Lifetimes, source: 
Parameter data_CHEM_lifetime(P) /
CHEM_ThermoPlst    40
CHEM_ThermoSets    40
CHEM_SolventsEtc   40
CHEM_OtherPetro    40
CHEM_NitroFertil   40
CHEM_OtherChemDmd  40
/;

* Process inputs
* Source: Levi and Cullen (2018)
table data_CHEM_input(p, c)
                     ETHYLENE  PROPYLENE   C4OLEFINS      BTX       AMMONIA     METHANOL   OTHERCHEM     ELEC    STEA
CHEM_ThermoPlst      0.436       0.232       0.011       0.104       0.006       0.009       0.202       4.0      0.6
CHEM_ThermoSets      0.058       0.105       0.052       0.223       0.052       0.075       0.435       8.6     11.3
CHEM_SolventsEtc     0.000       0.028       0.383       0.104       0.060       0.143       0.282       5.0      4.0
CHEM_OtherPetro      0.099       0.092       0.192       0.118       0.162       0.176       0.160       5.0      4.0
CHEM_NitroFertil     0.000       0.000       0.000       0.000       0.367       0.000       0.633       0.6      0.0
CHEM_OtherChemDmd    0.019       0.012       0.012       0.035       0.045       0.016       0.861       1.3      0.6
;


* Process output
Parameter data_CHEM_output(p,c);
data_CHEM_output('CHEM_ThermoPlst','ThermoPlst') = 1;
data_CHEM_output('CHEM_ThermoSets','ThermoSets') = 1;
data_CHEM_output('CHEM_SolventsEtc','SolventsEtc') = 1;
data_CHEM_output('CHEM_OtherPetro','OtherPetro') = 1;
data_CHEM_output('CHEM_NitroFertil','NitroFertil') = 1;
data_CHEM_output('CHEM_OtherChemDmd','OthChemDmd') = 1;


* Base year output in Mt/year
* Source: Levi and Cullen (2018), represents year 2013
Parameter data_CHEM_baseyroutput(P)/
CHEM_ThermoPlst     222.2
CHEM_ThermoSets     107.2
CHEM_SolventsEtc    107.3
CHEM_OtherPetro     108.9 
CHEM_NitroFertil    274.7
CHEM_OtherChemDmd   286.8
/;


* Availability factor
Parameter data_CHEM_availability(P)/
CHEM_ThermoPlst     1
CHEM_ThermoSets     1
CHEM_SolventsEtc    1
CHEM_OtherPetro     1
CHEM_NitroFertil    1
CHEM_OtherChemDmd   1
/;

* Capacity factor
Parameter data_CHEM_capacityfactor(P)/
CHEM_ThermoPlst     1
CHEM_ThermoSets     1
CHEM_SolventsEtc    1
CHEM_OtherPetro     1
CHEM_NitroFertil    1
CHEM_OtherChemDmd   1
/;





***************************************************************************************************
*
*   Input data - dummy process to produce 'OTHERCHEM' - a mix of H2O, O2, CO2, H3PO4 etc. (see Levi and Cullen, 2018)
*


set     PROCESS /  CHEM_OTHERCHEM /;
set CHEM_TECH(P)/ CHEM_OTHERCHEM /;

parameter data_CHEM_Output(p,c) /  CHEM_OTHERCHEM . OTHERCHEM     1 /;
Parameter data_CHEM_availability(P)/ CHEM_OTHERCHEM   1 /;
Parameter data_CHEM_capacityfactor(P)/ CHEM_OTHERCHEM   1 /;
Parameter data_CHEM_baseyroutput(P)/ CHEM_OTHERCHEM   1 /;
Parameter data_CHEM_lifetime(P) / CHEM_OTHERCHEM  1000 /;
* Note: this needs a (small) production cost, would be otherwise produced like crazy and drained by the 'commodity sink' process.
Parameter data_CHEM_varcost(P) / CHEM_OTHERCHEM  0.01 /;



***************************************************************************************************
*
*   Input data - Ammonia and Methanol
*   
* Source: IEA Ammonia Technology Roadmap (https://iea.blob.core.windows.net/assets/6ee41bb9-8e81-4b64-8701-2acc064ff6e4/AmmoniaTechnologyRoadmap.pdf)
*

* Ammomia:
* Source: IEA Ammonia Technology Roadmap (https://iea.blob.core.windows.net/assets/6ee41bb9-8e81-4b64-8701-2acc064ff6e4/AmmoniaTechnologyRoadmap.pdf)
*



set     PROCESS / 
CHEM_AmmoniaCoalExisting     
CHEM_AmmoniaGasExisting      
CHEM_AmmoniaGasSMR           
CHEM_AmmoniaGasATR           
CHEM_AmmoniaCoalGasification 
CHEM_AmmoniaGasSMR_CCS       
CHEM_AmmoniaGasATR_CCS       
CHEM_AmmoniaCoalGasif_CCS    
CHEM_AmmoniaElectrolysis     
CHEM_AmmoniaBiomass          
CHEM_AmmoniaPyrolysis        
CHEM_MethanolGasExisting
CHEM_MethanolCoalExisting
CHEM_MethanolBiomass
CHEM_MethanolElectricity
/;

set CHEM_TECH(P)/
CHEM_AmmoniaCoalExisting     
CHEM_AmmoniaGasExisting      
CHEM_AmmoniaGasSMR           
CHEM_AmmoniaGasATR           
CHEM_AmmoniaCoalGasification 
CHEM_AmmoniaGasSMR_CCS       
CHEM_AmmoniaGasATR_CCS       
CHEM_AmmoniaCoalGasif_CCS    
CHEM_AmmoniaElectrolysis     
CHEM_AmmoniaBiomass          
CHEM_AmmoniaPyrolysis
*        
CHEM_MethanolGasExisting
CHEM_MethanolCoalExisting
CHEM_MethanolBiomass
CHEM_MethanolElectricity
/;


table data_CHEM_Input(p,c)
                                NGAS   OILL   COAL   BIOM    ELEC   STEA   CO2_CCS
CHEM_AmmoniaCoalExisting                      36.9           4.1        
CHEM_AmmoniaGasExisting         40.6                         0.4        
CHEM_AmmoniaGasSMR              32.1                         0.3        
CHEM_AmmoniaGasATR              27.9                         1.0        
CHEM_AmmoniaCoalGasification                  33.7           3.7        
CHEM_AmmoniaGasSMR_CCS          32.1                         1.0        
CHEM_AmmoniaGasATR_CCS          27.9                         1.5        
CHEM_AmmoniaCoalGasif_CCS                     33.7           4.9     2.6
CHEM_AmmoniaElectrolysis                                     36         
CHEM_AmmoniaBiomass                                  35.1    1.4        
CHEM_AmmoniaPyrolysis           35.1                         8.4        
*
CHEM_MethanolGasExisting        43.0                         1.0       
CHEM_MethanolCoalExisting                     43.0           4.0       
CHEM_MethanolBiomass                                 43.0    4.0       
CHEM_MethanolElectricity                                    39.6             1.4 
;


parameter data_CHEM_Output(p,c) /
CHEM_AmmoniaCoalExisting      . Ammonia    1
CHEM_AmmoniaGasExisting       . Ammonia    1
CHEM_AmmoniaGasSMR            . Ammonia    1
CHEM_AmmoniaGasATR            . Ammonia    1
CHEM_AmmoniaCoalGasification  . Ammonia    1
CHEM_AmmoniaGasSMR_CCS        . Ammonia    1
CHEM_AmmoniaGasATR_CCS        . Ammonia    1
CHEM_AmmoniaCoalGasif_CCS     . Ammonia    1
CHEM_AmmoniaElectrolysis      . Ammonia    1
CHEM_AmmoniaBiomass           . Ammonia    1
CHEM_AmmoniaPyrolysis         . Ammonia    1
*
CHEM_AmmoniaCoalExisting      . STEA       0 
CHEM_AmmoniaGasExisting       . STEA       0 
CHEM_AmmoniaGasSMR            . STEA     4.8
CHEM_AmmoniaGasATR            . STEA       0 
CHEM_AmmoniaCoalGasification  . STEA     1.3
CHEM_AmmoniaGasSMR_CCS        . STEA     3.1
CHEM_AmmoniaGasATR_CCS        . STEA       0 
CHEM_AmmoniaCoalGasif_CCS     . STEA       0 
CHEM_AmmoniaElectrolysis      . STEA     1.6
CHEM_AmmoniaBiomass           . STEA       0 
CHEM_AmmoniaPyrolysis         . STEA     1.6
*
CHEM_MethanolGasExisting      . Methanol   1
CHEM_MethanolCoalExisting     . Methanol   1
CHEM_MethanolBiomass          . Methanol   1
CHEM_MethanolElectricity      . Methanol   1
/;


Parameter data_CHEM_emissions(P,E)/
CHEM_AmmoniaCoalExisting      . CO2FFI    3.5
CHEM_AmmoniaGasExisting       . CO2FFI    2.3
CHEM_AmmoniaGasSMR            . CO2FFI    1.8
CHEM_AmmoniaGasATR            . CO2FFI    1.6
CHEM_AmmoniaCoalGasification  . CO2FFI    3.2
CHEM_AmmoniaGasSMR_CCS        . CO2FFI    0.1
CHEM_AmmoniaGasATR_CCS        . CO2FFI    0.1
CHEM_AmmoniaCoalGasif_CCS     . CO2FFI    0.2
CHEM_AmmoniaElectrolysis      . CO2FFI    0  
CHEM_AmmoniaBiomass           . CO2FFI    0  
CHEM_AmmoniaPyrolysis         . CO2FFI    0  
*
CHEM_MethanolGasExisting      . CO2FFI    1.9
CHEM_MethanolCoalExisting     . CO2FFI    3.2
CHEM_MethanolBiomass          . CO2FFI    0
CHEM_MethanolElectricity      . CO2FFI    0
/;


* Investment cost ($/t output):
Parameter data_CHEM_capcost(P) "Investment cost ($/t output)"/
CHEM_AmmoniaCoalExisting        350
CHEM_AmmoniaGasExisting         190
CHEM_AmmoniaGasSMR              190
CHEM_AmmoniaGasATR              190
CHEM_AmmoniaCoalGasification    350
CHEM_AmmoniaGasSMR_CCS          220
CHEM_AmmoniaGasATR_CCS          220
CHEM_AmmoniaCoalGasif_CCS       380
CHEM_AmmoniaElectrolysis        220
CHEM_AmmoniaBiomass             470
CHEM_AmmoniaPyrolysis           190
*        
*CHEM_MethanolGasExisting
*CHEM_MethanolCoalExisting
*CHEM_MethanolBiomass
*CHEM_MethanolElectricity
/;

Parameter data_CHEM_baseyroutput(P)/
CHEM_AmmoniaCoalExisting         48
CHEM_AmmoniaGasExisting          133
*
CHEM_MethanolGasExisting         1
CHEM_MethanolCoalExisting        1
/;


Parameter data_CHEM_availability(P)/
CHEM_AmmoniaCoalExisting         1
CHEM_AmmoniaGasExisting          1
CHEM_AmmoniaGasSMR               1
CHEM_AmmoniaGasATR               1
CHEM_AmmoniaCoalGasification     1
CHEM_AmmoniaGasSMR_CCS           1
CHEM_AmmoniaGasATR_CCS           1
CHEM_AmmoniaCoalGasif_CCS        1
CHEM_AmmoniaElectrolysis         1
CHEM_AmmoniaBiomass              1
CHEM_AmmoniaPyrolysis            1
*
CHEM_MethanolGasExisting         1
CHEM_MethanolCoalExisting        1
CHEM_MethanolBiomass             1
CHEM_MethanolElectricity         1
/;

* Capacity factor
Parameter data_CHEM_capacityfactor(P)/
CHEM_AmmoniaCoalExisting         1
CHEM_AmmoniaGasExisting          1
CHEM_AmmoniaGasSMR               1
CHEM_AmmoniaGasATR               1
CHEM_AmmoniaCoalGasification     1
CHEM_AmmoniaGasSMR_CCS           1
CHEM_AmmoniaGasATR_CCS           1
CHEM_AmmoniaCoalGasif_CCS        1
CHEM_AmmoniaElectrolysis         1
CHEM_AmmoniaBiomass              1
CHEM_AmmoniaPyrolysis            1
*
CHEM_MethanolGasExisting         1
CHEM_MethanolCoalExisting        1
CHEM_MethanolBiomass             1
CHEM_MethanolElectricity         1
/;


Parameter data_CHEM_lifetime(P) /
CHEM_AmmoniaCoalExisting         30
CHEM_AmmoniaGasExisting          30
CHEM_AmmoniaGasSMR               30
CHEM_AmmoniaGasATR               30
CHEM_AmmoniaCoalGasification     30
CHEM_AmmoniaGasSMR_CCS           30
CHEM_AmmoniaGasATR_CCS           30
CHEM_AmmoniaCoalGasif_CCS        30
CHEM_AmmoniaElectrolysis         30
CHEM_AmmoniaBiomass              30
CHEM_AmmoniaPyrolysis            30
*
CHEM_MethanolGasExisting         30
CHEM_MethanolCoalExisting        30
CHEM_MethanolBiomass             30
CHEM_MethanolElectricity         30
/;


Parameter data_CHEM_startyear(P) /
CHEM_AmmoniaGasSMR               2030
CHEM_AmmoniaGasATR               2030
CHEM_AmmoniaCoalGasification     2030
CHEM_AmmoniaGasSMR_CCS           2030
CHEM_AmmoniaGasATR_CCS           2030
CHEM_AmmoniaCoalGasif_CCS        2030
CHEM_AmmoniaElectrolysis         2030
CHEM_AmmoniaBiomass              2030
CHEM_AmmoniaPyrolysis            2030
*
CHEM_MethanolBiomass             2030
CHEM_MethanolElectricity         2030
/;




***************************************************************************************************
*
*   Assign input data to techs 
*


OperationalLife(r,p)$CHEM_TECH(P) = data_CHEM_lifetime(P);
CapitalCost(r,p,t)$(CHEM_TECH(P) and data_CHEM_capcost_t(p,t)) = data_CHEM_capcost_t(P,t);
CapitalCost(r,p,t)$(CHEM_TECH(P) and data_CHEM_capcost(p)) = data_CHEM_capcost(P);
VariableCost(r,p,m,t)$(CHEM_TECH(P) and data_CHEM_varcost(p)) = data_CHEM_varcost(P);

AvailabilityFactor(r,p,t)$CHEM_TECH(P) = data_CHEM_availability(P);
CapacityFactor(r,p,l,t)$CHEM_TECH(P) = data_CHEM_capacityfactor(P);

CapacityToActivityUnit(r,p)$CHEM_TECH(P) = 1;

InputActivityRatio(r,p,c,mdfl,t)$(CHEM_TECH(P) and data_CHEM_input(p,c)) = data_CHEM_input(p,c);
OutputActivityRatio(r,p,c,mdfl,t)$(CHEM_TECH(P) and data_CHEM_output(p,c)) = data_CHEM_output(p,c);


* Add 5% to each capacity so the system isn't on a knife's edge
CapacityResidual(r,p,t)$CHEM_TECH(P) = data_CHEM_baseyroutput(P) / data_CHEM_availability(P) * 1.05;


*EmissionActivityRatio(r,p,e,mdfl,t)$CHEM_TECH(P) = data_CHEM_emissionfactorCO2(P);

ProcessStartYear(r,p)$(CHEM_TECH(P) and data_CHEM_startyear(P)) = data_CHEM_startyear(P);