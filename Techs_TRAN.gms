
set     PROCESS / 
TRAN_PASS_CarGasoline
TRAN_PASS_CarDiesel
TRAN_PASS_CarBioliq
TRAN_PASS_CarHEV
TRAN_PASS_CarPHEV
TRAN_PASS_CarBEV
TRAN_PASS_BusDiesel
TRAN_PASS_BusBioliq
TRAN_PASS_BusBEV
TRAN_PASS_RailDiesel
TRAN_PASS_RailElectric
TRAN_PASS_AviationJetfuel_Int
TRAN_PASS_AviationJetfuel_Dom
TRAN_PASS_AviationBiofuel_Int
TRAN_PASS_AviationBiofuel_Dom
*
TRAN_FRGT_VanDiesel
TRAN_FRGT_VanBEV
TRAN_FRGT_TruckDiesel
TRAN_FRGT_TruckBioliq
TRAN_FRGT_TruckBEV
TRAN_FRGT_RailDiesel
TRAN_FRGT_RailElectric
TRAN_FRGT_ShipsHFO
TRAN_FRGT_ShipsMDO 
TRAN_FRGT_ShipsLNG
TRAN_FRGT_ShipsBio   
/;


set TRAN_TECH(P)/
TRAN_PASS_CarGasoline
TRAN_PASS_CarDiesel
TRAN_PASS_CarBioliq
TRAN_PASS_CarHEV
TRAN_PASS_CarPHEV
TRAN_PASS_CarBEV
TRAN_PASS_BusDiesel
TRAN_PASS_BusBioliq
TRAN_PASS_BusBEV
TRAN_PASS_RailDiesel
TRAN_PASS_RailElectric
TRAN_PASS_AviationJetfuel_Int
TRAN_PASS_AviationJetfuel_Dom
TRAN_PASS_AviationBiofuel_Int
TRAN_PASS_AviationBiofuel_Dom
*
TRAN_FRGT_VanDiesel
TRAN_FRGT_VanBEV
TRAN_FRGT_TruckDiesel
TRAN_FRGT_TruckBioliq
TRAN_FRGT_TruckBEV
TRAN_FRGT_RailDiesel
TRAN_FRGT_RailElectric
TRAN_FRGT_ShipsHFO
TRAN_FRGT_ShipsMDO 
TRAN_FRGT_ShipsLNG
TRAN_FRGT_ShipsBio   
/;


*************************************************************************************************************
*
*   Input data
*
*
* Explanation of parameters:
*   - Initial Capacity        = Initial Capacity (total number around 2020) (number of vehicles)
*   - Lifetime                = Lifetime of the vehicle
*   - Capcost                 = Capital Cost, price of buying this type of vehicle (not considered for all vehicle types)
*   - Capacity Activity Unit  = How much of the (maximum) capacity is really being used
*   - Output Activiy Ratio    = service km/vehicle km (e.g. persons travelling per vehicle km)
*   - Vehicle input           = Amount of energy required to provide one unit of service (e.g. passenger-km or tonne-km)
*   - Emission factors        = amount of emissions per unit of energy provided for a service (pkm or tkm)
*
*
* Data sorted by service (passenger or freight transportation) and technology in order of vehicle size.
*
*************************************************************************************************************



* Initial Capacity (total number around 2020) (number of vehicles)
* Source: EIA, IEA, Wikipedia, sustainable-bus.com
Parameter data_TRAN_initialcapacity(P) /
TRAN_PASS_CarGasoline              1036765217
TRAN_PASS_CarDiesel                259191304
TRAN_PASS_CarHEV                   14043478
TRAN_PASS_CarPHEV                  3346713
TRAN_PASS_CarBEV                   6850327
*TRAN_PASS_BusDiesel                2400000
*TRAN_PASS_BusBEV                   600000
                                   
*TRAN_FRGT_VanBEV                   435000
*TRAN_FRGT_TruckBEV                 31000
/;

* Convert to millions of vehicles:
data_TRAN_initialcapacity(P) = data_TRAN_initialcapacity(P) / 10**6;


* Lifetimes (years)
* Source: own estimates + internet search
Parameter data_TRAN_lifetime(P) /
TRAN_PASS_CarGasoline              20
TRAN_PASS_CarDiesel                20
TRAN_PASS_CarBioliq                20
TRAN_PASS_CarHEV                   20
TRAN_PASS_CarPHEV                  20
TRAN_PASS_CarBEV                   20
TRAN_PASS_BusDiesel                9999
TRAN_PASS_BusBioliq                9999 
TRAN_PASS_BusBEV                   9999
TRAN_PASS_RailDiesel               9999
TRAN_PASS_RailElectric             9999
TRAN_PASS_AviationJetfuel_Int      9999
TRAN_PASS_AviationJetfuel_Dom      9999
TRAN_PASS_AviationBiofuel_Int      9999
TRAN_PASS_AviationBiofuel_Dom      9999
*
TRAN_FRGT_VanDiesel                9999
TRAN_FRGT_VanBEV                   9999
TRAN_FRGT_TruckDiesel              9999
TRAN_FRGT_TruckBioliq              9999
TRAN_FRGT_TruckBEV                 9999
TRAN_FRGT_RailDiesel               9999
TRAN_FRGT_RailElectric             9999
TRAN_FRGT_ShipsHFO                 9999
TRAN_FRGT_ShipsMDO                 9999
TRAN_FRGT_ShipsLNG                 9999
TRAN_FRGT_ShipsBio                 9999
/;


* Capital Cost (sports cars excluded) (�)
* Source: IEA, carsdirect.com and more
Parameter data_TRAN_capcost(P) /
TRAN_PASS_CarGasoline              30395
TRAN_PASS_CarDiesel                32895
TRAN_PASS_CarBioliq                32895
TRAN_PASS_CarHEV                   37453
TRAN_PASS_CarPHEV                  43260
TRAN_PASS_CarBEV                   34610
/;


* Capacity Acitivity Unit 
* Source: own estimates + internet search
Parameter data_TRAN_CapacityActivityUnit(P) /
TRAN_PASS_CarGasoline              15000
TRAN_PASS_CarDiesel                15000
TRAN_PASS_CarBioliq                15000
TRAN_PASS_CarHEV                   15000
TRAN_PASS_CarPHEV                  15000
TRAN_PASS_CarBEV                   15000
TRAN_PASS_BusDiesel                241015
TRAN_PASS_BusBioliq                241015 
TRAN_PASS_BusBEV                   241015
TRAN_PASS_RailDiesel               1
TRAN_PASS_RailElectric             1
TRAN_PASS_AviationJetfuel_Int      1
TRAN_PASS_AviationJetfuel_Dom      1
TRAN_PASS_AviationBiofuel_Int      1
TRAN_PASS_AviationBiofuel_Dom      1
                                   
TRAN_FRGT_VanDiesel                1
TRAN_FRGT_VanBEV                   1
TRAN_FRGT_TruckDiesel              1
TRAN_FRGT_TruckBioliq              1
TRAN_FRGT_TruckBEV                 1
TRAN_FRGT_RailDiesel               1
TRAN_FRGT_RailElectric             1
TRAN_FRGT_ShipsHFO                 1
TRAN_FRGT_ShipsMDO                 1
TRAN_FRGT_ShipsLNG                 1
TRAN_FRGT_ShipsBio                 1
/;




* Input Activity Ratio (energy consumption) for vehicles (GJ/vkm, GJ/tkm or GJ/pkm)
* Source: See Transport_technologies.xlsx
Parameter data_TRAN_vehicleinput(p,c) /
* GJ per vehicle-km
TRAN_PASS_CarGasoline              . GSLN      0.002546
TRAN_PASS_CarDiesel                . OILL      0.002111
TRAN_PASS_CarBioliq                . BIOL      0.002546
TRAN_PASS_CarHEV                   . GSLN      0.001288
TRAN_PASS_CarPHEV                  . GSLN      0.000621
TRAN_PASS_CarPHEV                  . ELEC      0.000505
TRAN_PASS_CarBEV                   . ELEC      0.000735
TRAN_PASS_BusDiesel                . OILL      0.022692
TRAN_PASS_BusBioliq                . BIOL      0.022692
TRAN_PASS_BusBEV                   . ELEC      0.005040
* GJ per passenger-km
TRAN_PASS_RailDiesel               . OILL      0.000145
TRAN_PASS_RailElectric             . ELEC      0.000145
TRAN_PASS_AviationJetfuel_Int      . GSLN      0.001424
TRAN_PASS_AviationJetfuel_Dom      . GSLN      0.001743
TRAN_PASS_AviationBiofuel_Int      . BIOL      0.001424
TRAN_PASS_AviationBiofuel_Dom      . BIOL      0.001743
* GJ per vehicle-km
TRAN_FRGT_VanDiesel                . OILL      0.005270
TRAN_FRGT_VanBEV                   . ELEC      0.000810
TRAN_FRGT_TruckDiesel              . OILL      0.018007  
TRAN_FRGT_TruckBioliq              . BIOL      0.018007  
TRAN_FRGT_TruckBEV                 . ELEC      0.003875
* GJ per tonne-km
TRAN_FRGT_RailDiesel               . OILL      0.000135
TRAN_FRGT_RailElectric             . ELEC      0.000135
TRAN_FRGT_ShipsHFO                 . OILH      0.000066
TRAN_FRGT_ShipsMDO                 . OILL      0.000063
TRAN_FRGT_ShipsLNG                 . NGAS      0.000057
TRAN_FRGT_ShipsBio                 . BioL      0.000057
/;


Parameter data_TRAN_vehicleinput_t(p,c,t);

* Assume 1.5% p.a. improvement in aviation fuel efficiency (source: IEA Tracking Aviation, IEA ETP 2017)
data_TRAN_vehicleinput_t('TRAN_PASS_AviationJetfuel_Int','GSLN',t) = (1-0.015)**(t.val - 2020)*data_TRAN_vehicleinput('TRAN_PASS_AviationJetfuel_Int','GSLN');
data_TRAN_vehicleinput_t('TRAN_PASS_AviationJetfuel_Dom','GSLN',t) = (1-0.015)**(t.val - 2020)*data_TRAN_vehicleinput('TRAN_PASS_AviationJetfuel_Dom','GSLN');

data_TRAN_vehicleinput_t('TRAN_PASS_AviationBiofuel_Int','BioL',t) = (1-0.015)**(t.val - 2020)*data_TRAN_vehicleinput('TRAN_PASS_AviationBiofuel_Int','BioL');
data_TRAN_vehicleinput_t('TRAN_PASS_AviationBiofuel_Dom','BioL',t) = (1-0.015)**(t.val - 2020)*data_TRAN_vehicleinput('TRAN_PASS_AviationBiofuel_Dom','BioL');

* Assume bit more moderate improvement (1% p.a.) for shipping
data_TRAN_vehicleinput_t('TRAN_FRGT_ShipsHFO','OILH',t) = (1-0.010)**(t.val - 2020)*data_TRAN_vehicleinput('TRAN_FRGT_ShipsHFO','OILH');
data_TRAN_vehicleinput_t('TRAN_FRGT_ShipsMDO','OILL',t) = (1-0.010)**(t.val - 2020)*data_TRAN_vehicleinput('TRAN_FRGT_ShipsMDO','OILL');
data_TRAN_vehicleinput_t('TRAN_FRGT_ShipsLNG','NGAS',t) = (1-0.010)**(t.val - 2020)*data_TRAN_vehicleinput('TRAN_FRGT_ShipsLNG','NGAS');
data_TRAN_vehicleinput_t('TRAN_FRGT_ShipsBio','BioL',t) = (1-0.010)**(t.val - 2020)*data_TRAN_vehicleinput('TRAN_FRGT_ShipsBio','BioL');


* Transportation demand categories:
* DEM_PASS_ROAD  PassengerRailPkm  PassengerDomAviPkm   PassengerIntAviPkm
* FreightRoadTkm  FreightRailTkm  DEM_FRGT_AVIA  FreightWaterTkm

* Output Activiy Ratio (service km/vehicle km (e.g. persons travelling per vehicle km))
Parameter data_TRAN_OutputActivityRatio(P,C) /
* Passenger-km per vehicle-km
TRAN_PASS_CarGasoline              . PassengerCarsPkm    1.6
TRAN_PASS_CarDiesel                . PassengerCarsPkm    1.6
TRAN_PASS_CarBioliq                . PassengerCarsPkm    1.6
TRAN_PASS_CarHEV                   . PassengerCarsPkm    1.6
TRAN_PASS_CarPHEV                  . PassengerCarsPkm    1.6
TRAN_PASS_CarBEV                   . PassengerCarsPkm    1.6
TRAN_PASS_BusDiesel                . PassengerBusPkm    21
TRAN_PASS_BusBioliq                . PassengerBusPkm    21
TRAN_PASS_BusBEV                   . PassengerBusPkm    21
* Rail and aviation modelled directly through passenger-kilometers
TRAN_PASS_RailDiesel               . PassengerRailPkm    1
TRAN_PASS_RailElectric             . PassengerRailPkm    1 
TRAN_PASS_AviationJetfuel_Int      . PassengerIntAviPkm    1
TRAN_PASS_AviationJetfuel_Dom      . PassengerDomAviPkm    1
TRAN_PASS_AviationBiofuel_Int      . PassengerIntAviPkm    1
TRAN_PASS_AviationBiofuel_Dom      . PassengerDomAviPkm    1
* Tonne-km per vehicle-km
TRAN_FRGT_VanDiesel                . FreightRoadTkm    0.74
TRAN_FRGT_VanBEV                   . FreightRoadTkm    0.74
TRAN_FRGT_TruckDiesel              . FreightRoadTkm    11
TRAN_FRGT_TruckBioliq              . FreightRoadTkm    11
TRAN_FRGT_TruckBEV                 . FreightRoadTkm    7.9
* Rail and ships modelled directly through tonne-kilometers
TRAN_FRGT_RailDiesel               . FreightRailTkm    1
TRAN_FRGT_RailElectric             . FreightRailTkm    1                   
TRAN_FRGT_ShipsHFO                 . FreightWaterTkm    1
TRAN_FRGT_ShipsMDO                 . FreightWaterTkm    1
TRAN_FRGT_ShipsLNG                 . FreightWaterTkm    1
TRAN_FRGT_ShipsBio                 . FreightWaterTkm    1
/;


* Emission Factors for mobile combustion (t/GJ or Mt/PJ), gas and diesel cars in Mt/Mvkm
* Source: IPCC guidelines for GHG inventories (2006), Table 3.2.2, TABLE 3.4.2, TABLE 3.5.2
Table data_TRAN_emissionfactors(P,E)
                                CH4               N2O
TRAN_PASS_CarGasoline           0.0000025         0.000008                                          
TRAN_PASS_CarDiesel             0.0000039         0.0000039
TRAN_PASS_CarBioliq             0.0000025         0.000008                                          
TRAN_PASS_CarHEV                0.0000019         0.0000029
TRAN_PASS_CarPHEV               0.0000019         0.0000029
TRAN_PASS_CarBEV                0                 0        
TRAN_PASS_BusDiesel             0.0000039         0.0000039
TRAN_PASS_BusBioliq             0.0000039         0.0000039
TRAN_PASS_BusBEV                0                 0
*
TRAN_PASS_RailDiesel            0.00000415        0.0000286
*
TRAN_PASS_AviationJetfuel_Int   0.0000005         0.000002
TRAN_PASS_AviationJetfuel_Dom   0.0000005         0.000002
TRAN_PASS_AviationBiofuel_Int   0.0000005         0.000002
TRAN_PASS_AviationBiofuel_Dom   0.0000005         0.000002            
*
TRAN_FRGT_VanDiesel             0.00000390000     0.00000390000
TRAN_FRGT_VanBEV                0                 0        
TRAN_FRGT_TruckDiesel           0.00000390000     0.00000390000
TRAN_FRGT_TruckBioliq           0.00000390000     0.00000390000
TRAN_FRGT_TruckBEV              0                 0
*
TRAN_FRGT_RailDiesel            0.00000415        0.0000286
TRAN_FRGT_RailElectric
TRAN_FRGT_ShipsHFO              0.000007          0.000002
TRAN_FRGT_ShipsMDO              0.000007          0.000002
TRAN_FRGT_ShipsLNG              0.000007          0.000002
TRAN_FRGT_ShipsBio              0.000007          0.000002
;

* Convert emission factors from t/GJ to t/activity
data_TRAN_emissionfactors(P,E) = data_TRAN_emissionfactors(P,E) * sum(c,data_TRAN_vehicleinput(p,c));


Parameter data_TRAN_startyear(P) /
TRAN_PASS_CarBioliq               2040
TRAN_PASS_AviationBiofuel_Int     2040
TRAN_PASS_AviationBiofuel_Dom     2040
TRAN_FRGT_ShipsBio                2030
TRAN_PASS_BusBEV                  2030
TRAN_PASS_BusBioliq               2030
TRAN_FRGT_VanBEV                  2030
TRAN_FRGT_TruckBioliq             2030
TRAN_FRGT_TruckBEV                2030
/;

ProcessMaxMarketShare(R,'TRAN_PASS_BusBEV','PassengerBusPkm',T) = min(1, 0.3*(ord(t)-1));
ProcessMaxMarketShare(R,'TRAN_FRGT_VanBEV','FreightRoadTkm',T) = min(1, 0.3*(ord(t)-1));
ProcessMaxMarketShare(R,'TRAN_FRGT_TruckBEV','FreightRoadTkm',T) = min(1, 0.3*(ord(t)-1));


***************************************************************************************************
*
*   Assign input data to Osemosys techs 
*


OperationalLife(r,p)$TRAN_TECH(P) = data_TRAN_lifetime(P);

CapitalCost(r,p,t)$TRAN_TECH(P)   = data_TRAN_capcost(P);

EmissionActivityRatio(r,p,e,mdfl,t)$(TRAN_TECH(P) and data_TRAN_emissionfactors(P,E)) = data_TRAN_emissionfactors(P,E);

* Assigning input commodities to processes (and how much of the commodities are being consumed by the process to generate 1 unit of output)
InputActivityRatio(r,p,c,mdfl,t)$(TRAN_TECH(P) and data_TRAN_vehicleinput(p,c))         = data_TRAN_vehicleinput(P,C);
InputActivityRatio(r,p,c,mdfl,t)$(TRAN_TECH(P) and data_TRAN_vehicleinput_t(p,c,t))     = data_TRAN_vehicleinput_t(P,C,t);

OutputActivityRatio(r,p,c,mdfl,t)$(TRAN_TECH(P) and data_TRAN_OutputActivityRatio(p,c)) = data_TRAN_OutputActivityRatio(P,C);


AvailabilityFactor(r,p,t)$TRAN_TECH(P)   =  1;
CapacityFactor(r,p,l,t)$TRAN_TECH(P) = 1;

CapacityToActivityUnit(r,p)$TRAN_TECH(P) = data_TRAN_CapacityActivityUnit(p);

ProcessStartYear(R,P)$(TRAN_TECH(P) and data_TRAN_startyear(P)) = data_TRAN_startyear(P);


* TODO: needs to consider vehicle lifetimes, but here's a crude way:
CapacityResidual(r,p,t)$(TRAN_TECH(P) and data_TRAN_initialcapacity(P)) = data_TRAN_initialcapacity(p) * max(0, 1 - (T.val-2020)/OperationalLife(r,p) );

