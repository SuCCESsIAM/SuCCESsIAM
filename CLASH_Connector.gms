
************************************************************
* Load CLASH:

* assign the directory for land-use module files:
$setglobal CLASHdir 'CLASH\'

* Load CLASH core:
$batinclude %CLASHdir%CLASH_Core.gms


************************************************************
* Exogenous land-use constraints:

* Lower bounds for 'non-productive' land-use classes from SSP2-4.5:
* Urban area needst to be fixed to get a realistic scenario:
LU_Area.LO(t,pool,'urban')$(ord(t) >= 2) = LU_area_SSP245(t,pool,'urban');

* Primary ecosystem area lower bound. These can be toggled off, if full exploitation is to be allowed:
LU_Area.LO(t,pool,'primf')$(ord(t) >= 2) = LU_area_SSP245(t,pool,'primf');
LU_Area.LO(t,pool,'primn')$(ord(t) >= 2) = LU_area_SSP245(t,pool,'primn');


************************************************************
* Processes for producing commodities from land-use :

set     PROCESS /
    LUConn_BIOM_Crop
    LUConn_BIOM_Wood
    LUConn_BIOM_AgriResid
    LUConn_BIOM_WoodResid
    LUConn_BiomassCrop
    LUConn_WoodLogs
    LUConn_PulpWood
    LUConn_AgriResid
    LUConn_WoodResid
    LUConn_FoodCrops
    LUConn_FoodEggs
    LUConn_FoodBeef
    LUConn_FoodShoat
    LUConn_FoodPork
    LUConn_FoodPoultry
    LUConn_FoodMilk
    LUConn_SecdFRegen
    LUConn_CroplandCost
    LUConn_PastureCost
    LUConn_LandUseCO2Emissions
    LUConn_LandUseCO2Sink
    LUConn_NaturalCO2Emissions
    LUConn_NaturalCO2Sink
    LUConn_CroplandCH4Emissions   
    LUConn_CroplandN2OEmissions   
    LUConn_LivestockCH4Emissions  
    LUConn_LivestockN2OEmissions  
/;

set LUSE_TECH(P) /
    LUConn_BIOM_Crop
    LUConn_BIOM_Wood
    LUConn_BIOM_AgriResid
    LUConn_BIOM_WoodResid
    LUConn_BiomassCrop
    LUConn_AgriResid
    LUConn_WoodResid
    LUConn_WoodLogs
    LUConn_PulpWood 
    LUConn_FoodCrops
    LUConn_FoodEggs
    LUConn_FoodBeef
    LUConn_FoodShoat
    LUConn_FoodPork
    LUConn_FoodPoultry
    LUConn_FoodMilk
    LUConn_SecdFRegen
    LUConn_CroplandCost
    LUConn_PastureCost
    LUConn_LandUseCO2Emissions
    LUConn_LandUseCO2Sink
    LUConn_NaturalCO2Emissions
    LUConn_NaturalCO2Sink
    LUConn_CroplandCH4Emissions   
    LUConn_CroplandN2OEmissions   
    LUConn_LivestockCH4Emissions  
    LUConn_LivestockN2OEmissions  
/;

parameter data_LUSE_Output(p,c)       /
    LUConn_BIOM_Crop        . BIOM               1
    LUConn_BIOM_Wood        . BIOM               1
    LUConn_BIOM_AgriResid   . BIOM               1
    LUConn_BIOM_WoodResid   . BIOM               1
    LUConn_BiomassCrop      . BiomassCrop        1
    LUConn_AgriResid        . BiomassAgriResid   1
    LUConn_WoodResid        . BiomassForResid    1
    LUConn_WoodLogs         . WoodLogs           1
    LUConn_PulpWood         . PulpWood           1
    LUConn_FoodCrops        . FoodCrops          1
    LUConn_FoodBeef         . FoodBeef           1
    LUConn_FoodShoat        . FoodShoat          1
    LUConn_FoodPork         . FoodPork           1
    LUConn_FoodPoultry      . FoodPoultry        1
    LUConn_FoodEggs         . FoodEggs           1
    LUConn_FoodMilk         . FoodMilk           1
/;

Parameter data_LUSE_availability(P);
data_LUSE_availability(LUSE_TECH) = 1;
                                          
Parameter data_LUSE_capacityfactor(P);
data_LUSE_capacityfactor(LUSE_TECH) = 1;

Parameter data_LUSE_lifetime(P);
data_LUSE_lifetime(LUSE_TECH) = 1000;

Parameter data_LUSE_varcost(P)        /
* Rough estimate, 7 $/GJ (or equivalently 126 $/t biomass)
    LUConn_BIOM_Crop                7
    LUConn_BIOM_Wood                7
* Agri. residue collection 9.8 €/t for straw, from Bergonzoli et al., 2020, https://www.mdpi.com/1996-1073/13/5/1265
    LUConn_BIOM_AgriResid           1.4
* Harvest residue collection 7.5€/tDM, from Repo et al. 2015, https://www.sciencedirect.com/science/article/abs/pii/S138993411500074X
    LUConn_BIOM_WoodResid           1.07
    LUConn_BiomassCrop              126
* Agri. residue collection 9.8 €/t for straw, from Bergonzoli et al., 2020, https://www.mdpi.com/1996-1073/13/5/1265
    LUConn_AgriResid                10
* Harvest residue collection 7.5€/tDM, from Repo et al. 2015, https://www.sciencedirect.com/science/article/abs/pii/S138993411500074X
    LUConn_WoodResid                7.5
* NOTE: need data for harvesting costs:
    LUConn_WoodLogs                 0.1
    LUConn_PulpWood                 0.1
    LUConn_FoodCrops                0.1
    LUConn_FoodEggs                 0.1
    LUConn_FoodBeef                 0.1
    LUConn_FoodShoat                0.1
    LUConn_FoodPork                 0.1
    LUConn_FoodPoultry              0.1
    LUConn_FoodMilk                 0.1
* Forest regeneration costs: 1000 $/ha = 100000 mln.$/mln.km2 (rough estimate, see e.g. Susaeta et al., J. For. Econ., 2014)
    LUConn_SecdFRegen               100000
    LUConn_CroplandCost             0.1
    LUConn_PastureCost              0.1
* Small dummy cost to keep one of these zero:
    LUConn_LandUseCO2Emissions      0.001
    LUConn_LandUseCO2Sink           0.001
    LUConn_NaturalCO2Emissions      0.001
    LUConn_NaturalCO2Sink           0.001
/;

Parameter data_LUSE_emission(P,E)        /
    LUConn_LandUseCO2Emissions     . CO2LU       1
    LUConn_LandUseCO2Sink          . CO2LU      -1
    LUConn_NaturalCO2Emissions     . CO2nat      1
    LUConn_NaturalCO2Sink          . CO2nat     -1
    LUConn_CroplandCH4Emissions    . CH4         1
    LUConn_CroplandN2OEmissions    . N2O         1
    LUConn_LivestockCH4Emissions   . CH4         1
    LUConn_LivestockN2OEmissions   . N2O         1
/;



***************************************************************************************************
*
*   Assign input data to processes
*

OutputActivityRatio(r,p,c,mdfl,t)$data_LUSE_Output(p,c) = data_LUSE_Output(p,c);
VariableCost(r,p,mdfl,t)$LUSE_TECH(P) = data_LUSE_varcost(P);

AvailabilityFactor(r,p,t)$LUSE_TECH(P) = data_LUSE_availability(P);
CapacityFactor(r,p,l,t)$LUSE_TECH(P) = data_LUSE_capacityfactor(P);
OperationalLife(r,p)$LUSE_TECH(P) = data_LUSE_lifetime(P);
CapacityToActivityUnit(r,p)$LUSE_TECH(P) = 1;

EmissionActivityRatio(r,p,e,mdfl,t)$LUSE_TECH(P) = data_LUSE_emission(P,E);


************************************************************
* Assign production to the level given by the LU module

Equations
    EQ_LUConn_Crop(t)
    EQ_LUConn_Wood(t)
    EQ_LUConn_WoodLogs(t)
    EQ_LUConn_PulpWood(t)
    EQ_LUConn_FoodCrops(t)
    EQ_LUConn_FoodEggs(t)
    EQ_LUConn_FoodMilk(t)
    EQ_LUConn_SecForRegen(t) 
    EQ_LUConn_CroplandCost(t) 
    EQ_LUConn_PastureCost(t)
    EQ_LUConn_FoodBeef(t)
    EQ_LUConn_FoodShoat(t)
    EQ_LUConn_FoodPork(t)
    EQ_LUConn_FoodPoultry(t)
    EQ_LUConn_BiomassAgriResid(t)
    EQ_LUConn_BiomassWoodResid(t)
    EQ_LUConn_LandUseCO2Ems(t,m)
    EQ_LUConn_NaturalCO2Ems(t,m)
    EQ_LUConn_CroplandCH4Ems(t)
    EQ_LUConn_CroplandN2OEms(t)
    EQ_LUConn_LivestockCH4Ems(t)
    EQ_LUConn_LivestockN2OEms(t)
;

* Constrain process outputs to land-use module variables.
* Conversions from LU_harv_xxxx (in mln. m3) to mass (Mt) or energy (PJ). For bioenergy, assume 18 GJ/t heating value (0% moisture).
EQ_LUConn_Crop(t)..             ActivityAnnual('World','LUConn_BIOM_Crop',t)/18
                                + ActivityAnnual('World','LUConn_BiomassCrop',t) =E= LU_harv_EnerCrops(t);
* Wood harvesting:
EQ_LUConn_Wood(t)..             ActivityAnnual('World','LUConn_BIOM_Wood',t)     =E= 18 * sum(pool, LU_WoodDens(pool) * LU_harv_wast(t,pool));
EQ_LUConn_WoodLogs(t)..         ActivityAnnual('World','LUConn_WoodLogs',t)      =E= sum(pool, LU_WoodDens(pool) * LU_harv_logs(t,pool));
EQ_LUConn_PulpWood(t)..         ActivityAnnual('World','LUConn_PulpWood',t)      =E= sum(pool, LU_WoodDens(pool) * LU_harv_pulp(t,pool));

* Harvest and cropland residues:
EQ_LUConn_BiomassAgriResid(t).. ActivityAnnual('World','LUConn_BIOM_AgriResid',t)/18 +
                                ActivityAnnual('World','LUConn_AgriResid',t)     =E= sum(pool, LU_harv_CropResid(t,pool));
EQ_LUConn_BiomassWoodResid(t).. ActivityAnnual('World','LUConn_BIOM_WoodResid',t)/18 +
                                ActivityAnnual('World','LUConn_WoodResid',t)      =E= sum(pool, LU_harv_WoodResid(t,pool));


EQ_LUConn_FoodCrops(t)..        ActivityAnnual('World','LUConn_FoodCrops',t)     =E= LU_harv_FoodCrops(t);
EQ_LUConn_FoodEggs(t)..         ActivityAnnual('World','LUConn_FoodEggs',t)      =E= LVST_product_output(t, 'LVST_Eggs');
EQ_LUConn_FoodMilk(t)..         ActivityAnnual('World','LUConn_FoodMilk',t)      =E= LVST_product_output(t, 'LVST_Milk');
* For meat:                                                                                  
EQ_LUConn_FoodBeef(t)..         ActivityAnnual('World','LUConn_FoodBeef',t)      =E= LVST_product_output(t, 'LVST_Beef');
EQ_LUConn_FoodShoat(t)..        ActivityAnnual('World','LUConn_FoodShoat',t)     =E= LVST_product_output(t, 'LVST_Shoat');
EQ_LUConn_FoodPork(t)..         ActivityAnnual('World','LUConn_FoodPork',t)      =E= LVST_product_output(t, 'LVST_Pork');
EQ_LUConn_FoodPoultry(t)..      ActivityAnnual('World','LUConn_FoodPoultry',t)   =E= LVST_product_output(t, 'LVST_Poultry');


* Cost for secondary forest regenration:
EQ_LUConn_SecForRegen(t)..      ActivityAnnual('World','LUConn_SecdFRegen',t) =E= LU_regen_area(t);
* Small cost for cropland and pasture to discourage their use without the need to produce anything
EQ_LUConn_CroplandCost(t)..   ActivityAnnual('World','LUConn_CroplandCost',t) =E= sum(pool, LU_Area(t,pool,'crops'));
EQ_LUConn_PastureCost(t)..     ActivityAnnual('World','LUConn_PastureCost',t) =E= sum(pool, LU_Area(t,pool,'pastr'));

* Emissions and carbon sinks from CLASH to SuCCESs
EQ_LUConn_LandUseCO2Ems(t,m)$(mdfl(m))..
    ActivityAnnualByMode('World','LUConn_LandUseCO2Emissions',m,t)
    - ActivityAnnualByMode('World','LUConn_LandUseCO2Sink',m,t)    =E= LU_NetCO2LandUse(t);
    
EQ_LUConn_NaturalCO2Ems(t,m)$(mdfl(m))..
    ActivityAnnualByMode('World','LUConn_NaturalCO2Emissions',m,t)
    - ActivityAnnualByMode('World','LUConn_NaturalCO2Sink',m,t)    =E= LU_NetCO2Terrestrial(t) - LU_NetCO2LandUse(t);

EQ_LUConn_CroplandCH4Ems(t)..          ActivityAnnual('World','LUConn_CroplandCH4Emissions'   ,t) =E= sum(pool, LU_Emis_CropCH4(t,pool));
EQ_LUConn_CroplandN2OEms(t)..          ActivityAnnual('World','LUConn_CroplandN2OEmissions'   ,t) =E= sum(pool, LU_Emis_CropN2O(t,pool));
EQ_LUConn_LivestockCH4Ems(t)..         ActivityAnnual('World','LUConn_LivestockCH4Emissions'  ,t) =E= LVST_emissions_CH4(t);
EQ_LUConn_LivestockN2OEms(t)..         ActivityAnnual('World','LUConn_LivestockN2OEmissions'  ,t) =E= LVST_emissions_N2O(t);

