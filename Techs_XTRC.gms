***************************************************************************************************
*
*   Energy extraction technologies
*
*************************************************************************************************************


set     PROCESS /
* for the proven remaining resources
XTRC_Coal_Afri
XTRC_Coal_AsiP
XTRC_Coal_LAme
XTRC_Coal_Eura
XTRC_Coal_Euro
XTRC_Coal_MEas
XTRC_Coal_NAme

XTRC_NGas_Afri
XTRC_NGas_Asia
XTRC_NGas_LAme
XTRC_NGas_Eura
XTRC_NGas_Euro
XTRC_NGas_MEas
XTRC_NGas_NAme

XTRC_CRUD_Afri
XTRC_CRUD_Asia
XTRC_CRUD_LAme
XTRC_CRUD_Eura
XTRC_CRUD_Euro
XTRC_CRUD_MEas
XTRC_CRUD_NAme

XTRC_URAN_Wrld
XTRC_WSTE_Wrld

* Oil 'backstop'
XTRC_CRUD_bkst


* for the unproven/estimated remaining resources
XTRC_Coal_Afri_p
XTRC_Coal_AsiP_p
XTRC_Coal_LAme_p
XTRC_Coal_Eura_p
XTRC_Coal_Euro_p
XTRC_Coal_MEas_p
XTRC_Coal_NAme_p
              
XTRC_NGas_Afri_p
XTRC_NGas_Asia_p
XTRC_NGas_LAme_p
XTRC_NGas_Eura_p
XTRC_NGas_Euro_p
XTRC_NGas_MEas_p
XTRC_NGas_NAme_p

XTRC_CRUD_Afri_p
XTRC_CRUD_Asia_p
XTRC_CRUD_LAme_p
XTRC_CRUD_Eura_p
XTRC_CRUD_Euro_p
XTRC_CRUD_MEas_p
XTRC_CRUD_NAme_p

/;

set XTRC_TECH(P)/
* for the proven remaining resources
XTRC_Coal_Afri
XTRC_Coal_AsiP
XTRC_Coal_LAme
XTRC_Coal_Eura
XTRC_Coal_Euro                         
XTRC_Coal_MEas
XTRC_Coal_NAme

XTRC_NGas_Afri
XTRC_NGas_Asia
XTRC_NGas_LAme
XTRC_NGas_Eura
XTRC_NGas_Euro
XTRC_NGas_MEas
XTRC_NGas_NAme

XTRC_CRUD_Afri
XTRC_CRUD_Asia
XTRC_CRUD_LAme
XTRC_CRUD_Eura
XTRC_CRUD_Euro
XTRC_CRUD_MEas
XTRC_CRUD_NAme

XTRC_URAN_Wrld
XTRC_WSTE_Wrld

* Oil 'backstop'
XTRC_CRUD_bkst


* for the unproven/estimated remaining resources
XTRC_Coal_Afri_p
XTRC_Coal_AsiP_p
XTRC_Coal_LAme_p
XTRC_Coal_Eura_p
XTRC_Coal_Euro_p
XTRC_Coal_MEas_p
XTRC_Coal_NAme_p
              
XTRC_NGas_Afri_p
XTRC_NGas_Asia_p
XTRC_NGas_LAme_p
XTRC_NGas_Eura_p
XTRC_NGas_Euro_p
XTRC_NGas_MEas_p
XTRC_NGas_NAme_p

XTRC_CRUD_Afri_p
XTRC_CRUD_Asia_p
XTRC_CRUD_LAme_p
XTRC_CRUD_Eura_p
XTRC_CRUD_Euro_p
XTRC_CRUD_MEas_p
XTRC_CRUD_NAme_p
/;



Parameter data_XTRC_output(P,C)/
* for the proven remaining resources
XTRC_Coal_Afri     .    Coal      1
XTRC_Coal_AsiP     .    Coal      1
XTRC_Coal_LAme     .    Coal      1
XTRC_Coal_Eura     .    Coal      1
XTRC_Coal_Euro     .    Coal      1                    
XTRC_Coal_MEas     .    Coal      1
XTRC_Coal_NAme     .    Coal      1

XTRC_NGas_Afri     .    NGas      1
XTRC_NGas_Asia     .    NGas      1
XTRC_NGas_LAme     .    NGas      1
XTRC_NGas_Eura     .    NGas      1
XTRC_NGas_Euro     .    NGas      1
XTRC_NGas_MEas     .    NGas      1
XTRC_NGas_NAme     .    NGas      1

XTRC_CRUD_Afri     .    CRUD      1
XTRC_CRUD_Asia     .    CRUD      1
XTRC_CRUD_LAme     .    CRUD      1
XTRC_CRUD_Eura     .    CRUD      1
XTRC_CRUD_Euro     .    CRUD      1
XTRC_CRUD_MEas     .    CRUD      1
XTRC_CRUD_NAme     .    CRUD      1

XTRC_URAN_Wrld     .    URAN      1
XTRC_WSTE_Wrld     .    WSTE      1

* Oil 'backstop'
XTRC_CRUD_bkst     .    CRUD      1


* for the unproven/estimated remaining resources
XTRC_Coal_Afri_p   .    Coal      1
XTRC_Coal_AsiP_p   .    Coal      1
XTRC_Coal_LAme_p   .    Coal      1
XTRC_Coal_Eura_p   .    Coal      1
XTRC_Coal_Euro_p   .    Coal      1
XTRC_Coal_MEas_p   .    Coal      1
XTRC_Coal_NAme_p   .    Coal      1
              
XTRC_NGas_Afri_p   .    NGas      1
XTRC_NGas_Asia_p   .    NGas      1
XTRC_NGas_LAme_p   .    NGas      1
XTRC_NGas_Eura_p   .    NGas      1
XTRC_NGas_Euro_p   .    NGas      1
XTRC_NGas_MEas_p   .    NGas      1
XTRC_NGas_NAme_p   .    NGas      1

XTRC_CRUD_Afri_p   .    CRUD      1
XTRC_CRUD_Asia_p   .    CRUD      1
XTRC_CRUD_LAme_p   .    CRUD      1
XTRC_CRUD_Eura_p   .    CRUD      1
XTRC_CRUD_Euro_p   .    CRUD      1
XTRC_CRUD_MEas_p   .    CRUD      1
XTRC_CRUD_NAme_p   .    CRUD      1
/;

*************************************************************************************************************


* Proven remaining resources, PJ
* Sources: World Energy Outlook 2020, p. 416
parameter data_XTRC_available_resources(P)/
XTRC_Coal_Afri         328937.39
XTRC_Coal_AsiP         10021625.74
XTRC_Coal_LAme         307008.23
XTRC_Coal_Eura         4188469.40
XTRC_Coal_Euro         2960436.49
XTRC_Coal_MEas         21929.16
XTRC_Coal_NAme         5635793.91
                       
XTRC_NGas_Afri         734554.77
XTRC_NGas_Asia         850537.10
XTRC_NGas_LAme         309286.22
XTRC_NGas_Eura         2976879.86
XTRC_NGas_Euro         193303.89
XTRC_NGas_MEas         3131522.97
XTRC_NGas_NAme         618572.44
                       
XTRC_CRUD_Afri         756544.69
XTRC_CRUD_Asia         306220.47
XTRC_CRUD_LAme         1759266.61
XTRC_CRUD_Eura         876631.14
XTRC_CRUD_Euro         90064.84
XTRC_CRUD_MEas         5007605.30
XTRC_CRUD_NAme         1429028.85
                       
* numbers needed:      
XTRC_URAN_Wrld         0        
                       
* numbers needed:      
XTRC_WSTE_Wrld         0                        
                       
* Oil 'backstop'       
XTRC_CRUD_bkst         9999999
/;


* Estimated/unproven resources, PJ
* Sources: World Energy Outlook 2020, p. 416
parameter data_XTRC_unproven_resources(P)/
XTRC_Coal_Afri_p       3755368.51
XTRC_Coal_AsiP_p       98171363.32
XTRC_Coal_LAme_p       657874.78
XTRC_Coal_Eura_p       22099110.15
XTRC_Coal_Euro_p       10734323.41
XTRC_Coal_MEas_p       606706.74
XTRC_Coal_NAme_p       91987340.43
                       
XTRC_NGas_Afri_p       1561895.41
XTRC_NGas_Asia_p       2149539.22
XTRC_NGas_LAme_p       1623752.65
XTRC_NGas_Eura_p       2613468.55
XTRC_NGas_Euro_p       726822.61
XTRC_NGas_MEas_p       2348642.23
XTRC_NGas_NAme_p       2296450.18
                       
XTRC_CRUD_Afri_p       1078376.39
XTRC_CRUD_Asia_p       568409.23
XTRC_CRUD_LAme_p       1703226.26
XTRC_CRUD_Eura_p       1903370.36
XTRC_CRUD_Euro_p       230165.71
XTRC_CRUD_MEas_p       2274637.66
XTRC_CRUD_NAme_p       4847490.02
/;



* Extraction costs of proven remaining resources, $/GJ  or   M$/PJ
* Sources: various
parameter data_XTRC_extraction_costs(P)/
XTRC_Coal_Afri         2.63
XTRC_Coal_AsiP         2.38
XTRC_Coal_LAme         2.18
XTRC_Coal_Eura         0.92
* numbers needed:      
XTRC_Coal_Euro         9999                 
* numbers needed:      
XTRC_Coal_MEas         9999
XTRC_Coal_NAme         3.17
                       
XTRC_NGas_Afri         4.41
XTRC_NGas_Asia         3.00
XTRC_NGas_LAme         4.76
XTRC_NGas_Eura         2.92
XTRC_NGas_Euro         4.99
XTRC_NGas_MEas         1.45
XTRC_NGas_NAme         3.60
                       
XTRC_CRUD_Afri         5.32
XTRC_CRUD_Asia         4.13
XTRC_CRUD_LAme         5.52
XTRC_CRUD_Eura         3.04
XTRC_CRUD_Euro         6.42
XTRC_CRUD_MEas         2.72
XTRC_CRUD_NAme         6.24
                       
XTRC_URAN_Wrld         1.07
XTRC_WSTE_Wrld         7

* Oil 'backstop' - equal to 120 $/barrel
XTRC_CRUD_bkst         19.2


* for unproven resources
XTRC_Coal_Afri_p       5.27 
XTRC_Coal_AsiP_p       4.77 
XTRC_Coal_LAme_p       4.38 
XTRC_Coal_Eura_p       1.84 
XTRC_Coal_Euro_p       999999                 
XTRC_Coal_MEas_p       999999
XTRC_Coal_NAme_p       6.34 
                     
XTRC_NGas_Afri_p       8.83 
XTRC_NGas_Asia_p       6.00 
XTRC_NGas_LAme_p       9.54 
XTRC_NGas_Eura_p       5.85 
XTRC_NGas_Euro_p       10.00
XTRC_NGas_MEas_p       2.91 
XTRC_NGas_NAme_p       7.21 
                    
XTRC_CRUD_Afri_p       10.65
XTRC_CRUD_Asia_p       8.26 
XTRC_CRUD_LAme_p       11.06
XTRC_CRUD_Eura_p       6.08 
XTRC_CRUD_Euro_p       12.84
XTRC_CRUD_MEas_p       5.46 
XTRC_CRUD_NAme_p       12.49
/;



* fugitive emission factors [Mt/PJ]  or  [t/GJ]
parameter data_XTRC_emissionfactors(P,E)/
XTRC_Coal_Afri         .CH4       0.0002543
XTRC_Coal_AsiP         .CH4       0.0002543
XTRC_Coal_LAme         .CH4       0.0002543
XTRC_Coal_Eura         .CH4       0.0002543
XTRC_Coal_Euro         .CH4       0.0002543
XTRC_Coal_MEas         .CH4       0.0002543
XTRC_Coal_NAme         .CH4       0.0002543
XTRC_Coal_Afri_p       .CH4       0.0002543
XTRC_Coal_AsiP_p       .CH4       0.0002543
XTRC_Coal_LAme_p       .CH4       0.0002543
XTRC_Coal_Eura_p       .CH4       0.0002543
XTRC_Coal_Euro_p       .CH4       0.0002543
XTRC_Coal_MEas_p       .CH4       0.0002543
XTRC_Coal_NAme_p       .CH4       0.0002543                                

XTRC_NGas_Afri         .CH4       0.0002956
XTRC_NGas_Asia         .CH4       0.0002956
XTRC_NGas_LAme         .CH4       0.0002956
XTRC_NGas_Eura         .CH4       0.0002956
XTRC_NGas_Euro         .CH4       0.0002956
XTRC_NGas_MEas         .CH4       0.0002956
XTRC_NGas_NAme         .CH4       0.0002956
XTRC_NGas_Afri_p       .CH4       0.0002956
XTRC_NGas_Asia_p       .CH4       0.0002956
XTRC_NGas_LAme_p       .CH4       0.0002956
XTRC_NGas_Eura_p       .CH4       0.0002956
XTRC_NGas_Euro_p       .CH4       0.0002956
XTRC_NGas_MEas_p       .CH4       0.0002956
XTRC_NGas_NAme_p       .CH4       0.0002956                                  

XTRC_CRUD_Afri         .CH4       0.0001918
XTRC_CRUD_Asia         .CH4       0.0001918
XTRC_CRUD_LAme         .CH4       0.0001918
XTRC_CRUD_Eura         .CH4       0.0001918
XTRC_CRUD_Euro         .CH4       0.0001918
XTRC_CRUD_MEas         .CH4       0.0001918
XTRC_CRUD_NAme         .CH4       0.0001918
XTRC_CRUD_Afri_p       .CH4       0.0001918
XTRC_CRUD_Asia_p       .CH4       0.0001918
XTRC_CRUD_LAme_p       .CH4       0.0001918
XTRC_CRUD_Eura_p       .CH4       0.0001918
XTRC_CRUD_Euro_p       .CH4       0.0001918
XTRC_CRUD_MEas_p       .CH4       0.0001918
XTRC_CRUD_NAme_p       .CH4       0.0001918
/;

*************************************************************************************************************


* TotalProcessModelPeriodActivityUpperLimit[r,p]
* Upper Limits of recoverable resources (Proven remaining resources), PJ
ActivityCumulativeMax(r,p)$(data_XTRC_available_resources(P)) = data_XTRC_available_resources(P);



* VariableCost[r,p,m,y]
* Cost of a technology for a given mode of operation (Variable O&M cost), per unit of activity.
VariableCost(r,p,mdfl,t)$(XTRC_TECH(P))  = data_XTRC_extraction_costs(P);


* OutputActivityRatio[r,p,c,m,y]
* Rate of commodity output from a technology, as a ratio of the rate of activity.
OutputActivityRatio(r,XTRC_TECH,C,mdfl,t) = data_XTRC_output(XTRC_TECH,c);

*EmissionActivityRatio
EmissionActivityRatio(r,XTRC_TECH(P),e,mdfl,t)$(data_XTRC_emissionfactors(P,E)) = data_XTRC_emissionfactors(P,E);

* Add NGL production to natural gas extraction processes (assume 0.12 units of NGL per unit of nat.gas)
OutputActivityRatio(r,'XTRC_NGas_Afri','NGLs',mdfl,t) = 0.12;
OutputActivityRatio(r,'XTRC_NGas_Asia','NGLs',mdfl,t) = 0.12;
OutputActivityRatio(r,'XTRC_NGas_LAme','NGLs',mdfl,t) = 0.12;
OutputActivityRatio(r,'XTRC_NGas_Eura','NGLs',mdfl,t) = 0.12;
OutputActivityRatio(r,'XTRC_NGas_Euro','NGLs',mdfl,t) = 0.12;
OutputActivityRatio(r,'XTRC_NGas_MEas','NGLs',mdfl,t) = 0.12;
OutputActivityRatio(r,'XTRC_NGas_NAme','NGLs',mdfl,t) = 0.12;
*
OutputActivityRatio(r,'XTRC_NGas_Afri_p','NGLs',mdfl,t) = 0.12;
OutputActivityRatio(r,'XTRC_NGas_Asia_p','NGLs',mdfl,t) = 0.12;
OutputActivityRatio(r,'XTRC_NGas_LAme_p','NGLs',mdfl,t) = 0.12;
OutputActivityRatio(r,'XTRC_NGas_Eura_p','NGLs',mdfl,t) = 0.12;
OutputActivityRatio(r,'XTRC_NGas_Euro_p','NGLs',mdfl,t) = 0.12;
OutputActivityRatio(r,'XTRC_NGas_MEas_p','NGLs',mdfl,t) = 0.12;
OutputActivityRatio(r,'XTRC_NGas_NAme_p','NGLs',mdfl,t) = 0.12;

*CapacityToActivityUnit[r,p]
* Conversion factor relating the energy that would be produced when one unit of capacity is fully used in one year.
CapacityToActivityUnit(r,p)$XTRC_TECH(P) = 1;
AvailabilityFactor(r,p,t)$XTRC_TECH(P)   = 1;
CapacityFactor(r,p,l,t)$XTRC_TECH(P)     = 1;
OperationalLife(r,p)$XTRC_TECH(P)        = 1;

CapacityResidual(r,p,t)$XTRC_TECH(P) = 999999;






