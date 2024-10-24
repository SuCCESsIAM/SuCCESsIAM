
***************************************************************************************************
* Time periods and model timeframe:

set     TIME    / 2020,2030,2040,2050,2060,2070,2080,2090,2100 /;

* tfirst and tlast are the first and last model period
SETS tfirst(t), tlast(t);
tfirst(t) = yes$(ord(t) eq 1);
tlast(t)  = yes$(ord(t) eq card(t));

* Period duration:
parameter dur(t);
dur(t) = sum(tt$(ord(tt) = ord(t)+1), tt.val) - t.val;
dur(t)$(ord(t)=card(t)) = t.val - sum(tt$(ord(tt) = ord(t)-1), tt.val);


***************************************************************************************************
* Region definition:

set     REGION  / World /;


***************************************************************************************************
* Commodity definitions:

set     COMMODITY 'Set of commodities' /
* energy carriers:
                    COAL, NGAS, NGLs, Ethane, CRUD, LPGs, GSLN, OILL, OILH, URAN, BIOM, BIOG, BGSL, BIOL, WSTE, HYDR, ELECGen, ELEC, HEAT, STEA,
* captured CO2:
                    CO2_CCS,
* intermediate materials and chemical commodities:
                    PulpWood, Pulp_mech, Pulp_chem, Pulp_recy, 
                    Alumina, 
                    ETHYLENE, PROPYLENE, C4OLEFINS, BTX, AMMONIA, METHANOL, OTHERCHEM,
                    BiomassCrop, BiomassAgriResid, BiomassForResid,
* Recycled material scrap commodities:
                    ScrapSteel, ScrapAluminium, ScrapCopper, ScrapNickel, ScrapPaper,
* Industrial production demand commodities:
                  Steel, Cement, Aluminium, Copper, Nickel,
                  Paper, Board, Tissue,
                  WoodLogs,
* Chemical industry demand commodities:
                  ThermoPlst, ThermoSets, SolventsEtc, OtherPetro, NitroFertil, OthChemDmd,
* Other industry energy demand:
                  OtherIndOil, OtherIndGas, OtherIndSolid, OtherIndElec, OtherIndStea,
* Transportation demand commodities:                    
                  PassengerCarsPkm, PassengerBusPkm, PassengerRailPkm, PassengerDomAviPkm, PassengerIntAviPkm,
                  FreightRoadTkm, FreightRailTkm, FreightWaterTkm
,
* Buildings demand commodities:
                  BLDN_ELEC, BLDN_LIQUID, BLDN_GASES, BLDN_SOLID, BLDN_HEAT,
* Food demand commodities:
                 FoodCrops, FoodBeef, FoodShoat, FoodPork, FoodPoultry, FoodMilk, FoodEggs
/;


* By default, commodities have balances as inequalities:
CommodityHasEqualityBalance(C) = no;
* If needed, selected commodities can have balances as equalities:
CommodityHasEqualityBalance('CO2_CCS') = yes;


* Commodity descriptions (with units):
Set DESC_COMMODITY(COMMODITY) 'Description and units (per year) for commodities' /
* energy carriers:
                    COAL                    'Coal             (PJ)'
                    NGAS                    'Natural gas      (PJ)'
                    NGLs                    'Natrual gas liq. (PJ)'
                    Ethane                  'Ethane           (PJ)'
                    CRUD                    'Crude oil        (PJ)'
                    LPGs                    'LPG              (PJ)'
                    GSLN                    'Gasoline         (PJ)'
                    OILL                    'Fuel oil, light  (PJ)'
                    OILH                    'Fuel oil, heavy  (PJ)'
                    URAN                    'Uranium          (PJ)'
                    BIOM                    'Biomass          (PJ)'
                    BIOG                    'Biogas           (PJ)'
                    BGSL                    'Biogasoline      (PJ)'
                    BIOL                    'Biodiesel        (PJ)'
                    WSTE                    'Waste            (PJ)'
                    HYDR                    'Hydroge          (PJ)'
                    ELECGen                 'Electricity, generated (PJ)'
                    ELEC                    'Electricity, distributed (PJ)'
                    HEAT                    'Heat (lo temp.)  (PJ)'
                    STEA                    'Steam (hi temp.) (PJ)'
* captured CO2:
                    CO2_CCS                 'CCS Captured CO2'
* intermediate materials and chemical commodities:
                    ScrapSteel              'Steel scrap      (Mt)'
                    ScrapAluminium          'Aluminium scrap  (Mt)'
                    ScrapCopper             'Copper scrap     (Mt)'
                    ScrapNickel             'Nickel scrap     (Mt)'
                    ScrapPaper              'Recycled paper   (Mt)'
                    Alumina                 'Alumina          (Mt)'
                    PulpWood                'Pulpwood         (Mt)'
                    Pulp_mech               'Pulp, mechanical (Mt)'
                    Pulp_chem               'Pulp, chemical   (Mt)'
                    Pulp_recy               'Pulp, recycled   (Mt)'
                    ETHYLENE                'Ethylene         (Mt)'
                    PROPYLENE               'Propylene        (Mt)'
                    C4OLEFINS               'C4 olefins       (Mt)'
                    BTX                     'BTX              (Mt)'
                    AMMONIA                 'Ammonia          (Mt)'
                    METHANOL                'Methanol         (Mt)'
                    OTHERCHEM               'Other chemicals  (Mt)'
                    BiomassCrop             'Biomass crops    (Mt)'
                    BiomassAgriResid        'Biomass agri residue (Mt)'
                    BiomassForResid         'Biomass forestry residue (Mt)'
* Transportation demand commodities:
                  PassengerCarsPkm          'Passenger car demand (mln. pkm)'
                  PassengerBusPkm           'Passenger bus demand (mln. pkm)'
                  PassengerRailPkm          'Passenger rail demand (mln. pkm)'
                  PassengerDomAviPkm        'Passenger dom. aviation demand (mln. pkm)'
                  PassengerIntAviPkm        'Passenger int. aviation demand (mln. pkm)'
                  FreightRoadTkm            'Freight road demand (mln. tkm)'
                  FreightRailTkm            'Freight rail demand (mln. tkm)'
                  FreightWaterTkm           'Freight shipping demand (mln. tkm)'
* Industrial production demand commodities:
                  Steel                     'Steel           (Mt)'
                  Cement                    'Cement          (Mt)'
                  Aluminium                 'Aluminium       (Mt)'
                  Copper                    'Copper          (Mt)'
                  Nickel                    'Nickel          (Mt)'
                  Paper                     'Paper           (Mt)'
                  Board                     'Board           (Mt)'
                  Tissue                    'Tissue          (Mt)'
                  WoodLogs                  'Wood logs       (Mt)'
* Chemical industry demand commodities:
                  ThermoPlst                'Thermoplastics  (Mt)'
                  ThermoSets                'Thermosets      (Mt)'
                  SolventsEtc               'Solvents etc.   (Mt)'
                  OtherPetro                'Other petrochem (Mt)'
                  NitroFertil               'Nitrogen fertilizer (Mt)'
                  OthChemDmd                'Other chemicals (Mt)'
* Other industry energy demand:
                  OtherIndOil               'Other industries oil demand (Mt)'
                  OtherIndGas               'Other industries gas demand (Mt)'
                  OtherIndSolid             'Other industries solid fuel demand (Mt)'
                  OtherIndElec              'Other industries electricity demand (Mt)'
                  OtherIndStea              'Other industries steam demand (Mt)'
* Buildings demand commodities:
                  BLDN_ELEC                 'Buildings electricity demand (PJ)'
                  BLDN_LIQUID               'Buildings liquid fuel demand (PJ)'
                  BLDN_GASES                'Buildings gaseous fuel demand (PJ)'
                  BLDN_SOLID                'Buildings soild fuel demand (PJ)'
                  BLDN_HEAT                 'Buildings heat demand (PJ)'
* Food demand
                 FoodCrops                  'Food, crops   (Mt)'
                 FoodBeef                   'Food, beef    (Mt)'
                 FoodShoat                  'Food, shoat   (Mt)'
                 FoodPork                   'Food, pork    (Mt)'
                 FoodPoultry                'Food, poultry (Mt)'
                 FoodMilk                   'Food, milk    (Mt)'
                 FoodEggs                   'Food, eggs    (Mt)'
/;


***************************************************************************************************
* Emission definitions:

set     EMISSION /
    CO2FFI      'CO2 net emissions from fossil-fuels and industry',
    CO2LU       'CO2 net emissions from managed lands and deforestation',
    CO2nat      'CO2 net emissions from natural lands (excluding deforestation)',
    CH4         'CH4 emissions',
    N2O         'N2O emissions'
/;


***************************************************************************************************
* Processes are defined in the sector-specific input files.

set     PROCESS 'Set of processes' //;
* Process descriptions (can be defined in the sector-specific input files):
PARAMETER DESC_PROCESS(PROCESS);

* Storages are defined later, as well.
set     STORAGE /  /;


* Operating modes for processes:
set     MODE_OF_OPERATION   / m1*m5 /;
* Default operating mode: m1
set     mdfl(m)             / m1 /;



***************************************************************************************************
* Discounting:

DiscountRate(r) = 0.05;


***************************************************************************************************
* Salvage value depreciation method

DepreciationMethod(r) = 1;


***************************************************************************************************
* Trade

TradeRoute(r,rr,c,t) = 0;


***************************************************************************************************
* Timeslices and seasons - not used in SuCCESs, but need to be defined

* SuCCESs doesn't use timeslices, so the only timeslice is 'ANNUAL'
set     TIMESLICE           / ANNUAL /;
set     SEASON / 1 /;
set     DAYTYPE / 1 /;
set     DAILYTIMEBRACKET / 1 /;

parameter Conversionls(l,ls) / ANNUAL.1 1 /;
parameter Conversionld(l,ld) / ANNUAL.1 1 /;
parameter Conversionlh(l,lh) / ANNUAL.1 1 /;

YearSplit(L,t) = 1;
DaySplit(t,lh) = 1;
DaysInDayType(t,ls,ld) = 1;


***************************************************************************************************
* Additional definitions/defaults that need to be defined:

EmissionAnnualExogenous(r,e,t) = 0;
EmissionAnnualLimit(r,e,t) = INF;
EmissionLimitCumulative(r,e) = INF;
EmissionPenalty(r,e,t) = 0;

FixedCost(r,p,t) = NO;

CapacityTotalMax(r,p,t) = INF;
CapacityTotalMin(r,p,t) = NO;
CapacityNewMax(r,p,t) = INF;
CapacityNewMin(r,p,t) = 0;

ActivityAnnualMax(r,p,t) = INF;
ActivityAnnualMin(r,p,t) = 0;
ActivityCumulativeMax(r,p) = INF;
ActivityCumulativeMin(r,p) = 0;

ProcessMaxMarketShare(R,P,C,T) = NO;



***************************************************************************************************
*
*   Storages
*

* ProcessToStorage[r,p,s,m]
* Binary parameter linking a technology to the storage facility it charges.
* It has value 1 if the technology and the storage facility are linked, 0 otherwise.
parameter ProcessToStorage //;

* ProcessFromStorage[r,p,s,m]
* Binary parameter linking a storage facility to the technology it feeds.
* It has value 1 if the technology and the storage facility are linked, 0 otherwise.
parameter ProcessFromStorage //;

* StorageLevelStart[r,s]
* Level of storage at the beginning of first modelled year, in units of activity.
StorageLevelStart(r,s) = 0;

*param StorageMaxChargeRate default 99:=
StorageMaxChargeRate(r,s) = INF;

*param StorageMaxDischargeRate default 99:=
StorageMaxDischargeRate(r,s) = INF;

*param MinStorageCharge default 0. :=
StorageMinCharge(r,s,t) = 0;

*param OperationalLifeStorage default                        99        :=
StorageOperationalLife(r,s) = 999;

*param ResidualStorageCapacity default                        999        :=
StorageResidualCapacity(r,s,t) = 0;

*param CapitalCostStorage default                        999        :=
StorageCapitalCost(r,s,t) = 0;


