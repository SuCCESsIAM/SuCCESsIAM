


***************************************************************************************************
*
*   Input data - electricity distribution (to account for distribution losses)
*

* Global distribution losses approx 8%
* Source: https://data.worldbank.org/indicator/EG.ELC.LOSS.ZS
set     PROCESS / ELEC_DistributionGrid /;
set ELEC_TECH(P)/ ELEC_DistributionGrid /;

Parameter data_ELEC_lifetime(P)         /  ELEC_DistributionGrid     1000            /;
Parameter data_ELEC_input(p,c)          /  ELEC_DistributionGrid  .  ELECGen   1.08  /;
Parameter data_ELEC_output(p,c)         /  ELEC_DistributionGrid  .  ELEC      1     /;
Parameter data_ELEC_availability(P)     /  ELEC_DistributionGrid               1     /;
Parameter data_ELEC_capacityfactor(P,T);
data_ELEC_capacityfactor('ELEC_DistributionGrid',T) = 1;


***************************************************************************************************
*
*   Input data - electricity generation
*

set     PROCESS / 
ELEC_Coal
ELEC_OilL
ELEC_GasT
ELEC_BioM
ELEC_Wste
ELEC_Fiss
ELEC_Hydr
ELEC_Wnd1
ELEC_SPV1
ELEC_BCCS
ELEC_CCCS
ELEC_GCCS
/;

set ELEC_TECH(P)/
ELEC_Coal
ELEC_OilL
ELEC_GasT
ELEC_BioM
ELEC_Wste
ELEC_Fiss
ELEC_Hydr
ELEC_Wnd1
ELEC_SPV1
ELEC_BCCS
ELEC_CCCS
ELEC_GCCS
/;

set ELEC_VRE(P)/
ELEC_Wnd1
ELEC_SPV1
/;


* Lifetimes, source: IEA PCGE 2020, page 36
Parameter data_ELEC_lifetime(P) /
ELEC_Coal   40
ELEC_OilL   30
ELEC_GasT   30
ELEC_BioM   40
ELEC_Wste   40
ELEC_Fiss   60
ELEC_Hydr   80
ELEC_Wnd1   25
ELEC_SPV1   25
ELEC_BCCS   40
ELEC_CCCS   40
ELEC_GCCS   40
/;


* Capital costs ($/(GJ/year))
* Source:
* - Conventional generation: IEA PCGE 2020, table 3.1, mean; coal from Krey et al., "Looking under the hood", 2019
* - VRE: IEA WEO 2021
* - CCS: Lehtveer & Emanuelsson, 2021
* Notes: Oil according to gas (CCGT), waste according to biomass
table data_ELEC_capcost(P,t) "Change of input_tech_capacityfactor(P,t) over the years 2020-2100"
              2020      2030     2040     2050     2060     2070     2080     2090     2100
ELEC_Coal      46.0     46.0     46.0     46.0     46.0     46.0     46.0     46.0     46.0      
ELEC_OilL      30.3     30.3     30.3     30.3     30.3     30.3     30.3     30.3     30.3      
ELEC_GasT      30.3     30.3     30.3     30.3     30.3     30.3     30.3     30.3     30.3      
ELEC_BioM      79.3     79.3     79.3     79.3     79.3     79.3     79.3     79.3     79.3      
ELEC_Wste      79.3     79.3     79.3     79.3     79.3     79.3     79.3     79.3     79.3      
ELEC_Fiss     114.3    114.3    114.3    114.3    114.3    114.3    114.3    114.3    114.3
ELEC_Hydr     105.2    105.2    105.2    105.2    105.2    105.2    105.2    105.2    105.2
*
ELEC_Wnd1      44.1     42.1     40.0     38.1     36.0     34.0     31.9     29.9     28.5      
ELEC_SPV1      31.6     27.4     23.2     19.0     17.0     14.9     12.8     11.1     9.5       
*
ELEC_BCCS     105.0    105.0    105.0    105.0    105.0    105.0    105.0    105.0    105.0    
ELEC_CCCS      98.3     98.3     98.3     98.3     98.3     98.3     98.3     98.3     98.3    
ELEC_GCCS      51.4     51.4     51.4     51.4     51.4     51.4     51.4     51.4     51.4    
;


* Generation efficiency, source: Krey et al., "Looking under the hood", 2019 (Appendix C, MESSAGE input data)
* 2020 efficiency matched with statistics, 2030 interpolated
Table data_ELEC_efficiency_t(P,c,t)
                    2020      2030     2040     2050     2060     2070     2080     2090     2100
ELEC_Coal  . Coal   0.33      0.35     0.38     0.38     0.38     0.38     0.38     0.38     0.38
ELEC_OilL  . OilL   0.35      0.38     0.38     0.38     0.38     0.38     0.38     0.38     0.38
ELEC_GasT  . NGas   0.42      0.45     0.50     0.55     0.55     0.55     0.55     0.55     0.55
ELEC_BioM  . BioM   0.33      0.35     0.37     0.37     0.37     0.37     0.37     0.37     0.37
ELEC_Wste  . Wste   0.25      0.25     0.25     0.25     0.25     0.25     0.25     0.25     0.25
ELEC_Fiss  . URAN   0.33      0.33     0.33     0.33     0.33     0.33     0.33     0.33     0.33
ELEC_BCCS  . BioM   0.3       0.3      0.3      0.3      0.3      0.3      0.3      0.3      0.3 
ELEC_CCCS  . Coal   0.34      0.34     0.34     0.34     0.34     0.34     0.34     0.34     0.34
ELEC_GCCS  . NGas   0.40      0.42     0.45     0.45     0.45     0.45     0.45     0.45     0.45
;


* Processes produce ELECgen (generated electricity), distribution grids convert it into ELEC (accountif for distribution losses).
Parameter data_ELEC_output(p,c) /
ELEC_Coal  .  ELECGen   1
ELEC_OilL  .  ELECGen   1
ELEC_GasT  .  ELECGen   1
ELEC_BioM  .  ELECGen   1
ELEC_Wste  .  ELECGen   1
ELEC_Fiss  .  ELECGen   1
ELEC_Hydr  .  ELECGen   1
ELEC_Wnd1  .  ELECGen   1
ELEC_SPV1  .  ELECGen   1
ELEC_BCCS  .  ELECGen   1
ELEC_CCCS  .  ELECGen   1
ELEC_GCCS  .  ELECGen   1
/;

* Base year output in PJ/year
* Source: IEA energy balances (see excel: Electricity base year calibration)
* NOTE: currently (2021-04-23) only electricity-only plants included here 
Parameter data_ELEC_baseyroutput(P)/
ELEC_Coal   36371
ELEC_OilL    2605
ELEC_GasT   23220
ELEC_BioM    2087
ELEC_Wste     407
ELEC_Fiss   10077
ELEC_Hydr   15762
ELEC_Wnd1    5928
ELEC_SPV1    3068
/;


* Availability factor
Parameter data_ELEC_availability(P)/
ELEC_Coal   0.8
ELEC_OilL   0.8
ELEC_GasT   0.8
ELEC_BioM   0.8
ELEC_Wste   0.8
ELEC_Fiss   0.9
ELEC_Hydr   1
ELEC_Wnd1   1
ELEC_SPV1   1
ELEC_BCCS   0.8
ELEC_CCCS   0.8
ELEC_GCCS   0.8
/;


* Capacity factor
* NOTE: This table can be used to account for the long-term change in capacity factors.
*       Hourly variability of capacity factors for VRE are done in the Electricity module.
table data_ELEC_capacityfactor(P,t) "Change of input_tech_capacityfactor(P,t) over the years 2020-2100"
              2020      2030      2040      2050      2060      2070      2080      2090      2100
ELEC_Wnd1      0.4       0.4       0.4       0.4       0.4       0.4       0.4       0.4       0.4
ELEC_SPV1      0.3       0.3       0.3       0.3       0.3       0.3       0.3       0.3       0.3
ELEC_Coal        1         1         1         1         1         1         1         1         1
ELEC_OilL        1         1         1         1         1         1         1         1         1
ELEC_GasT        1         1         1         1         1         1         1         1         1
ELEC_BioM        1         1         1         1         1         1         1         1         1
ELEC_Wste        1         1         1         1         1         1         1         1         1
ELEC_Fiss        1         1         1         1         1         1         1         1         1
ELEC_Hydr        1         1         1         1         1         1         1         1         1
ELEC_BCCS        1         1         1         1         1         1         1         1         1   
ELEC_CCCS        1         1         1         1         1         1         1         1         1   
ELEC_GCCS        1         1         1         1         1         1         1         1         1   
;


* Emission factors for CH4 and N2O (tCH4/GJ and tN2O/GJ)
* Source: IPCC guidelines for GHG inventories (2006), Table 2.2
* Unit: t/GJ (or Mt/PJ)
Table data_ELEC_emissionfactors(P,E)
            CH4           N2O
ELEC_Coal   0.0000010     0.0000015
ELEC_OilL   0.0000030     0.0000006 
ELEC_GasT   0.0000010     0.0000001 
ELEC_BioM   0.0000300     0.0000040  
ELEC_Wste   0.0000300     0.0000040
*
ELEC_BCCS   0.0000300     0.0000040  
ELEC_CCCS   0.0000010     0.0000015
ELEC_GCCS   0.0000010     0.0000001 
;


Parameter data_ELEC_startyear(P) /
ELEC_BCCS        2040
ELEC_CCCS        2040
ELEC_GCCS        2040
/;


***************************************************************************************************
*
*   Input data - heat (district heating) and steam (industrial process heat/steam) generation
*

set     PROCESS / 
HEAT_Coal
HEAT_OilL
HEAT_NGas
HEAT_BioM
HEAT_Wste
HEAT_Elec
*
STEA_Coal
STEA_OilL
STEA_NGas
STEA_BioM
STEA_Wste
/;

set ELEC_TECH(P)/
HEAT_Coal
HEAT_OilL
HEAT_NGas
HEAT_BioM
HEAT_Wste
HEAT_Elec
*
STEA_Coal
STEA_OilL
STEA_NGas
STEA_BioM
STEA_Wste
/;


* Lifetimes
Parameter data_ELEC_lifetime(P) /
HEAT_Coal   30
HEAT_OilL   30
HEAT_NGas   30
HEAT_BioM   30
HEAT_Wste   30
HEAT_Elec   30
*
STEA_Coal   30
STEA_OilL   30
STEA_NGas   30
STEA_BioM   30
STEA_Wste   30
/;


* Capital costs ($/GJ) or (M$/PJ)
table data_ELEC_capcost(P,t) "Change of input_tech_capacityfactor(P,t) over the years 2020-2100"
              2020      2030      2040      2050      2060      2070      2080      2090      2100
HEAT_Coal     15        15        15        15        15        15        15        15        15
HEAT_OilL     15        15        15        15        15        15        15        15        15
HEAT_NGas      3         3         3         3         3         3         3         3         3
HEAT_BioM     15        15        15        15        15        15        15        15        15
HEAT_Wste     15        15        15        15        15        15        15        15        15
HEAT_Elec      0.5       0.5       0.5       0.5       0.5       0.5       0.5       0.5       0.5
*                                                                                               
STEA_Coal     15        15        15        15        15        15        15        15        15
STEA_OilL     15        15        15        15        15        15        15        15        15
STEA_NGas      3         3         3         3         3         3         3         3         3
STEA_BioM     15        15        15        15        15        15        15        15        15
STEA_Wste     15        15        15        15        15        15        15        15        15
;

* Generation efficiency, source: IEA balances (see excel: HEATtricity base year calibration)
Parameter data_ELEC_efficiency(P,c)/
HEAT_Coal  .  Coal   0.9
HEAT_OilL  .  OilL   0.9
HEAT_NGas  .  NGas   0.9
HEAT_BioM  .  BioM   0.9
HEAT_Wste  .  Wste   0.9
HEAT_Elec  .  Elec   0.99
*
STEA_Coal  .  Coal   0.9
STEA_OilL  .  OilL   0.9
STEA_NGas  .  NGas   0.9
STEA_BioM  .  BioM   0.9
STEA_Wste  .  Wste   0.9
/;

Parameter data_ELEC_output(p,c) /
HEAT_Coal .  HEAT    1
HEAT_OilL .  HEAT    1
HEAT_NGas .  HEAT    1
HEAT_BioM .  HEAT    1
HEAT_Wste .  HEAT    1
HEAT_Elec .  HEAT    1
*
STEA_Coal .  STEA    1
STEA_OilL .  STEA    1
STEA_NGas .  STEA    1
STEA_BioM .  STEA    1
STEA_Wste .  STEA    1
/;

* Base year output in PJ/year
Parameter data_ELEC_baseyroutput(P)/
HEAT_Coal   1
HEAT_OilL   1
HEAT_NGas   1
HEAT_BioM   1
HEAT_Wste   1
HEAT_Elec   0
*
STEA_Coal   1
STEA_OilL   1
STEA_NGas   1
STEA_BioM   1
STEA_Wste   1
/;

* Availability factor
Parameter data_ELEC_availability(P)/
HEAT_Coal   0.9
HEAT_OilL   0.9
HEAT_NGas   0.9
HEAT_BioM   0.9
HEAT_Wste   0.9
HEAT_Elec   0.9
*
STEA_Coal   0.9
STEA_OilL   0.9
STEA_NGas   0.9
STEA_BioM   0.9
STEA_Wste   0.9
/;


* Capacity factor
* NOTE: needs to be done properly after the timeslices have been determined
table data_ELEC_capacityfactor(P,t) "Change of input_tech_capacityfactor(P,t) over the years 2020-2100"
              2020      2030      2040      2050      2060      2070      2080      2090      2100
HEAT_Coal        1         1         1         1         1         1         1         1         1
HEAT_OilL        1         1         1         1         1         1         1         1         1
HEAT_NGas        1         1         1         1         1         1         1         1         1
HEAT_BioM        1         1         1         1         1         1         1         1         1
HEAT_Wste        1         1         1         1         1         1         1         1         1
HEAT_Elec        1         1         1         1         1         1         1         1         1
*
STEA_Coal        1         1         1         1         1         1         1         1         1
STEA_OilL        1         1         1         1         1         1         1         1         1
STEA_NGas        1         1         1         1         1         1         1         1         1
STEA_BioM        1         1         1         1         1         1         1         1         1
STEA_Wste        1         1         1         1         1         1         1         1         1
;


* Emission factors for CH4 and N2O (tCH4/GJ and tN2O/GJ)
* Source: IPCC guidelines for GHG inventories (2006)
* Unit: t/GJ  or   Mt/PJ
Table data_ELEC_emissionfactors(P,E)
            CH4           N2O
HEAT_Coal   0.0000010     0.0000015 
HEAT_OilL   0.0000030     0.0000006 
HEAT_NGas   0.0000010     0.0000001 
HEAT_BioM   0.0000300     0.0000040 
HEAT_Wste   0.0000300     0.0000040 
*       
STEA_Coal   0.0000010     0.0000015 
STEA_OilL   0.0000030     0.0000006 
STEA_NGas   0.0000010     0.0000001 
STEA_BioM   0.0000300     0.0000040 
STEA_Wste   0.0000300     0.0000040 
;





***************************************************************************************************
*
*   Assign input data to techs 
*


* Give the own names of things to the Osmosys-side
OperationalLife(r,p)$ELEC_TECH(P) = data_ELEC_lifetime(P);

CapitalCost(r,p,t)$ELEC_TECH(P) = data_ELEC_capcost(P,t);

AvailabilityFactor(r,p,t)$ELEC_TECH(P) = data_ELEC_availability(P);
CapacityFactor(r,p,l,t)$ELEC_TECH(P) = data_ELEC_capacityfactor(P,t);

CapacityToActivityUnit(r,p)$ELEC_TECH(P) = 1;

* Assigning input commodities to processes (and how much of the commodities are being consumed by the process to generate 1 unit of output)
InputActivityRatio(r,p,c,mdfl,t)$(ELEC_TECH(P) and data_ELEC_efficiency(p,c))     = 1 / data_ELEC_efficiency(p,c);
InputActivityRatio(r,p,c,mdfl,t)$(ELEC_TECH(P) and data_ELEC_efficiency_t(p,c,t)) = 1 / data_ELEC_efficiency_t(p,c,t);

* Inputs to processes that are not defined thought efficiency, but input ratio:
InputActivityRatio(r,p,c,mdfl,t)$(ELEC_TECH(P) and data_ELEC_input(p,c)) = data_ELEC_input(p,c);
OutputActivityRatio(r,p,c,mdfl,t)$(ELEC_TECH(P) and data_ELEC_output(p,c)) = data_ELEC_output(p,c);

ProcessStartYear(R,P)$(ELEC_TECH(P) and data_ELEC_startyear(P)) = data_ELEC_startyear(P);



parameter d(P);
* Add 10% to each capacity so the system isn't on a knife's edge
* (note: electricity needs more 'excess' capacity to cover also for the hourly variations)
CapacityResidual(r,p,t)$(ELEC_TECH(P) and data_ELEC_baseyroutput(P) and not ELEC_VRE(P)) = 1.2 * data_ELEC_baseyroutput(P) / data_ELEC_availability(P) / data_ELEC_capacityfactor(P,t) * max(0, 1 - (T.val-2020)/OperationalLife(r,p) );
CapacityResidual(r,p,t)$(ELEC_TECH(P) and data_ELEC_baseyroutput(P) and ELEC_VRE(P)) = 1.0 * data_ELEC_baseyroutput(P) / data_ELEC_availability(P) / data_ELEC_capacityfactor(P,t) * max(0, 1 - (T.val-2020)/OperationalLife(r,p) );


* EmissionActivityRatio[r,p,e,m,y]
* Emission factor of a technology per unit of activity, per mode of operation.
EmissionActivityRatio(r,p,e,mdfl,t)$(ELEC_TECH(P) and data_ELEC_emissionfactors(P,E)) = data_ELEC_emissionfactors(P,E);





***************************************************************************************************
*
*   Additional constraints:
*


* Don't allow investments in the first period:
CapacityNewMax(R,'ELEC_Coal',tfirst) = 0;
CapacityNewMax(R,'ELEC_OilL',tfirst) = 0;
CapacityNewMax(R,'ELEC_GasT',tfirst) = 0;
CapacityNewMax(R,'ELEC_BioM',tfirst) = 0;
CapacityNewMax(R,'ELEC_Wste',tfirst) = 0;
CapacityNewMax(R,'ELEC_Fiss',tfirst) = 0;
CapacityNewMax(R,'ELEC_Hydr',tfirst) = 0;
CapacityNewMax(R,'ELEC_Wnd1',tfirst) = 0;
CapacityNewMax(R,'ELEC_SPV1',tfirst) = 0;

* Require electricity generation in 2020 to be close to the actual values:
* Note, 2024 July: current SuCCESs calibration has less electricity consumption than IEA, whereby baseyroutput can be used as upper limit.
OutputAnnualByProcess.UP(R,ELEC_TECH,'ElecGen','2020')$data_ELEC_baseyroutput(ELEC_TECH) = 1.00 * data_ELEC_baseyroutput(ELEC_TECH);


* Constrain hydro capacity s.t. it can grow only 10% over the century:
CapacityTotalMax(R,'ELEC_Hydr',t) = CapacityResidual(R,'ELEC_Hydr',t) / data_ELEC_availability('ELEC_Hydr') / data_ELEC_capacityfactor('ELEC_Hydr',t) * (1.01 + 0.1 * (t.val-2020)/(2100-2020));
