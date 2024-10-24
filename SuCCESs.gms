*
* SuCCESs IAM - An integrated assessment model for Sustainable Climate Change mitigation strategies in Energy-Land-Material Systems
*
* Model version: 2024-10-23
*
* Contact: Tommi Ekholm, Finnish Meteorological Institute (tommi.ekholm@fmi.fi)
* Contributors: Tommi Ekholm, Nadine Freistetter, Tuukka Mattlar, Theresa Schaber, Aapo Rautiainen
*
* SuCCESs is released under the MIT license, excluding the files OSeMOSYS_dec.GMS and OSeMOSYS_equ.GMS.
*
* OSeMOSYS_dec.GMS and OSeMOSYS_equ.GMS are based on a modified version of OSEMOSYS:
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
* OSEMOSYS 2017.11.08 update by Thorsten Burandt, Konstantin Loeffler and Karlo Hainsch, TU Berlin (Workgroup for Infrastructure Policy) - October 2017
* Licensed under the Apache License 2.0, see LICENCE_OSeMOSYS
*
$offlisting

*************************************************************************
* GAMS control options:
* Allow merging multiple statements of sets and data:
$ONMULTI
* Allow empty set and data declarations:
$ONEMPTY
* Zero symbol means number zero, not boolean FALSE:
$ONEPS


*************************************************************************
* OSEMOSYS - declarations for sets, parameters, variables:
$include osemosys_dec.gms


*************************************************************************
* SuCCESS-IAM input files

* Base: commodity, emission and time definitions 
$include Base.gms

* Technology definitions:
$include Techs_XTRC.gms
$include Techs_REFI.gms
$include Techs_ELEC.gms
$include Techs_CHEM.gms
$include Techs_INDU.gms
$include Techs_TRAN.gms
$include Techs_BLDN.gms

* Demand projections:
$include Demand.gms

* Temporary fixes:
$include Techs_TEMP.gms

* Debugging technologies (backstop, commodity sink), enable if needed:
*$include Techs_DBUG.gms

* Emission factors:
$include Emissions.gms

* Electricity demand and VRE variability:
$include Electricity.gms

* Land-use module
$include CLASH_Connector.gms
$include Techs_NonCO2.gms

* Climate Module
$include Climate.gms

* Materials module - to be added later


*************************************************************************
* Scenario files: user-determined assumptions, constraints, etc.


* CLIMATE:
* Paris Agreement 1.5C temperature limit (by 2100):
*$include Scenario_15C_constraint.gms
*$include Scenario_2C_constraint.gms

* RF limits (c.f. RCPs), which can be set from the command line (e.g. with --RF = 1.9):
$if set RFLim CLIM_FORC_lin.UP('2100',path) = %RFLim%;

* LAND-USE:
* As default, fix land-use to the LUH2 SSP2-4.5 scenario:
$include Scenario_FixLandUseToSSP245.gms
* NOTE: If areas are not fixed, it's necessary to limit increasing 'SecdN' area.
* SecdN has large carbon density and increasing it's area rapidly leads to unrealistic carbon sinks.
* Hence introduce a constraint, that SecdN area cannot be increased.
* However, this constraint is incompatible with fixing areas to SSP2 land-use, so introduce it only if SecdN area is not fixed.
$ife not set SecdNAreaIsFixed $include Scenario_LimitSecdnAreaIncrease.gms


*************************************************************************
* OSEMOSYS - define model equations:
$include osemosys_equ.gms


*************************************************************************
* Define and solve the model:

model SuCCESs /all/;
option limrow=0, limcol=0, solprint=off;

option LP = CPLEX;
SuCCESs.optfile = 1 

solve SuCCESs minimizing z using LP;


*************************************************************************
* Post-process some result variables:

OutputAnnualByProcess.L(R,P,C,T)$(not PrcHasOutputCom(P,C)) = no;

Set flow / In, Out /;
Parameter ProcessInputsOutputs(P,C,flow,T);
ProcessInputsOutputs(P,C,'In',T)$PrcHasInputCom(P,C) = sum(r, InputAnnualByProcess.L(r,p,c,t));
ProcessInputsOutputs(P,C,'Out',T)$PrcHasOutputCom(P,C) = sum(r, OutputAnnualByProcess.L(r,p,c,t));

* Shadow prices:
Parameters
    ShadowPriceCommodityAnnual(r,c,t)
    ShadowPriceEmissionAnnual(r,e,t)
    ShadowPriceLandAreaAnnual(pool,t)
;

ShadowPriceCommodityAnnual(r,c,t) = ((1+DiscountRate(r))**(t.val-smin(tt, tt.val))) * ( sum(l,EQ_EBa11_EnergyBalanceEachTS5.M(r,l,c,t)) + EQ_EBb4_EnergyBalanceEachYear4.M(r,c,t) ) / dur(T);
ShadowPriceEmissionAnnual(r,e,t) =  ((1+DiscountRate(r))**(t.val-smin(tt, tt.val))) * EQ_E6_EmissionsAccounting1.M(r,e,t) / dur(T);
ShadowPriceLandAreaAnnual(pool,t) = ((1+DiscountRate('World'))**(t.val-smin(tt, tt.val))) * (-1 * EQ_LU_Area.M(t,pool));

* Aggregated outputs from the land-use module:
parameters
            LU_SecdFAreaByAge(t,age)
            LU_AreaByPool(t,pool)
            LU_AreaByUse(t,use)
*            LU_TotalProd(t,g)
            LU_CStockLitter(t,pool)
            LU_CStockSoil(t,pool)
;

LU_SecdFAreaByAge(t,age) = sum(pool, LU_Area_SecdF.L(t,pool,age));
LU_AreaByPool(t,pool) = sum(use, LU_Area.L(t,pool,use));
LU_AreaByUse(t,use)  = sum(pool, LU_Area.L(t,pool,use));

LU_CStockLitter(t,pool) = LU_CStockLittHerb.L(t,pool) + LU_CStockLittWoody.L(t,pool);
LU_CStockSoil(t,pool)   = LU_CStockSoilHerb.L(t,pool) + LU_CStockSoilWoody.L(t,pool);
