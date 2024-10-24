* OSEMOSYS_DEC.GMS - declarations for sets, parameters, variables (but not equations)
*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
* OSEMOSYS 2017.11.08 update by Thorsten Burandt, Konstantin Loffler and Karlo Hainsch, TU Berlin (Workgroup for Infrastructure Policy) - October 2017
*
* OSEMOSYS 2017.11.08
* Open Source energy Modeling SYStem
*
* Licensed under the Apache License 2.0, see LICENCE_OSeMOSYS
*
* ============================================================================
*
* Modifications made to the OSEMOSYS framework:
* - Changed set naming (e.g. year to time, technology to process, fuel to commodity, etc.)
* - Changed variable/parameter naming (e.g. SpecifiedAnnualDemand to DemandSpecifiedAnnual, AnnualEmissions to EmissionAnnual)
* - Added multi-year time periods
* - Added ProcessMaxMarketShare
* - Disabled some functionalities not used in SuCCESs, like Reserve Margin and RETarget
*
* ============================================================================
*
* #########################################
* ######################## Model Definition #############
* #########################################
*
* ##############
* # Sets #
* ##############
*
set TIME;
alias (t,tt,TIME);
set TIMESLICE;
alias (l,TIMESLICE);
set SEASON;
alias (ls,SEASON,lsls);
set DAYTYPE;
alias (ld,DAYTYPE,ldld);
set DAILYTIMEBRACKET;
alias (lh,DAILYTIMEBRACKET,lhlh);

set PROCESS;
alias (p,PROCESS)
set COMMODITY;
alias (c,COMMODITY);
set EMISSION;
alias (e,EMISSION);
set MODE_OF_OPERATION;
alias (m,MODE_OF_OPERATION);
set STORAGE;
alias (s,STORAGE);

set REGION;
alias (r,REGION,rr);

set CommodityHasEqualityBalance(C);


*
* ####################
* # Parameters #
* ####################
*


************************************************************************************************
* Additions to the original OSeMOSYS framework
*
*

Parameter ProcessMaxMarketShare(R,P,C,T);

*
*
************************************************************************************************


*
* ####### Global #############
*
parameter YearSplit(TIMESLICE,TIME);
parameter DiscountRate(REGION);
parameter DaySplit(TIME,DAILYTIMEBRACKET);
parameter Conversionls(TIMESLICE,SEASON);
parameter Conversionld(TIMESLICE,DAYTYPE);
parameter Conversionlh(TIMESLICE,DAILYTIMEBRACKET);
parameter DaysInDayType(TIME,SEASON,DAYTYPE);
parameter TradeRoute(REGION,rr,COMMODITY,TIME);
parameter DepreciationMethod(REGION);
*
* ####### Demands #############
*
parameter DemandSpecifiedAnnual(REGION,COMMODITY,TIME);
parameter DemandSpecifiedProfile(REGION,COMMODITY,TIMESLICE,TIME);
parameter DemandAccumulatedAnnual(REGION,COMMODITY,TIME);
*
* ######## Performance #############
*
parameter CapacityToActivityUnit(REGION,PROCESS);
parameter CapacityFactor(REGION,PROCESS,TIMESLICE,TIME);
parameter AvailabilityFactor(REGION,PROCESS,TIME);
parameter OperationalLife(REGION,PROCESS);
parameter CapacityResidual(REGION,PROCESS,TIME);
parameter InputActivityRatio(REGION,PROCESS,COMMODITY,MODE_OF_OPERATION,TIME);
parameter OutputActivityRatio(REGION,PROCESS,COMMODITY,MODE_OF_OPERATION,TIME);
*
* ######## Process Costs #############
*
parameter CapitalCost(REGION,PROCESS,TIME);
parameter VariableCost(REGION,PROCESS,MODE_OF_OPERATION,TIME);
parameter FixedCost(REGION,PROCESS,TIME);
*
* ######## Storage Parameters #############
*
parameter ProcessToStorage  (REGION,PROCESS,STORAGE,MODE_OF_OPERATION);
parameter ProcessFromStorage(REGION,PROCESS,STORAGE,MODE_OF_OPERATION);
parameter StorageLevelStart(REGION,STORAGE);
parameter StorageMaxChargeRate(REGION,STORAGE);
parameter StorageMaxDischargeRate(REGION,STORAGE);
parameter StorageMinCharge(REGION,STORAGE,TIME);
parameter StorageOperationalLife(REGION,STORAGE);
parameter StorageCapitalCost(REGION,STORAGE,TIME);
parameter StorageResidualCapacity(REGION,STORAGE,TIME);
*
* ######## Capacity Constraints #############
*
parameter ProcessStartYear(REGION,PROCESS);
*parameter CapacityOfOneProcessUnit(REGION,PROCESS,TIME);
parameter CapacityTotalMax(REGION,PROCESS,TIME);
parameter CapacityTotalMin(REGION,PROCESS,TIME);
*
* ######## Investment Constraints #############
*
parameter CapacityNewMax(REGION,PROCESS,TIME);
parameter CapacityNewMin(REGION,PROCESS,TIME);
*
* ######## Activity Constraints #############
*
parameter ActivityAnnualMax(REGION,PROCESS,TIME);
parameter ActivityAnnualMin(REGION,PROCESS,TIME);
parameter ActivityCumulativeMax(REGION,PROCESS);
parameter ActivityCumulativeMin(REGION,PROCESS);
* TEk: Reserve Margin Constraints disabled for SuCCESs to remove unnecessary variables/equations
**
** ######## Reserve Margin ############
**
*parameter ReserveMarginTagProcess(REGION,PROCESS,TIME);
*parameter ReserveMarginTagCommodity(REGION,COMMODITY,TIME);
*parameter ReserveMargin(REGION,TIME);
*
* ######## RE Generation Target ############
*
*parameter RETagProcess(REGION,PROCESS,TIME);
*parameter RETagCommodity(REGION,COMMODITY,TIME);
*parameter REMinOutputTarget(REGION,TIME);
*
* ######### Emissions & Penalties #############
*
parameter EmissionActivityRatio(REGION,PROCESS,EMISSION,MODE_OF_OPERATION,TIME);
parameter EmissionPenalty(REGION,EMISSION,TIME);
parameter EmissionAnnualExogenous(REGION,EMISSION,TIME);
parameter EmissionAnnualLimit(REGION,EMISSION,TIME);
*parameter EmissionExogenousCumulative(REGION,EMISSION);
parameter EmissionLimitCumulative(REGION,EMISSION);

*
* #####################
* # Model Variables #
* #####################
*
* ############### Demands ############
*
positive variable DemandRate(REGION,TIMESLICE,COMMODITY,TIME);
positive variable Demand(REGION,TIMESLICE,COMMODITY,TIME);
*
* ############### Storage ###########
*
free variable     StorageChargeRate(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
free variable     StorageDischargeRate(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
free variable     StorageNetChargeWithinYear(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
free variable     StorageNetChargeWithinDay(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
positive variable StorageLevelYearStart(REGION,STORAGE,TIME);
positive variable StorageLevelYearFinish(REGION,STORAGE,TIME);
positive variable StorageLevelSeasonStart(REGION,STORAGE,SEASON,TIME);
positive variable StorageLevelDayTypeStart(REGION,STORAGE,SEASON,DAYTYPE,TIME);
positive variable StorageLevelDayTypeFinish(REGION,STORAGE,SEASON,DAYTYPE,TIME);
positive variable StorageLowerLimit(REGION,STORAGE,TIME);
positive variable StorageUpperLimit(REGION,STORAGE,TIME);
positive variable StorageCapacityNewAccumulated(REGION,STORAGE,TIME);
positive variable StorageCapacityNew(REGION,STORAGE,TIME);
positive variable StorageCapitalInvestment(REGION,STORAGE,TIME);
positive variable StorageCapitalInvestmentDiscounted(REGION,STORAGE,TIME);
positive variable StorageSalvageValue(REGION,STORAGE,TIME);
positive variable StorageSalvageValueDiscounted(REGION,STORAGE,TIME);
positive variable StorageTotalDiscountedCost(REGION,STORAGE,TIME);
*
* ############### Capacity Variables ############
*
*integer variable NumberOfNewProcessUnits(REGION,PROCESS,TIME);
positive variable CapacityNew(REGION,PROCESS,TIME);
positive variable CapacityNewAccumulated(REGION,PROCESS,TIME);
positive variable CapacityTotal(REGION,PROCESS,TIME);
*
* ############### Activity Variables #############
*
positive variable ActivityRateByMode(REGION,TIMESLICE,PROCESS,MODE_OF_OPERATION,TIME);
positive variable ActivityRateTotal(REGION,TIMESLICE,PROCESS,TIME);
positive variable ActivityAnnual(REGION,PROCESS,TIME);
positive variable ActivityAnnualByMode(REGION,PROCESS,MODE_OF_OPERATION,TIME);
free variable     ActivityCumulative(REGION,PROCESS);
*
positive variable OutputRateByProcessByMode(REGION,TIMESLICE,PROCESS,MODE_OF_OPERATION,COMMODITY,TIME);
positive variable OutputRateByProcess(REGION,TIMESLICE,PROCESS,COMMODITY,TIME);
*positive variable OutputByProcess(REGION,TIMESLICE,PROCESS,COMMODITY,TIME);
positive variable OutputAnnualByProcess(REGION,PROCESS,COMMODITY,TIME);
positive variable OutputRate(REGION,TIMESLICE,COMMODITY,TIME);
positive variable Output(REGION,TIMESLICE,COMMODITY,TIME);
positive variable OutputAnnual(REGION,COMMODITY,TIME);
positive variable InputRateByProcessByMode(REGION,TIMESLICE,PROCESS,MODE_OF_OPERATION,COMMODITY,TIME);
positive variable InputRateByProcess(REGION,TIMESLICE,PROCESS,COMMODITY,TIME);
positive variable InputAnnualByProcess(REGION,PROCESS,COMMODITY,TIME);
positive variable InputRate(REGION,TIMESLICE,COMMODITY,TIME);
*positive variable InputByProcess(REGION,TIMESLICE,PROCESS,COMMODITY,TIME);
positive variable Input(REGION,TIMESLICE,COMMODITY,TIME);
positive variable InputAnnual(REGION,COMMODITY,TIME);
positive variable Trade(REGION,rr,TIMESLICE,COMMODITY,TIME);
positive variable TradeAnnual(REGION,rr,COMMODITY,TIME);
*
* ############### Costing Variables #############
*
positive variable CapitalInvestment(REGION,PROCESS,TIME);
positive variable CapitalInvestmentDiscounted(REGION,PROCESS,TIME);
*
positive variable SalvageValue(REGION,PROCESS,TIME);
positive variable SalvageValueDiscounted(REGION,PROCESS,TIME);
variable OperatingCost(REGION,PROCESS,TIME);
variable OperatingCostDiscounted(REGION,PROCESS,TIME);
*
variable OperatingCostVariableAnnual(REGION,PROCESS,TIME);
variable OperatingCostFixedAnnual(REGION,PROCESS,TIME);
*variable VariableOperatingCost(REGION,TIMESLICE,PROCESS,TIME);
*
variable DiscountedCostTotalByProcess(REGION,PROCESS,TIME);
variable DiscountedCostTotal(REGION,TIME);
*
*positive variable CumulativeCostByRegion(REGION);

* TEk: Reserve Margin Constraints disabled for SuCCESs to remove unnecessary variables/equations
**
** ######## Reserve Margin #############
**
*positive variable TotalCapacityInReserveMargin(REGION,TIME);
*positive variable DemandNeedingReserveMargin(REGION,TIMESLICE,TIME);

* TEk: RE Gen Targets disabled for SuCCESs to remove unnecessary variables/equations
**
** ######## RE Gen Target #############
**
*free variable TotalREOutputAnnual(REGION,TIME);
*free variable RETotalOutputOfTargetCommodityAnnual(REGION,TIME);
*

*
* ######## Emissions #############
*
variable EmissionAnnualByProcessByMode(REGION,PROCESS,EMISSION,MODE_OF_OPERATION,TIME);
variable EmissionAnnualByProcess(REGION,PROCESS,EMISSION,TIME);
variable EmissionPenaltyByProcessByEmission(REGION,PROCESS,EMISSION,TIME);
variable EmissionPenaltyByProcess(REGION,PROCESS,TIME);
variable EmissionPenaltyDiscountedByProcess(REGION,PROCESS,TIME);
variable EmissionAnnual(REGION,EMISSION,TIME);
variable EmissionCumulative(EMISSION,REGION);


