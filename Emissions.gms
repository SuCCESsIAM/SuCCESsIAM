
***************************************************************************************************
* CO2 emissions from fossil fuels:

* Emission factors in t/GJ (= Mt/PJ)
Table data_EmissionFactors(C,E)
                CO2FFI      CH4         N2O
COAL            0.0961      0.000001    0.0000015
NGAS            0.0561      0.000001    0.0000006
NGLs            0.0642
Ethane          0.0616
*CRUD            
LPGs            0.0631      0.000001    0.0000001
GSLN            0.0693      0.000003    0.0000006
OILL            0.0741      0.000003    0.0000006
OILH            0.0733      0.000003    0.0000006
*URAN            
BIOM                        0.000030    0.000004
BIOG                        0.000001    0.0000001
BGSL                        0.000003    0.0000006
BIOL                        0.000003    0.0000006
WSTE            0.0917      0.000030    0.000004
;

* Calculate the CO2 emissions factors from fossil fuel use:
* sum EmissionActivityRatio (if already given, representing process emissions) with the fossil fuel emission factor (see above) multiplied with the InputActivityRatio of that fuel
EmissionActivityRatio(r,p,'CO2FFI',m,t) = EmissionActivityRatio(r,p,'CO2FFI',m,t) + sum(C$data_EmissionFactors(C,'CO2FFI'), data_EmissionFactors(C,'CO2FFI') * InputActivityRatio(R,P,C,M,T));

* For CH4 and N2O, assign default emission factor if it doesn't exist yet
EmissionActivityRatio(r,p,'CH4',m,t)$(not EmissionActivityRatio(r,p,'CH4',m,t)) = sum(C$data_EmissionFactors(C,'CH4'), data_EmissionFactors(C,'CH4') * InputActivityRatio(R,P,C,M,T));
EmissionActivityRatio(r,p,'N2O',m,t)$(not EmissionActivityRatio(r,p,'N2O',m,t)) = sum(C$data_EmissionFactors(C,'N2O'), data_EmissionFactors(C,'N2O') * InputActivityRatio(R,P,C,M,T));


***************************************************************************************************
* CO2 emissions from refining:

EmissionActivityRatio(r,'REFI_NGLfractionation', 'CO2FFI', mdfl,t) = 0;
EmissionActivityRatio(r,'REFI_FCCracker', 'CO2FFI', mdfl,t) = 0.00642 ;


***************************************************************************************************
* CCS: modify the above emission activity ratios & add the captured CO2 commodity output:

*** Emission activity ratios: ***
* CCS power sector technologies: assume 90% reduction:
EmissionActivityRatio(r,'ELEC_CCCS','CO2FFI',mdfl,t) = 0.1 * data_EmissionFactors('COAL','CO2FFI') * InputActivityRatio(r,'ELEC_CCCS','COAL',mdfl,t);
EmissionActivityRatio(r,'ELEC_GCCS','CO2FFI',mdfl,t) = 0.1 * data_EmissionFactors('COAL','CO2FFI') * InputActivityRatio(r,'ELEC_GCCS','NGAS',mdfl,t);
* For biomass, assume 18 GJ/tDM and 50% carbon content -> 0.1 tCO2/GJ
EmissionActivityRatio(r,'ELEC_BCCS','CO2FFI',mdfl,t) = -0.9 * 0.10 * InputActivityRatio(r,'ELEC_BCCS','BIOM',mdfl,t);

* For cement CCS, assume 85% reduction for both the fuel and the process emissions:
EmissionActivityRatio(r,'INDU_Cement_NGas_CCS','CO2FFI',mdfl,t) = 0.15 * EmissionActivityRatio(r,'INDU_Cement_NGas_CCS','CO2FFI',mdfl,t);
EmissionActivityRatio(r,'INDU_Cement_BioM_CCS','CO2FFI',mdfl,t) = - 0.85 * 0.10 * InputActivityRatio(r,'INDU_Cement_BioM_CCS','BIOM',mdfl,t)
                                                               + 0.15 * data_INDU_emissionfactor('INDU_Cement_BioM_CCS','CO2FFI');

*** Captured CO2 output: ***
* CCS techs produce the captured CO2 commodity (CO2_CCS), for which the commodity balance has an equality sign:
OutputActivityRatio(r,'ELEC_BCCS','CO2_CCS',mdfl,t) = 0.9 * 0.10 * InputActivityRatio(r,'ELEC_BCCS','BIOM',mdfl,t);
OutputActivityRatio(r,'ELEC_CCCS','CO2_CCS',mdfl,t) = 0.9 * data_EmissionFactors('COAL','CO2FFI') * InputActivityRatio(r,'ELEC_CCCS','COAL',mdfl,t);
OutputActivityRatio(r,'ELEC_GCCS','CO2_CCS',mdfl,t) = 0.9 * data_EmissionFactors('COAL','CO2FFI') * InputActivityRatio(r,'ELEC_GCCS','NGAS',mdfl,t);
* The captured CO2 from cement CCS (both fuel and process emissions, which were given already earlier)
OutputActivityRatio(r,'INDU_Cement_NGas_CCS','CO2_CCS',mdfl,t) = 0.85/0.15 * EmissionActivityRatio(r,'INDU_Cement_NGas_CCS','CO2FFI',mdfl,t);
OutputActivityRatio(r,'INDU_Cement_BioM_CCS','CO2_CCS',mdfl,t) = 0.85 * 0.10 * InputActivityRatio(r,'INDU_Cement_BioM_CCS','BIOM',mdfl,t)
                                                               + 0.85 * data_INDU_emissionfactor('INDU_Cement_BioM_CCS','CO2FFI');



***************************************************************************************************
* Exogenous emissions table for the evolution of waste emissions for CH4, N2O (Mt/yr)

table data_EmissionExogenousWaste(r,e,t) 
                2020        2030        2040       2050      2060       2070        2080        2090        2100
World . CH4     66.592      64.399      30.057     18.454    10.998      8.866      19.367      23.129      31.026
World . N2O      0.54       0.64        0.72       0.78      0.81       0.82        0.88        0.99        1.12
;

* Add biomass burning N2O (constant level):
data_EmissionExogenousWaste(r,'N2O',t) = data_EmissionExogenousWaste(r,'N2O',t) + 1.3;

EmissionAnnualExogenous(r,e,t) = data_EmissionExogenousWaste(r,e,t);

