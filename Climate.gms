* Climate module for SuCCESs

SETS
    path    paths                       / 1 /
    box     carbon cycle compartments   / 1*4 /;
;

ALIAS(T,TT)
alias(box,boxx,boxxx)


*************************************************************************
* Climate system parameters:

PARAMETERS
* Carbon cycle:
* Flow paramaters:                                                           
        CLIM_cb12               Carbon cycle transition matrix parameter            / 0.11492 /
        CLIM_cb23               Carbon cycle transition matrix parameter            / 0.05627 /
        CLIM_cb34               Carbon cycle transition matrix parameter            / 0.00232 /
* Calculated flow parameters:
        CLIM_cb(box, boxx)      Carbon cycle flow parameters (5 year periods)
        CLIM_cbt(box, boxx,t)   Carbon cycle flow parameters adjusted for period duration
        CLIM_tmp(box, boxx)     temp matrix for calculating CLIM_cbt
* Initial conditions:        
        CLIM_M0(box)            pre-industrial ocean carbon stocks
        CLIM_M2020(box)         ocean carbon stocks in 2020
        CLIM_CO2conc2020        CO2 concetration in 2020                            / 411 /
* CH4 and N2O atmospheric stock, lifetime, decay between periods and radiative efficiency
        CLIM_CH4conc0           CH4 initial concentration in 2020 (ppb)            / 1880 /
        CLIM_N2Oconc0           N2O initial concentration in 2020 (ppb)            / 333  /
        CLIM_CH4Natural         "CH4 natural sources (Mt CH4, GCP CH4 budget)"     / 295  /
        CLIM_N2ONatural         "N2O natural sources (Mt N2O, GCP N2O budget)"     / 18.5 /
        CLIM_CH4_MtToPpb        CH4 ppb per Mt of CH4                              / 0.360 /
        CLIM_N2O_MtToPpb        N2O ppb per Mt of N2O                              / 0.132 /
        CLIM_CH4PreInd          CH4 preindustrial concentration (ppb)              / 722 /
        CLIM_N2OPreInd          N2O preindustrial concentration (ppb)              / 270 /
        CLIM_CH4_life           "CH4 lifetime (IPCC AR5 Table 6.8)"                / 9.1 /
        CLIM_N2O_life           "N2O lifetime (IPCC AR5 Table 6.9)"                / 131 /
        CLIM_CH4_dec(t)         CH4 decay between periods                          
        CLIM_N2O_dec(t)         N2O decay between periods                          
        CLIM_CH4rad             "CH4 Radiative Efficiency (W/m2/ppb, IPCC AR5)"    / 0.036 /
        CLIM_N2Orad             "N2O Radiative Efficiency (W/m2/ppb, IPCC AR5)"    / 0.12  /
        CLIM_CH4N2Ooverlap      Constant term in CH4-N2O RF pverlap                / 0.0800 /
* Radiative forcing:
        CLIM_fco22x             Forcings of equilibrium CO2 doubling (Wm-2)        / 3.6813  /
        CLIM_forcoth(t)         Exogenous forcing for other greenhouse gases
* Linearization parameters: average concentration between 2020-2100 in SSP2-RCP2.6 scenario (ppm and ppb) taken from IIASA Database, converted to GtC
        CLIM_CO2_rcp26_avg                                                       /  443.295   /
        CLIM_CH4_rcp26_avg                                                       / 1560.556   /
        CLIM_N2O_rcp26_avg                                                       /  350.419   /
* FaIRv2.0.0 temperature change:
        CLIM_teq1    Thermal equilibration parameter for box 1 (m^2 per KW)        /0.180 /
        CLIM_teq2    Thermal equilibration parameter for box 2 (m^2 per KW)        /0.297 /
        CLIM_teq3    Thermal equilibration parameter for box 2 (m^2 per KW)        /0.386 /
        CLIM_d1      Thermal response timescale for deep ocean (year)               /0.903/
        CLIM_d2      Thermal response timescale for upper ocean (year)              /7.92/
        CLIM_d3      Thermal response timescale for upper ocean (year)              /355/
* Initial conditions for temperature change:
        CLIM_tbox10     Initial temperature box 1 change in 2020 (C from 1765)  / 0.50 /
        CLIM_tbox20     Initial temperature box 2 change in 2020 (C from 1765)  / 0.76 /
        CLIM_tbox30     Initial temperature box 3 change in 2020 (C from 1765)  / 0.11 /
        CLIM_DeltaT0    Initial atmospheric temperature change in 2020          / 1.37 /        
;


*************************************************************************
* Assign indexed parameter values:

* Forcing of halocarbons and other forcing agents (aerosols, O3, etc), the average of SSP2-2.6 scenarios:
PARAMETER CLIM_forcoth(t) / 
2020   -0.337
2030   -0.211
2040   -0.148
2050   -0.160
2060   -0.195
2070   -0.227
2080   -0.248
2090   -0.260
2100   -0.268
/;

* Carbon cycle parameters:
PARAMETERs CLIM_M0(box)/
1       592
2       161
3       526
4       38013
/;

PARAMETERs CLIM_M2020(box)/
1       876
2       209  
3       435  
4       38295
/;

* Carbon cycle transition matrix:
CLIM_cb('1','1') = 1 - CLIM_cb12;
CLIM_cb('1','2') = CLIM_cb12;

CLIM_cb('2','1') = (1-CLIM_cb('1','1'))*CLIM_M0('1')/CLIM_M0('2');
CLIM_cb('2','2') = 1 - CLIM_cb('2','1') - CLIM_cb23;
CLIM_cb('2','3') = CLIM_cb23;

CLIM_cb('3','2') = (1-CLIM_cb('2','2'))*CLIM_M0('2')/CLIM_M0('3') - CLIM_cb12*CLIM_M0('1')/CLIM_M0('3');
CLIM_cb('3','3') = 1 - CLIM_cb('3','2') - CLIM_cb34;
CLIM_cb('3','4') = CLIM_cb34;

CLIM_cb('4','3') = (1-CLIM_cb('3','3'))*CLIM_M0('3')/CLIM_M0('4') - CLIM_cb23*CLIM_M0('2')/CLIM_M0('4');
CLIM_cb('4','4') = 1 - CLIM_cb34*CLIM_M0('3')/CLIM_M0('4');

* Calculate the carbon cycle matrix for the real duration of the model time periods:
scalar i ;
loop(t,
    CLIM_tmp(box,boxx) = CLIM_cb(box,boxx);
    for(i = 2 to dur(t)/5,
        CLIM_tmp(box,boxx) = sum(boxxx, CLIM_tmp(box,boxxx) * CLIM_cb(boxxx,boxx))
    );
    CLIM_cbt(box, boxx,t) = CLIM_tmp(box,boxx);
);

* Calculate CH4/N2O decay adjusted for the duration of the model time periods:
CLIM_CH4_dec(t) = exp(-1*dur(t)/CLIM_CH4_life);
CLIM_N2O_dec(t) = exp(-1*dur(t)/CLIM_N2O_life);



*************************************************************************
* Variables and equations:

POSITIVE VARIABLES
        CLIM_CStock(t,box,path)         "Carbon stock in atmosphere, shallow, lower and deep oceans (GtC)"
        CLIM_CO2conc(t,path)            "CO2 concentration in atmosphere, shallow and lower oceans (PPM)"
        CLIM_CH4conc(t,path)            "CH4 concentration  in atmosphere (ppb)"
        CLIM_N2Oconc(t,path)            "N2O concentration  in atmosphere (ppb)"
;

VARIABLES
        CLIM_FORC_CO2_lin(t,path)       "CO2 Radiative forcing, linearized (W/m2)"
        CLIM_FORC_CH4_lin(t,path)       "CH4 Radiative forcing, linearized (W/m2)"
        CLIM_FORC_N2O_lin(t,path)       "N2O Radiative forcing, linearized (W/m2)"
        CLIM_FORC_lin(t,path)           "Radiative forcing, linearized (W/m2)"
        CLIM_DeltaT(t,path)             "Global mean temperature change from pre-industrial (degrees C)"
        CLIM_Tbox1(t,path)              "Tempearture change impulse response box 1"
        CLIM_Tbox2(t,path)              "Tempearture change impulse response box 2"
        CLIM_Tbox3(t,path)              "Tempearture change impulse response box 3"
;

EQUATIONS
        EQ_CLIM_CO2stock1(t,path)       Atmospheric concentration 
        EQ_CLIM_CO2stock2(t,path)       Shallow ocean concentration
        EQ_CLIM_CO2stock3(t,path)       Lower ocean concentration
        EQ_CLIM_CO2stock4(t,path)       Deep ocean concentration
        EQ_CLIM_CO2conc(t,path)         CO2 concentration in atmosphere
        EQ_CLIM_CH4conc(t,path)         CH4 concentration in atmosphere
        EQ_CLIM_N2Oconc(t,path)         N2O concentration in atmosphere
        EQ_CLIM_FORC_CO2_lin(t,path)    Linearized CO2 Radiative forcing
        EQ_CLIM_FORC_CH4_lin(t,path)    Linearized CH4 Radiative forcing
        EQ_CLIM_FORC_N2O_lin(t,path)    Linearized N2O Radiative forcing
        EQ_CLIM_forcing_lin(t,path)     Linearized radiative forcing 
        EQ_CLIM_DeltaT(t,path)          Temperature-climate equation for atmosphere
        EQ_CLIM_tbox1eq(t,path)         Temperature-climate equation for atmosphere - box 1
        EQ_CLIM_tbox2eq(t,path)         Temperature-climate equation for atmosphere - box 2 
        EQ_CLIM_tbox3eq(t,path)         Temperature-climate equation for atmosphere - box 3
;

* Carbon cycle (in GtC)
EQ_CLIM_CO2stock1(t+1,path)..           CLIM_CStock(t+1,'1',path)    =E= CLIM_CStock(t,'1',path)*CLIM_cbt('1','1',t) + CLIM_CStock(t,'2',path)*CLIM_cbt('2','1',t) + CLIM_CStock(t,'3',path)*CLIM_cbt('3','1',t) + CLIM_CStock(t,'4',path)*CLIM_cbt('4','1',t) + dur(t)*(sum(r, EmissionAnnual(r,'CO2FFI',t+1) + EmissionAnnual(r,'CO2LU',t+1) + EmissionAnnual(r,'CO2nat',t+1) ))/1000/(44/12) ;
EQ_CLIM_CO2stock2(t+1,path)..           CLIM_CStock(t+1,'2',path)    =E= CLIM_CStock(t,'1',path)*CLIM_cbt('1','2',t) + CLIM_CStock(t,'2',path)*CLIM_cbt('2','2',t) + CLIM_CStock(t,'3',path)*CLIM_cbt('3','2',t) + CLIM_CStock(t,'4',path)*CLIM_cbt('4','2',t) ;
EQ_CLIM_CO2stock3(t+1,path)..           CLIM_CStock(t+1,'3',path)    =E= CLIM_CStock(t,'1',path)*CLIM_cbt('1','3',t) + CLIM_CStock(t,'2',path)*CLIM_cbt('2','3',t) + CLIM_CStock(t,'3',path)*CLIM_cbt('3','3',t) + CLIM_CStock(t,'4',path)*CLIM_cbt('4','3',t) ;
EQ_CLIM_CO2stock4(t+1,path)..           CLIM_CStock(t+1,'4',path)    =E= CLIM_CStock(t,'1',path)*CLIM_cbt('1','4',t) + CLIM_CStock(t,'2',path)*CLIM_cbt('2','4',t) + CLIM_CStock(t,'3',path)*CLIM_cbt('3','4',t) + CLIM_CStock(t,'4',path)*CLIM_cbt('4','4',t) ;

* CO2 concentration (in ppm):
EQ_CLIM_CO2conc(t,path)..                    CLIM_CO2conc(t,path)    =E= CLIM_CStock(t,'1',path) * CLIM_CO2conc2020/CLIM_M2020('1');

* CH4 and N2O stocks in atmosphere (in ppb)
EQ_CLIM_CH4conc(t+1,path)..              CLIM_CH4conc(t+1,path)      =E= CLIM_CH4conc(t,path)*CLIM_CH4_dec(t) + CLIM_CH4_MtToPpb * ( sum(r, EmissionAnnual(r,'CH4',t+1)) + CLIM_CH4Natural ) * (CLIM_CH4_life * ( 1-exp(-dur(t)/CLIM_CH4_life) )) ;
EQ_CLIM_N2Oconc(t+1,path)..              CLIM_N2Oconc(t+1,path)      =E= CLIM_N2Oconc(t,path)*CLIM_N2O_dec(t) + CLIM_N2O_MtToPpb * ( sum(r, EmissionAnnual(r,'N2O',t+1)) + CLIM_N2ONatural ) * (CLIM_N2O_life * ( 1-exp(-dur(t)/CLIM_N2O_life) )) ;

* Radiative forcing (linearized)
* L(x)   = f(a)   + f'(a)(x-a)
EQ_CLIM_FORC_CO2_lin(t,path)..     CLIM_FORC_CO2_lin(t,path)    =E= CLIM_fco22x *((log(CLIM_CO2_rcp26_avg*2.1/CLIM_M0('1')))/log(2))
                                                           + (CLIM_CStock(t,'1',path) - CLIM_CO2_rcp26_avg*2.1) * CLIM_fco22x/(log(2)*CLIM_CO2_rcp26_avg*2.1);

EQ_CLIM_FORC_CH4_lin(t,path)..     CLIM_FORC_CH4_lin(t,path)    =E= CLIM_CH4rad *(SQRT(CLIM_CH4_rcp26_avg)-SQRT(CLIM_CH4PreInd))   - (0.47*LOG(1 + 2.01*10**(-5) * (CLIM_CH4_rcp26_avg*CLIM_N2OPreInd)**0.75 + 5.31*10**(-15) * CLIM_CH4_rcp26_avg*((CLIM_CH4_rcp26_avg*CLIM_N2OPreInd)**(1.52))) - CLIM_CH4N2Ooverlap)
                                                           + (CLIM_CH4conc(t,path) - CLIM_CH4_rcp26_avg) * ( (CLIM_CH4rad * (1 / (2*SQRT(CLIM_CH4_rcp26_avg))))
                                                           - ( 0.47 * ( ((6.65731*10**(-10) * (CLIM_CH4_rcp26_avg*CLIM_N2OPreInd)**(1.52) + ( (0.75*CLIM_N2OPreInd) / ((CLIM_CH4_rcp26_avg)**(0.25) ) )) / (2.64179*10**(-10) * CLIM_CH4_rcp26_avg*(CLIM_CH4_rcp26_avg*CLIM_N2OPreInd)**(1.52) + (CLIM_CH4_rcp26_avg*CLIM_N2OPreInd)**(0.75) + 49751.2) ))
                                                           ));

EQ_CLIM_FORC_N2O_lin(t,path)..     CLIM_FORC_N2O_lin(t,path)    =E= CLIM_N2Orad *(SQRT(CLIM_N2O_rcp26_avg)-SQRT(CLIM_N2OPreInd)) - (0.47*LOG(1 + 2.01*10**(-5) * (CLIM_N2O_rcp26_avg*CLIM_CH4PreInd)**0.75 + 5.31*10**(-15) * CLIM_CH4PreInd*((CLIM_N2O_rcp26_avg*CLIM_CH4PreInd)**(1.52))) - CLIM_CH4N2Ooverlap)
                                                           + (CLIM_N2Oconc(t,path) - CLIM_N2O_rcp26_avg) * ( (CLIM_N2Orad * (1 / (2*SQRT(CLIM_N2O_rcp26_avg))))
                                                           - ( 0.47 * ( (CLIM_CH4PreInd*((4.01552*10**(-10))*CLIM_CH4PreInd*((CLIM_N2O_rcp26_avg*CLIM_CH4PreInd)**(0.77))  +0.75)) / ( ((CLIM_N2O_rcp26_avg*CLIM_CH4PreInd)**(0.25)) * ( (2.64179*10**(-10))*CLIM_CH4PreInd*((CLIM_CH4PreInd*CLIM_N2O_rcp26_avg)**(1.52)) + (CLIM_CH4PreInd*CLIM_N2O_rcp26_avg)**(0.75) + 49751.2 ) )
                                                           )));

EQ_CLIM_forcing_lin(t,path)..           CLIM_FORC_lin(t,path)        =E= CLIM_FORC_CO2_lin(t,path)
                                                                        + CLIM_FORC_CH4_lin(t,path)
                                                                        + CLIM_FORC_N2O_lin(t,path)
                                                                        + CLIM_forcoth(t);

*** Temperature change - FaIR: ***
* Source: Leach et al. 2021, section 2.4 (https://gmd.copernicus.org/articles/14/3007/2021/gmd-14-3007-2021.html)
EQ_CLIM_DeltaT(t,path)..        CLIM_DeltaT(t,path)  =E=   CLIM_Tbox1(t,path) + CLIM_Tbox2(t,path) + CLIM_Tbox3(t,path);
* Individual boxes: impulse respose function
EQ_CLIM_tbox1eq(t+1,path)..     CLIM_Tbox1(t+1,path) =E=  CLIM_Tbox1(t,path) * exp(-dur(t)/CLIM_d1) + CLIM_teq1 * CLIM_FORC_lin(t+1,path)*(1-exp(-dur(t)/CLIM_d1));
EQ_CLIM_tbox2eq(t+1,path)..     CLIM_Tbox2(t+1,path) =E=  CLIM_Tbox2(t,path) * exp(-dur(t)/CLIM_d2) + CLIM_teq2 * CLIM_FORC_lin(t+1,path)*(1-exp(-dur(t)/CLIM_d2));
EQ_CLIM_tbox3eq(t+1,path)..     CLIM_Tbox3(t+1,path) =E=  CLIM_Tbox3(t,path) * exp(-dur(t)/CLIM_d3) + CLIM_teq3 * CLIM_FORC_lin(t+1,path)*(1-exp(-dur(t)/CLIM_d3));


*************************************************************************
* Initial conditions in 2020

CLIM_CStock.FX(tfirst,'1',path)   = CLIM_M2020('1');
CLIM_CStock.FX(tfirst,'2',path)   = CLIM_M2020('2');
CLIM_CStock.FX(tfirst,'3',path)   = CLIM_M2020('3');
CLIM_CStock.FX(tfirst,'4',path)   = CLIM_M2020('4');

CLIM_CH4conc.FX(tfirst,path)     = CLIM_CH4conc0;
CLIM_N2Oconc.FX(tfirst,path)     = CLIM_N2Oconc0;

CLIM_DeltaT.FX(tfirst,path)= CLIM_DeltaT0;
CLIM_Tbox1.fx(tfirst,path) = CLIM_Tbox10;
CLIM_Tbox2.fx(tfirst,path) = CLIM_Tbox20;
CLIM_Tbox3.fx(tfirst,path) = CLIM_Tbox30;
