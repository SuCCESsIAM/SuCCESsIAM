
***************************************************************************************************
*
*   Input data - industrial production - steel
*

set     PROCESS / 
INDU_BlastFurnace
INDU_DRI_EAF     
INDU_Scrap_EAF     
INDU_DRI_EAF_CCS 
INDU_SRI_BOF_CCS  
INDU_DRI_H2_EAF  
/;

set INDU_TECH(P)/
INDU_BlastFurnace
INDU_DRI_EAF     
INDU_Scrap_EAF     
INDU_DRI_EAF_CCS 
INDU_SRI_BOF_CCS  
INDU_DRI_H2_EAF  
/;


* Investment cost ($/t output):
* Source: IEA ETSAP  Technology Brief I02, 2010 (https://iea-etsap.org/E-TechDS/PDF/I02-Iron&Steel-GS-AD-gct.pdf)
* Converted to USD2020 with 1.5 multiplier. DRI includes EAF cost.
Parameter data_INDU_capcost(P) "Investment cost ($/t output)" /
INDU_BlastFurnace       409.5
INDU_DRI_EAF            337.5
INDU_Scrap_EAF          121.5
INDU_DRI_EAF_CCS        9999
INDU_SRI_BOF_CCS        600
INDU_DRI_H2_EAF         9999
/;

* Lifetimes, source: 
Parameter data_INDU_lifetime(P) /
INDU_BlastFurnace      30
INDU_DRI_EAF           30
INDU_Scrap_EAF         30
INDU_DRI_EAF_CCS       30
INDU_SRI_BOF_CCS       30
INDU_DRI_H2_EAF        30
/;

* Process inputs
table data_INDU_input(p, c)
                     COAL    NGAS    ELEC      ScrapSteel
INDU_BlastFurnace    19.4            0.9       
INDU_DRI_EAF                  12     6.5       
INDU_Scrap_EAF                       6.0           1
INDU_DRI_EAF_CCS    99999                            
INDU_SRI_BOF_CCS      30             1.1                            
INDU_DRI_H2_EAF     99999                            
;

* Process output
Parameter data_INDU_output(p,c) /
INDU_BlastFurnace  .  Steel      1   
INDU_DRI_EAF       .  Steel      1   
INDU_Scrap_EAF     .  Steel      1
INDU_DRI_EAF_CCS   .  Steel      1   
INDU_SRI_BOF_CCS    . Steel      1   
INDU_DRI_H2_EAF    .  Steel      1   
/;


* Base year output in Mt/year
Parameter data_INDU_baseyroutput(P)/
INDU_BlastFurnace      1250 
INDU_Scrap_EAF          650
/;

* Don't allow investments in the first period:
CapacityNewMax(R,'INDU_BlastFurnace',tfirst) = 0;
CapacityNewMax(R,'INDU_Scrap_EAF',tfirst) = 0;

* Availability factor
Parameter data_INDU_availability(P)/
INDU_BlastFurnace       1
INDU_DRI_EAF            1
INDU_Scrap_EAF          1
INDU_DRI_EAF_CCS        1
INDU_SRI_BOF_CCS        1
INDU_DRI_H2_EAF         1
/;

* Capacity factor
Parameter data_INDU_capacityfactor(P)/
INDU_BlastFurnace        1
INDU_DRI_EAF             1
INDU_Scrap_EAF           1
INDU_DRI_EAF_CCS         1
INDU_SRI_BOF_CCS         1
INDU_DRI_H2_EAF          1
/;


Parameter data_INDU_startyear(P)/
INDU_DRI_EAF             2030
INDU_DRI_EAF_CCS         2040
INDU_SRI_BOF_CCS         2040
INDU_DRI_H2_EAF          2040
/;





***************************************************************************************************
*
*   Input data - industrial production - Aluminium and concrete
*

set     PROCESS / 
INDU_Alumina     
INDU_Aluminium
INDU_Alum_recy   
INDU_Cement_coal
INDU_Cement_OilH
INDU_Cement_ngas
INDU_Cement_BioM
INDU_Cement_NGas_CCS
INDU_Cement_BioM_CCS
/;

set INDU_TECH(P)/
INDU_Alumina     
INDU_Aluminium
INDU_Alum_recy  
INDU_Cement_coal
INDU_Cement_OilH
INDU_Cement_ngas
INDU_Cement_BioM
INDU_Cement_NGas_CCS
INDU_Cement_BioM_CCS
/;


* Investment cost ($/t output):
Parameter data_INDU_capcost(P) "Investment cost ($/t output)" /
/;

* Lifetimes, source: 
Parameter data_INDU_lifetime(P) /
INDU_Alumina           40
INDU_Alum_recy         40
INDU_Aluminium         40
INDU_Cement_coal       40
INDU_Cement_OilH       40
INDU_Cement_ngas       40
INDU_Cement_BioM       40
INDU_Cement_NGas_CCS   40
INDU_Cement_BioM_CCS   40
/;

* Process inputs
table data_INDU_input(p, c)
                     COAL    OILH    NGAS    BIOM     ELEC     STEA    Alumina  ScrapAluminium
*Note: Alumina given separately below per operation mode       
*INDU_Alumina                         10.4                     
INDU_Aluminium                                        50.1              2.1  
INDU_Alum_recy                                         4.7                            1  
INDU_Cement_coal     2.5                               0.3     
INDU_Cement_OilH             2.5                       0.3     
INDU_Cement_ngas                     2.5               0.3     
INDU_Cement_BioM                              2.5      0.3     
INDU_Cement_ngas_CCS                 2.5               0.3     1.3
INDU_Cement_BioM_CCS                          2.5      0.3     1.6
;


* Alumina can use different input energy forms per operation mode
parameter data_INDU_input_alumina(p,c,m) /
INDU_Alumina  .  COAL  .  m1      10.4
INDU_Alumina  .  NGAS  .  m2      10.4
INDU_Alumina  .  OILL  .  m3      10.4
INDU_Alumina  .  BIOM  .  m4      10.4
INDU_Alumina  .  ELEC  .  m5      10.4
/;

Parameter data_INDU_output_alumina(p,c,m) /
INDU_Alumina  .  Alumina  .  m1   1 
INDU_Alumina  .  Alumina  .  m2   1 
INDU_Alumina  .  Alumina  .  m3   1 
INDU_Alumina  .  Alumina  .  m4   1 
INDU_Alumina  .  Alumina  .  m5   1 
/;

* Process output
Parameter data_INDU_output(p,c) /
INDU_Aluminium     .  Aluminium  1
INDU_Alum_recy     .  Aluminium  1
INDU_Cement_coal   .  Cement     1
INDU_Cement_OilH   .  Cement     1
INDU_Cement_ngas   .  Cement     1
INDU_Cement_BioM   .  Cement     1
INDU_Cement_NGas_CCS . Cement    1
INDU_Cement_BioM_CCS . Cement    1
/;


* Base year output in Mt/year
*Parameter data_INDU_baseyroutput(P)/
*INDU_Alumina     
*INDU_Aluminium   
*INDU_Cement      
*INDU_Cement_CCS  
*/;
*

* Availability factor
Parameter data_INDU_availability(P)/
INDU_Alumina            1
INDU_Aluminium          1
INDU_Alum_recy          1
INDU_Cement_coal        1
INDU_Cement_OilH        1
INDU_Cement_ngas        1
INDU_Cement_BioM        1
INDU_Cement_NGas_CCS    1
INDU_Cement_BioM_CCS    1
/;

* Capacity factor
Parameter data_INDU_capacityfactor(P)/
INDU_Alumina             1
INDU_Aluminium           1
INDU_Alum_recy          1
INDU_Cement_coal        1
INDU_Cement_OilH        1
INDU_Cement_ngas        1
INDU_Cement_BioM        1
INDU_Cement_NGas_CCS    1
INDU_Cement_BioM_CCS    1
/;


* Process emission factors (t emission/t product)
Table data_INDU_emissionfactor(P,E)
                        CO2FFI    CH4    N2O
INDU_Cement_coal        0.34
INDU_Cement_OilH        0.34
INDU_Cement_ngas        0.34
INDU_Cement_BioM        0.34
* CCS reduction (both for fuel and process CO2) is considered in file Emissions.gms, hence cement with CCS have the same emission factor as without CCS:
INDU_Cement_NGas_CCS    0.34
INDU_Cement_BioM_CCS    0.34
;


Parameter data_INDU_startyear(P) /
INDU_Cement_NGas_CCS     2040
INDU_Cement_BioM_CCS     2040
/;



***************************************************************************************************
*
*   Input data - industrial production - Copper and Nickel
*

set     PROCESS / 
INDU_Copper
INDU_Copper_recy
INDU_Nickel
INDU_Nickel_recy
/;

set INDU_TECH(P)/
INDU_Copper
INDU_Copper_recy
INDU_Nickel
INDU_Nickel_recy
/;


* Investment cost ($/t output):
Parameter data_INDU_capcost(P) "Investment cost ($/t output)" /
/;

* Lifetimes, source: 
Parameter data_INDU_lifetime(P) /
INDU_Copper              40
INDU_Copper_recy         40
INDU_Nickel              40
INDU_Nickel_recy         40
/;

* Process inputs
table data_INDU_input(p, c)
                     ELEC    ScrapCopper   ScrapNickel
INDU_Copper          11.2                      
INDU_Copper_recy      4.3         1             
INDU_Nickel          39.9                      
INDU_Nickel_recy      4.5                      1
;


* Process output
Parameter data_INDU_output(p,c) /
INDU_Copper        . Copper    1
INDU_Copper_recy   . Copper    1
INDU_Nickel        . Nickel    1
INDU_Nickel_recy   . Nickel    1
/;


* Base year output in Mt/year
*Parameter data_INDU_baseyroutput(P)/
*INDU_Copper
*INDU_Copper_recy
*INDU_Nickel
*INDU_Nickel_recy
*/;


* Availability factor
Parameter data_INDU_availability(P)/
INDU_Copper            1
INDU_Copper_recy       1
INDU_Nickel            1
INDU_Nickel_recy       1
/;

* Capacity factor
Parameter data_INDU_capacityfactor(P)/
INDU_Copper            1
INDU_Copper_recy       1
INDU_Nickel            1
INDU_Nickel_recy       1
/;







***************************************************************************************************
*
*   Input data - industrial production - pulp & paper
*


set     PROCESS / 
INDU_PULP_MECH  
INDU_PULP_CHEM  
INDU_PULP_RECY  
INDU_PAPER_PROD 
INDU_BOARD_PROD 
INDU_TISSUE_PROD
/;

set INDU_TECH(P)/
INDU_PULP_MECH  
INDU_PULP_CHEM  
INDU_PULP_RECY  
INDU_PAPER_PROD 
INDU_BOARD_PROD 
INDU_TISSUE_PROD
/;


* Investment cost ($/t output):
Parameter data_INDU_capcost(P) "Investment cost ($/t output)" /
/;

* Lifetimes, source: 
Parameter data_INDU_lifetime(P) /
INDU_PULP_MECH        40
INDU_PULP_CHEM        40
INDU_PULP_RECY        40
INDU_PAPER_PROD       40
INDU_BOARD_PROD       40
INDU_TISSUE_PROD      40
/;

* Process inputs
table data_INDU_input(p, c)
                     ELEC    STEA    PulpWood    ScrapPaper    Pulp_mech    Pulp_chem    Pulp_recy  
INDU_PULP_MECH        7.9              1.2                                                      
INDU_PULP_CHEM        2.5    22.2      2.2                                                  
INDU_PULP_RECY        1.0     0.3                   1.3                                          
INDU_PAPER_PROD       1.6     5.0                                 0.05         0.75         0.10
INDU_BOARD_PROD       0.7     5.0                                 0.12         0.23         0.55
INDU_TISSUE_PROD      1.2     5.5                                 0.00         0.15         0.75
;



* Process output
Parameter data_INDU_output(p,c) /
INDU_PULP_MECH     .  Pulp_mech      1   
INDU_PULP_CHEM     .  Pulp_chem      1   
INDU_PULP_RECY     .  Pulp_recy      1   
INDU_PAPER_PROD    .  Paper          1
INDU_BOARD_PROD    .  Board          1   
INDU_TISSUE_PROD   .  Tissue         1 
/;


* Base year output in Mt/year
*Parameter data_INDU_baseyroutput(P)/
*INDU_BlastFurnace
*INDU_DRI_EAF     
*INDU_DRI_EAF_CCS 
*INDU_SRI_BOF_CCS  
*INDU_DRI_H2_EAF  
*INDU_Alumina     
*INDU_Aluminium   
*INDU_Cement      
*INDU_Cement_CCS  
*/;
*

* Availability factor
Parameter data_INDU_availability(P)/
INDU_PULP_MECH         1
INDU_PULP_CHEM         1
INDU_PULP_RECY         1
INDU_PAPER_PROD        1
INDU_BOARD_PROD        1
INDU_TISSUE_PROD       1
/;


* Capacity factor
Parameter data_INDU_capacityfactor(P)/
INDU_PULP_MECH         1
INDU_PULP_CHEM         1
INDU_PULP_RECY         1
INDU_PAPER_PROD        1
INDU_BOARD_PROD        1
INDU_TISSUE_PROD       1
/;








***************************************************************************************************
*
*   Input data - other industrial production (not modelled bottom-up)
*

set     PROCESS / 
INDU_Other_Oil
INDU_Other_Gas
INDU_Other_Solid
INDU_Other_Elec
INDU_Other_Stea
/;

set INDU_TECH(P)/
INDU_Other_Oil
INDU_Other_Gas
INDU_Other_Solid
INDU_Other_Elec
INDU_Other_Stea
/;


* Investment cost ($/t output):
Parameter data_INDU_capcost(P) "Investment cost ($/t output)" /
/;

* Lifetimes, source: 
Parameter data_INDU_lifetime(P) /
INDU_Other_Oil       1000
INDU_Other_Gas       1000
INDU_Other_Solid     1000
INDU_Other_Elec      1000
INDU_Other_Stea      1000
/;

* Process inputs
Parameter data_INDU_othinput(p,c,m)/
INDU_Other_Oil    . GSLN . m1   1
INDU_Other_Oil    . OILL . m2   1
INDU_Other_Oil    . OILH . m3   1
INDU_Other_Oil    . BioL . m4   1
INDU_Other_Gas    . NGAS . m1   1
INDU_Other_Gas    . BioG . m2   1
INDU_Other_Solid  . COAL . m1   1
INDU_Other_Solid  . BIOM . m2   1
INDU_Other_Elec   . ELEC . m1   1
INDU_Other_Stea   . STEA . m1   1
/;



* Process output
Parameter data_INDU_othoutput(p,c,m) /
INDU_Other_Oil    .  OtherIndOil     .  m1     1
INDU_Other_Oil    .  OtherIndOil     .  m2     1
INDU_Other_Oil    .  OtherIndOil     .  m3     1
INDU_Other_Oil    .  OtherIndOil     .  m4     1
INDU_Other_Gas    .  OtherIndGas     .  m1     1
INDU_Other_Gas    .  OtherIndGas     .  m2     1
INDU_Other_Solid  .  OtherIndSolid   .  m1     1
INDU_Other_Solid  .  OtherIndSolid   .  m2     1
INDU_Other_Elec   .  OtherIndElec    .  m1     1
INDU_Other_Stea   .  OtherIndStea    .  m1     1
/;



* Availability factor
Parameter data_INDU_availability(P)/
INDU_Other_Oil         1
INDU_Other_Gas         1
INDU_Other_Solid       1
INDU_Other_Elec        1
INDU_Other_Stea        1
/;


* Capacity factor
Parameter data_INDU_capacityfactor(P)/
INDU_Other_Oil         1
INDU_Other_Gas         1
INDU_Other_Solid       1
INDU_Other_Elec        1
INDU_Other_Stea        1
/;






***************************************************************************************************
*
*   Assign input data to techs 
*

OperationalLife(r,p)$INDU_TECH(P) = data_INDU_lifetime(P);
CapitalCost(r,p,t)$(INDU_TECH(P) and data_INDU_capcost(p)) = data_INDU_capcost(P);
*VariableCost(r,p,m,t)$(INDU_TECH(P) and data_INDU_varcost(p)) = data_INDU_varcost(P);

AvailabilityFactor(r,p,t)$INDU_TECH(P) = data_INDU_availability(P);
CapacityFactor(r,p,l,t)$INDU_TECH(P) = data_INDU_capacityfactor(P);

CapacityToActivityUnit(r,p)$INDU_TECH(P) = 1;

InputActivityRatio(r,p,c,mdfl,t)$(INDU_TECH(P) and data_INDU_input(p,c)) = data_INDU_input(p,c);
OutputActivityRatio(r,p,c,mdfl,t)$(INDU_TECH(P) and data_INDU_output(p,c)) = data_INDU_output(p,c);

* Alumina has energy inputs by operation mode:
InputActivityRatio(r,p,c,m,t)$(INDU_TECH(P) and data_INDU_input_alumina(p,c,m)) = data_INDU_input_alumina(p,c,m);
InputActivityRatio(r,p,c,m,t)$(INDU_TECH(P) and data_INDU_othinput(p,c,m)) = data_INDU_othinput(p,c,m);
* These processes need also outputs defined by mode
OutputActivityRatio(r,p,c,m,t)$(INDU_TECH(P) and data_INDU_output_alumina(p,c,m)) = data_INDU_output_alumina(p,c,m);
OutputActivityRatio(r,p,c,m,t)$(INDU_TECH(P) and data_INDU_othoutput(p,c,m)) = data_INDU_othoutput(p,c,m);

ProcessStartYear(R,P)$(INDU_TECH(P) and data_INDU_startyear(P)) = data_INDU_startyear(P);


* Add 5% to each capacity so the system isn't on a knife's edge
CapacityResidual(r,p,t)$(INDU_TECH(P) and data_INDU_lifetime(P)) = data_INDU_baseyroutput(P) / data_INDU_availability(P) * 1.05 * max(0, 1 - (T.val-2020)/OperationalLife(r,p) );


EmissionActivityRatio(r,p,e,mdfl,t)$INDU_TECH(P) = data_INDU_emissionfactor(P,E);
