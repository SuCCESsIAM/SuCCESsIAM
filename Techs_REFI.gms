
***************************************************************************************************
*
*   Input data - oil refineries
*

set     PROCESS  / REFI_OilRef /;
set REFI_TECH(P) / REFI_OilRef /;

* Operating modes for oil refineries:
*  - Heavy crude inherent yield,
*  - Low Conversion,
*  - Medium Conversion,
*  - High Complexity/conversion
set m         / oref_b, oref_l, oref_m, oref_h /;
set m_oref(m) / oref_b, oref_l, oref_m, oref_h /;


* Investment cost ($/GJ output):
* Source: https://iea-etsap.org/E-TechDS/PDF/P04_Oil%20Ref_KV_Apr2014_GSOK.pdf
table data_REFI_capcost(P,t) "Investment cost ($/GJ output) over the years 2020-2100"
              2020      2030      2040      2050      2060      2070      2080      2090      2100
REFI_OilRef   14.3      14.3      14.3      14.3      14.3      14.3      14.3      14.3      14.3      
;

parameter data_REFI_varcost(P);
data_REFI_varcost('REFI_OilRef') = 0.6;


* Lifetimes, source: 
Parameter data_REFI_lifetime(P) /  REFI_OilRef   30      /;

* Refinery input: 
parameter data_REFI_Input_m(p,m,c) /
REFI_OilRef . oref_b . CRUD  1
REFI_OilRef . oref_l . CRUD  1
REFI_OilRef . oref_m . CRUD  1
REFI_OilRef . oref_h . CRUD  1
/ ;


* Refinery output
* Source: Valero, "Basics of Refining" presentation 2021 (shares), ETSAP (efficiency)
table data_REFI_output_m(p,m,c) 
                         LPGs     GSLN     OILL     OILH
REFI_OilRef . oref_b     0.017    0.206    0.239    0.442
REFI_OilRef . oref_l     0.034    0.275    0.294    0.294
REFI_OilRef . oref_m     0.069    0.370    0.276    0.175
REFI_OilRef . oref_h     0.052    0.404    0.304    0.129
;

* Oil refinery High Value Chemicals output (assumed to be the same for all refining modes):
data_REFI_output_m('REFI_OilRef', m_oref, 'PROPYLENE') = 0.000185;
data_REFI_output_m('REFI_OilRef', m_oref, 'C4OLEFINS') = 0.000313;
data_REFI_output_m('REFI_OilRef', m_oref, 'BTX'      ) = 0.000451;


* Base year output in PJ/year
* Source: IEA energy balances (see excel: Electricity base year calibration)
Parameter data_REFI_baseyroutput(P)  /  REFI_OilRef   189159 /;

* Availability factor
* Source: https://iea-etsap.org/E-TechDS/PDF/P04_Oil%20Ref_KV_Apr2014_GSOK.pdf
Parameter data_REFI_availability(P)   / REFI_OilRef   0.85 /;

* Capacity factor
Parameter data_REFI_capacityfactor(P) / REFI_OilRef   1 /;


* Emission factors for CO2 (tCO2/TJ)
* Source:
* - assume 90% conversion rate, i.e. 10% of crude being consumed in the process
* - allocate CO2 emissions from fossil petrochemical feedstocks in full to the refinery
Parameter data_REFI_emissions(p,e,m)/
REFI_OilRef  . CO2FFI .  oref_b   0.00842
REFI_OilRef  . CO2FFI .  oref_l   0.00937
REFI_OilRef  . CO2FFI .  oref_m   0.01062
REFI_OilRef  . CO2FFI .  oref_h   0.01080
/;




***************************************************************************************************
*
*   Input data - Crude oil to Chemicals refineries (COTC)
*

set     PROCESS  / REFI_OilRef_COTC /;
set REFI_TECH(P) / REFI_OilRef_COTC /;

* Investment cost ($/GJ input):
*  - using the same assumption as for standard refineries.
table data_REFI_capcost(P,t) "Investment cost ($/GJ output) over the years 2020-2100"
                   2020      2030      2040      2050      2060      2070      2080      2090      2100
REFI_OilRef_COTC   14.3      14.3      14.3      14.3      14.3      14.3      14.3      14.3      14.3      
;

parameter data_REFI_Input_m(p,m,c) /
REFI_OilRef_COTC . m1 . CRUD    1
REFI_OilRef_COTC . m2 . CRUD    1
REFI_OilRef_COTC . m3 . CRUD    1
*
REFI_OilRef_COTC . m1 . STEA    0.037
REFI_OilRef_COTC . m2 . STEA    0.037
REFI_OilRef_COTC . m3 . STEA    0.037
*
REFI_OilRef_COTC . m1 . ELEC    0.065
REFI_OilRef_COTC . m2 . ELEC    0.065
REFI_OilRef_COTC . m3 . ELEC    0.065
/ ;

* COTC-refinery outputs, energy carriers in PJ/yr, olefins and BTX in Mt/yr.
table data_REFI_output_m(p,m,c) 
                         NGAS    Ethane  LPGS    GSLN    OILL    COAL      Ethylene  Propylene C4olefins BTX
REFI_OilRef_COTC . m1    0.102   0.038   0.064   0.070   0.065   0.046     0.00424   0.00337   0.00513   0.00000
REFI_OilRef_COTC . m2    0.112   0.025   0.006   0.142   0.130   0.093     0.00441   0.00262   0.00229   0.00000
REFI_OilRef_COTC . m3    0.185   0.021   0.000   0.058   0.053   0.055     0.00595   0.00129   0.00111   0.00484
;


Parameter data_REFI_lifetime(P)      /  REFI_OilRef_COTC   30   /;
Parameter data_REFI_baseyroutput(P)  /  REFI_OilRef_COTC   0    /;
Parameter data_REFI_availability(P)   / REFI_OilRef_COTC   0.85 /;
Parameter data_REFI_capacityfactor(P) / REFI_OilRef_COTC   1    /;

Parameter data_REFI_startyear(P) /      REFI_OilRef_COTC   2030 /;

* Emission factors for CO2 (tCO2/TJ)
* Source:
* - assume 90% conversion rate, i.e. 10% of crude being consumed in the process
* - allocate CO2 emissions from fossil petrochemical feedstocks in full to the refinery
Parameter data_REFI_emissions(p,e,m)/
REFI_OilRef_COTC . CO2FFI . m1     0.0474
REFI_OilRef_COTC . CO2FFI . m2     0.0366
REFI_OilRef_COTC . CO2FFI . m3     0.0499
/;





***************************************************************************************************
*
*   Input data - NGL fractionation
*

set     PROCESS / REFI_NGLfractionation /;
set REFI_TECH(P)/ REFI_NGLfractionation /;

parameter data_REFI_Input(p, c)       / REFI_NGLfractionation . NGLs     1 /;
parameter data_REFI_Output(p,c) /       REFI_NGLfractionation . Ethane   0.50 
                                         REFI_NGLfractionation . LPGs     0.30
                                         REFI_NGLfractionation . OILL     0.20
/;

Parameter data_REFI_availability(P)   / REFI_NGLfractionation        1 /;
Parameter data_REFI_capacityfactor(P) / REFI_NGLfractionation        1 /;
Parameter data_REFI_baseyroutput(P)   / REFI_NGLfractionation        1 /;
Parameter data_REFI_lifetime(P)       / REFI_NGLfractionation     1000 /;

* Emissions are in Emissions.gms
*data_REFI_emissions('REFI_NGLfractionation', 'CO2FFI', mdfl) = 0;


***************************************************************************************************
*
*   Input data - Fluid catalytic cracking (FCC)
*

set     PROCESS / REFI_FCCracker /;

set REFI_TECH(P)/ REFI_FCCracker /;

* Source: see Refining scrapbook, sheet Fluid catalytic cracking
data_REFI_capcost('REFI_FCCracker',t) = 1.3;

parameter data_REFI_Input(p,c)        / REFI_FCCracker . OILH 1 /;

parameter data_REFI_Output(p,c) /
REFI_FCCracker . OILH     0.07 
REFI_FCCracker . OILL     0.22
REFI_FCCracker . GSLN     0.50
REFI_FCCracker . LPGs     0.11
REFI_FCCracker . Ethane   0.04 
/;

* Emissions are in Emissions.gms
*data_REFI_emissions('REFI_FCCracker', 'CO2FFI', mdfl) = 0.00642 ;

Parameter data_REFI_availability(P)   / REFI_FCCracker        1 /;
Parameter data_REFI_capacityfactor(P) / REFI_FCCracker        1 /;
Parameter data_REFI_baseyroutput(P)   / REFI_FCCracker        1 /;
Parameter data_REFI_lifetime(P)       / REFI_FCCracker       20 /;



***************************************************************************************************
*
*   Input data - H2 Electrolyser
*

* TODO: needs capital costs -> should be easy to find
* -> also modify the capacity/availability to a proper level

set     PROCESS / REFI_H2Electrolyser /;
set REFI_TECH(P)/ REFI_H2Electrolyser /;

parameter data_REFI_Input(p, c)       / REFI_H2Electrolyser . ELEC   1.25 /;
parameter data_REFI_Output(p,c)       / REFI_H2Electrolyser . HYDR     1 /;
Parameter data_REFI_availability(P)   / REFI_H2Electrolyser   1 /;
Parameter data_REFI_capacityfactor(P) / REFI_H2Electrolyser   1 /;
Parameter data_REFI_baseyroutput(P)   / REFI_H2Electrolyser   0 /;
Parameter data_REFI_lifetime(P)       / REFI_H2Electrolyser  20 /;



***************************************************************************************************
*
*   Input data - steam cracking
*

set     PROCESS / 
REFI_CrackerGasoil
REFI_CrackerNaphta
REFI_CrackerLPG
REFI_CrackerEthane
/;

set REFI_TECH(P)/
REFI_CrackerGasoil
REFI_CrackerNaphta
REFI_CrackerLPG
REFI_CrackerEthane
/;

* Cracker inputs as PJ input/Mt ethylene (or GJ/t of ethylene)
parameter data_REFI_Input(p, c) /
REFI_CrackerGasoil . OILH    173.5
REFI_CrackerNaphta . OILL    139.9
REFI_CrackerLPG    . LPGs    104.6
REFI_CrackerEthane . Ethane   59.2
/;

* Cracker activity is based on ethylene output, outputs as Mt/Mt ethylene
* Outputs are in Mt for olefins and BTX, PJ for gasoline and natural gas.
table data_REFI_Output(p,c)                                    
                        ETHYLENE  PROPYLENE  C4OLEFINS    BTX      GSLN     NGAS    
REFI_CrackerGasoil      1         0.58         0.36       0.50     14.7     22.8
REFI_CrackerNaphta      1         0.52         0.35       0.32     15.7     21.5
REFI_CrackerLPG         1         0.27         0.13       0.00      7.2     28.7
REFI_CrackerEthane      1         0.02         0.04       0.00      1.8     3.8  
;

* Availability factor
Parameter data_REFI_availability(P)/
REFI_CrackerGasoil   1
REFI_CrackerNaphta   1
REFI_CrackerLPG      1
REFI_CrackerEthane   1
/;

* Capacity factor
Parameter data_REFI_capacityfactor(P)/
REFI_CrackerGasoil    1
REFI_CrackerNaphta    1
REFI_CrackerLPG       1
REFI_CrackerEthane    1
/;

* Capital cost are given per ethylene output (as the activity is defined for crackers)
data_REFI_capcost('REFI_CrackerGasoil',t) =  946;
data_REFI_capcost('REFI_CrackerNaphta',t) =  874;
data_REFI_capcost('REFI_CrackerLPG'   ,t) = 1007;
data_REFI_capcost('REFI_CrackerEthane',t) = 1378;

Parameter data_REFI_baseyroutput(P)/
REFI_CrackerGasoil    8
REFI_CrackerNaphta   96
REFI_CrackerLPG      16
REFI_CrackerEthane   40
/;

Parameter data_REFI_lifetime(P) /
REFI_CrackerGasoil   30
REFI_CrackerNaphta   30
REFI_CrackerLPG      30
REFI_CrackerEthane   30
/;




***************************************************************************************************
*
*   Input data - Bioliquids
*

* Based on the crop-to-ethanol plant from bioplastics production, only converted to energy inputs/outputs

set     PROCESS / REFI_BioLfromCrop /;
set REFI_TECH(P)/ REFI_BioLfromCrop /;

parameter data_REFI_Input(p, c)       / REFI_BioLfromCrop . BiomassCrop   0.11 /;
parameter data_REFI_Input(p, c)       / REFI_BioLfromCrop . ELEC   0.01 /;
parameter data_REFI_Input(p, c)       / REFI_BioLfromCrop . STEA   0.18 /;

parameter data_REFI_Output(p,c)       / REFI_BioLfromCrop . BioL   1    /;
parameter data_REFI_Output(p,c)       / REFI_BioLfromCrop . BioM   0.81 /;

Parameter data_REFI_availability(P)   / REFI_BioLfromCrop   1 /;
Parameter data_REFI_capacityfactor(P) / REFI_BioLfromCrop   1 /;
Parameter data_REFI_baseyroutput(P)   / REFI_BioLfromCrop   0 /;
Parameter data_REFI_lifetime(P)       / REFI_BioLfromCrop   30 /;

data_REFI_capcost('REFI_BioLfromCrop',t) = 72;




***************************************************************************************************
*
*   Assign input data to techs 
*

OperationalLife(r,p)$REFI_TECH(P) = data_REFI_lifetime(P);
CapitalCost(r,p,t)$REFI_TECH(P) = data_REFI_capcost(P,t);
VariableCost(r,p,m_oref,t)$REFI_TECH(P) = data_REFI_varcost(P);

AvailabilityFactor(r,p,t)$REFI_TECH(P) = data_REFI_availability(P);
CapacityFactor(r,p,l,t)$REFI_TECH(P) = data_REFI_capacityfactor(P);

CapacityToActivityUnit(r,p)$REFI_TECH(P) = 1;

* Refineries (I/O ratios by operation mode):
InputActivityRatio(r,p,c,m,t)$data_REFI_Input_m(p,m,c) = data_REFI_Input_m(p,m,c);
OutputActivityRatio(r,p,c,m,t)$data_REFI_output_m(p,m,c) = data_REFI_output_m(p,m,c);
* Other techs (steam crakcers, ammonia and methanol - use default mode):
InputActivityRatio(r,p,c,mdfl,t)$data_REFI_Input(p,c) = data_REFI_Input(p,c);
OutputActivityRatio(r,p,c,mdfl,t)$data_REFI_Output(p,c) = data_REFI_Output(p,c);



* Add 5% to each capacity so the system isn't on a knife's edge
CapacityResidual(r,p,t)$REFI_TECH(P) = data_REFI_baseyroutput(P) / data_REFI_availability(P) * 1.05 * max(0, 1 - (T.val-2020)/OperationalLife(r,p) );

ProcessStartYear(r,p)$(REFI_TECH(P) and data_REFI_startyear(P)) = data_REFI_startyear(P);

EmissionActivityRatio(r,p,e,m,t)$REFI_TECH(P) = data_REFI_emissions(p,e,m);









