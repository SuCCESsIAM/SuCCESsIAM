* OSEMOSYS_EQU.GMS - model equations
*
* OSeMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
* OSeMOSYS 2017.11.08 update by Thorsten Burandt, Konstantin Loffler and Karlo Hainsch, TU Berlin (Workgroup for Infrastructure Policy) - October 2017
*
* OSeMOSYS 2017.11.08
* Main changes to previous version OSeMOSYS_2016_08_01
* Bug fixed in:
* - Equation E1
*
* Open Source energy Modeling SYStem
* Licensed under the Apache License 2.0, see LICENCE_OSeMOSYS*
* ============================================================================
*


************************************************************************************************
* Additions to the original OSeMOSYS framework
*
*

* Define sets to control which equations (and thereby variables) are actually needed

set
  PrcHasInputCom(P,C)
  PrcHasOutputCom(P,C)
  PrcHasMode(P,M)
;

CommodityHasEqualityBalance(C)$(not CommodityHasEqualityBalance(C)) = no;

PrcHasInputCom(P,C) = no;
PrcHasOutputCom(P,C) = no;
PrcHasMode(P,M) = no;

PrcHasInputCom(P,C)$(sum((R,M,T), abs(InputActivityRatio(R,P,C,M,T)) ) ne 0 ) = yes;
PrcHasOutputCom(P,C)$(sum((R,M,T), abs(OutputActivityRatio(R,P,C,M,T)) ) ne 0 ) = yes;
PrcHasMode(P,M)$(sum((R,C,T), abs(InputActivityRatio(R,P,C,M,T))) ne 0 or
                 sum((R,C,T), abs(OutputActivityRatio(R,P,C,M,T))) ne 0 or
                 sum((R,T), abs(VariableCost(R,P,M,T))) ne 0 or
                 sum((R,C,S,T), abs(ProcessToStorage(R,P,S,M))) ne 0 or
                 sum((R,C,S,T), abs(ProcessFromStorage(R,P,S,M))) ne 0 or
                 sum((R,C,E,T), abs(EmissionActivityRatio(R,P,E,M,T))) ne 0 ) = yes;


* Constrain TotalAnnualMaxCapacity to zero before the process' start year:
CapacityTotalMax(r,p,t)$(ProcessStartYear(R,P) and (t.val < ProcessStartYear(R,P) )) = 0;


* Maximum market share of a process P to produce commodity C:
Equation EQ_ProcessMaxMarketShare(R,L,P,C,T);

EQ_ProcessMaxMarketShare(R,L,P,C,T)$ProcessMaxMarketShare(R,P,C,T)..
    OutputRateByProcess(r,l,p,c,t) =L= ProcessMaxMarketShare(R,P,C,T) * OutputRate(r,l,c,t);


************************************************************************************************


* ######################
* # Objective Function #
* ######################
*
*minimize cost: sum(REGION,PROCESS,TIME) TotalDiscountedCost[y,p,r];
free variable z;
Equation EQ_Objective;
EQ_Objective.. z =e= sum((r,t), DiscountedCostTotal(r,t));
*
* ####################
* # Constraints #
* ####################

*:SpecifiedAnnualDemand[y,c,r]<>0
*s.t. EQ_SpecifiedDemand1(REGION,TIMESLICE,COMMODITY,TIME): SpecifiedAnnualDemand[y,c,r]*SpecifiedDemandProfile[y,l,c,r] / YearSplit[y,l]=RateOfDemand[y,l,c,r];
equation EQ_SpecifiedDemand1(REGION,TIMESLICE,COMMODITY,TIME);

EQ_SpecifiedDemand1(r,l,c,t)$(DemandSpecifiedAnnual(r,c,t) gt 0)..
    DemandSpecifiedAnnual(r,c,t)*DemandSpecifiedProfile(r,c,l,t) / YearSplit(l,t) =E= DemandRate(r,l,c,t);

*
* ############### Capacity Adequacy A #############
*
*s.t. CAa1_TotalNewCapacity{r in REGION, t in PROCESS, y in TIME}:AccumulatedNewCapacity[r,p,y] = sum{yy in TIME: y-yy < OperationalLife[r,p] && y-yy>=0} NewCapacity[r,p,yy];
Equation EQ_CAa1_TotalCapacityNew(REGION,PROCESS,TIME);
EQ_CAa1_TotalCapacityNew(r,p,t).. CapacityNewAccumulated(r,p,t) =E= sum(tt$((t.val-tt.val < OperationalLife(r,p)) AND (t.val-tt.val >= 0)), dur(t) * CapacityNew(r,p,tt));

*s.t. CAa2_TotalAnnualCapacity{r in REGION, t in PROCESS, y in TIME}: AccumulatedNewCapacity[r,p,y]+ CapacityResidual[r,p,y] = TotalCapacityAnnual[r,p,y];
Equation EQ_CAa2_TotalAnnualCapacity(REGION,PROCESS,TIME);
EQ_CAa2_TotalAnnualCapacity(r,p,t).. CapacityTotal(r,p,t) =E= CapacityNewAccumulated(r,p,t) + CapacityResidual(r,p,t);

*s.t. CAa3_TotalActivityOfEachProcess{r in REGION, t in PROCESS, l in TIMESLICE, y in TIME}: sum{m in MODE_OF_OPERATION} RateOfActivity[r,l,p,m,y] = RateOfTotalActivity[r,p,l,y];
Equation EQ_CAa3_TotalActivityOfEachProcess(TIME,PROCESS,TIMESLICE,REGION);
EQ_CAa3_TotalActivityOfEachProcess(t,p,l,r).. ActivityRateTotal(r,l,p,t) =E= sum(m, ActivityRateByMode(r,l,p,m,t));

*s.t. CAa4_Constraint_Capacity{r in REGION, l in TIMESLICE, t in PROCESS, y in TIME}: RateOfTotalActivity[r,p,l,y] <= TotalCapacityAnnual[r,p,y] * CapacityFactor[r,p,l,y]*CapacityToActivityUnit[r,p];
Equation EQ_CAa4_Constraint_Capacity(REGION,TIMESLICE,PROCESS,TIME);
EQ_CAa4_Constraint_Capacity(r,l,p,t).. ActivityRateTotal(r,l,p,t) =L= CapacityTotal(r,p,t) * CapacityFactor(r,p,l,t) * CapacityToActivityUnit(r,p);

*s.t. CAa5_TotalNewCapacity{r in REGION, t in PROCESS, y in TIME: CapacityOfOneProcessUnit[r,p,y]<>0}: CapacityOfOneProcessUnit[r,p,y]*NumberOfNewProcessUnits[r,p,y] = NewCapacity[r,p,y];
*Equation EQ_CAa5_TotalNewCapacity(REGION,PROCESS,TIME);
*EQ_CAa5_TotalNewCapacity(r,p,t)$(CapacityOfOneProcessUnit(r,p,t) <> 0).. NewCapacity(r,p,t) =E= CapacityOfOneProcessUnit(r,p,t) * NumberOfNewProcessUnits(r,p,t);

* Note that the PlannedMaintenance equation below ensures that all other technologies have a capacity great enough to at least meet the annual average.
*
* ############### Capacity Adequacy B #############
*
*s.t. CAb1_PlannedMaintenance{r in REGION, t in PROCESS, y in TIME}: sum{l in TIMESLICE} RateOfTotalActivity[r,p,l,y]*YearSplit[l,y] <= sum{l in TIMESLICE} (TotalCapacityAnnual[r,p,y]*CapacityFactor[r,p,l,y]*YearSplit[l,y])* AvailabilityFactor[r,p,y]*CapacityToActivityUnit[r,p];
Equation EQ_CAb1_PlannedMaintenance(REGION,PROCESS,TIME);
EQ_CAb1_PlannedMaintenance(r,p,t).. sum(l, ActivityRateTotal(r,l,p,t)*YearSplit(l,t)) =L= AvailabilityFactor(r,p,t) * CapacityToActivityUnit(r,p) * sum(l, CapacityTotal(r,p,t) * CapacityFactor(r,p,l,t) * YearSplit(l,t));

*
* ############## Energy Balance A #############
*

*s.t. EBa1_RateOfCommodityOutput1{r in REGION, l in TIMESLICE, f in COMMODITY, t in PROCESS, m in MODE_OF_OPERATION, y in TIME: OutputActivityRatio[r,p,c,m,y] <>0}:  RateOfActivity[r,l,p,m,y]*OutputActivityRatio[r,p,c,m,y]  = OutputRateByProcessByMode[r,l,p,m,c,y];
Equation EQ_EBa1_RateOfCommodityOutput1(REGION,TIMESLICE,COMMODITY,PROCESS,MODE_OF_OPERATION,TIME);
EQ_EBa1_RateOfCommodityOutput1(r,l,c,p,m,t)$(OutputActivityRatio(r,p,c,m,t) <> 0).. OutputRateByProcessByMode(r,l,p,m,c,t) =E= ActivityRateByMode(r,l,p,m,t)*OutputActivityRatio(r,p,c,m,t);

*s.t. EBa2_RateOfCommodityOutput2{r in REGION, l in TIMESLICE, f in COMMODITY, t in PROCESS, y in TIME}: sum{m in MODE_OF_OPERATION: OutputActivityRatio[r,p,c,m,y] <>0} OutputRateByProcessByMode[r,l,p,m,c,y] = OutputRateByProcess[r,l,p,c,y] ;
Equation EQ_EBa2_RateOfCommodityOutput2(REGION,TIMESLICE,COMMODITY,PROCESS,TIME);
EQ_EBa2_RateOfCommodityOutput2(r,l,c,p,t).. OutputRateByProcess(r,l,p,c,t) =E= sum(m$(OutputActivityRatio(r,p,c,m,t) <> 0), OutputRateByProcessByMode(r,l,p,m,c,t));

*s.t. EBa3_RateOfCommodityOutput3{r in REGION, l in TIMESLICE, f in COMMODITY, y in TIME}: sum{t in PROCESS} OutputRateByProcess[r,l,p,c,y]  =  OutputRate[r,l,c,y];
Equation EQ_EBa3_RateOfCommodityOutput3(REGION,TIMESLICE,COMMODITY,TIME);
EQ_EBa3_RateOfCommodityOutput3(r,l,c,t).. OutputRate(r,l,c,t) =E= sum(p, OutputRateByProcess(r,l,p,c,t));

*s.t. EBa4_RateOfCommodityUse1{r in REGION, l in TIMESLICE, f in COMMODITY, t in PROCESS, m in MODE_OF_OPERATION, y in TIME: InputActivityRatio[r,p,c,m,y]<>0}: RateOfActivity[r,l,p,m,y]*InputActivityRatio[r,p,c,m,y]  = InputRateByProcessByMode[r,l,p,m,c,y];
Equation EQ_EBa4_RateOfCommodityUse1(REGION,TIMESLICE,COMMODITY,PROCESS,MODE_OF_OPERATION,TIME);
EQ_EBa4_RateOfCommodityUse1(r,l,c,p,m,t)$(InputActivityRatio(r,p,c,m,t) <> 0).. InputRateByProcessByMode(r,l,p,m,c,t) =E= ActivityRateByMode(r,l,p,m,t)*InputActivityRatio(r,p,c,m,t);

*s.t. EBa5_RateOfCommodityUse2{r in REGION, l in TIMESLICE, f in COMMODITY, t in PROCESS, y in TIME}: sum{m in MODE_OF_OPERATION: InputActivityRatio[r,p,c,m,y]<>0} InputRateByProcessByMode[r,l,p,m,c,y] = InputRateByProcess[r,l,p,c,y];
Equation EQ_EBa5_RateOfCommodityUse2(REGION,TIMESLICE,COMMODITY,PROCESS,TIME);
EQ_EBa5_RateOfCommodityUse2(r,l,c,p,t).. InputRateByProcess(r,l,p,c,t) =E= sum(m$(InputActivityRatio(r,p,c,m,t) <> 0), InputRateByProcessByMode(r,l,p,m,c,t));

*s.t. EBa6_RateOfCommodityUse3{r in REGION, l in TIMESLICE, f in COMMODITY, y in TIME}: sum{t in PROCESS} InputRateByProcess[r,l,p,c,y]  = InputRate[r,l,c,y];
Equation EQ_EBa6_RateOfCommodityUse3(REGION,TIMESLICE,COMMODITY,TIME);
EQ_EBa6_RateOfCommodityUse3(r,l,c,t).. InputRate(r,l,c,t) =E= sum(p, InputRateByProcess(r,l,p,c,t));

*s.t. EBa7_EnergyBalanceEachTS1{r in REGION, l in TIMESLICE, f in COMMODITY, y in TIME}: OutputRate[r,l,c,y]*YearSplit[l,y] = Output[r,l,c,y];
Equation EQ_EBa7_EnergyBalanceEachTS1(REGION,TIMESLICE,COMMODITY,TIME);
EQ_EBa7_EnergyBalanceEachTS1(r,l,c,t).. Output(r,l,c,t) =E= OutputRate(r,l,c,t)*YearSplit(l,t);

*s.t. EBa8_EnergyBalanceEachTS2{r in REGION, l in TIMESLICE, f in COMMODITY, y in TIME}: InputRate[r,l,c,y]*YearSplit[l,y] = Input[r,l,c,y];
Equation EQ_EBa8_EnergyBalanceEachTS2(REGION,TIMESLICE,COMMODITY,TIME);
EQ_EBa8_EnergyBalanceEachTS2(r,l,c,t).. Input(r,l,c,t) =E= InputRate(r,l,c,t)*YearSplit(l,t);

*s.t. EBa9_EnergyBalanceEachTS3{r in REGION, l in TIMESLICE, f in COMMODITY, y in TIME}: RateOfDemand[r,l,c,y]*YearSplit[l,y] = Demand[r,l,c,y];
Equation EQ_EBa9_EnergyBalanceEachTS3(REGION,TIMESLICE,COMMODITY,TIME);
EQ_EBa9_EnergyBalanceEachTS3(r,l,c,t).. Demand(r,l,c,t) =E= DemandRate(r,l,c,t)*YearSplit(l,t);

*s.t. EBa10_EnergyBalanceEachTS4{r in REGION, rr in REGION, l in TIMESLICE, f in COMMODITY, y in TIME}: Trade[r,rr,l,c,y] = -Trade[rr,r,l,c,y];
Equation EQ_EBa10_EnergyBalanceEachTS4(REGION,r,TIMESLICE,COMMODITY,TIME);
EQ_EBa10_EnergyBalanceEachTS4(r,rr,l,c,t).. Trade(r,rr,l,c,t) =E= -Trade(rr,r,l,c,t);

*s.t. EBa11_EnergyBalanceEachTS5{r in REGION, l in TIMESLICE, f in COMMODITY, y in TIME}: Output[r,l,c,y] >= Demand[r,l,c,y] + Input[r,l,c,y] + sum{rr in REGION} Trade[r,rr,l,c,y]*TradeRoute[r,rr,c,y];
Equation EQ_EBa11_EnergyBalanceEachTS5(REGION,TIMESLICE,COMMODITY,TIME);
EQ_EBa11_EnergyBalanceEachTS5(r,l,c,t).. Output(r,l,c,t) =G= Demand(r,l,c,t) + Input(r,l,c,t) + sum(rr, (Trade(r,rr,l,c,t)*TradeRoute(r,rr,c,t)));

*
* ############## Energy Balance B #############
*
*s.t. EBb1_EnergyBalanceEachYear1{r in REGION, f in COMMODITY, y in TIME}: sum{l in TIMESLICE} Output[r,l,c,y] = OutputAnnual[r,c,y];
Equation EQ_EBb1_EnergyBalanceEachYear1(REGION,COMMODITY,TIME);
EQ_EBb1_EnergyBalanceEachYear1(r,c,t).. OutputAnnual(r,c,t) =E= sum(l, Output(r,l,c,t));

*s.t. EBb2_EnergyBalanceEachYear2{r in REGION, f in COMMODITY, y in TIME}: sum{l in TIMESLICE} Input[r,l,c,y] = InputAnnual[r,c,y];
Equation EQ_EBb2_EnergyBalanceEachYear2(REGION,COMMODITY,TIME);
EQ_EBb2_EnergyBalanceEachYear2(r,c,t).. InputAnnual(r,c,t) =E= sum(l, Input(r,l,c,t));
*s.t. EBb3_EnergyBalanceEachYear3{r in REGION, rr in REGION, f in COMMODITY, y in TIME}: sum{l in TIMESLICE} Trade[r,rr,l,c,y] = TradeAnnual[r,rr,c,y];
Equation EQ_EBb3_EnergyBalanceEachYear3(REGION,r,COMMODITY,TIME);
EQ_EBb3_EnergyBalanceEachYear3(r,rr,c,t).. TradeAnnual(r,rr,c,t) =E= sum(l, Trade(r,rr,l,c,t));
*s.t. EBb4_EnergyBalanceEachYear4{r in REGION, f in COMMODITY, y in TIME}: OutputAnnual[r,c,y] >= InputAnnual[r,c,y] + sum{rr in REGION} TradeAnnual[r,rr,c,y]*TradeRoute[r,rr,c,y] + AccumulatedAnnualDemand[r,c,y];
Equation EQ_EBb4_EnergyBalanceEachYear4(REGION,COMMODITY,TIME);
EQ_EBb4_EnergyBalanceEachYear4(r,c,t)$(not CommodityHasEqualityBalance(c)).. OutputAnnual(r,c,t) =G= InputAnnual(r,c,t) + sum(rr, (TradeAnnual(r,rr,c,t) * TradeRoute(r,rr,c,t))) + DemandAccumulatedAnnual(r,c,t);
* If commodity C has the balance as equality, define an equality balance:
Equation EQ_EBb5_EnergyBalanceEachYear5(REGION,COMMODITY,TIME);
EQ_EBb5_EnergyBalanceEachYear5(r,c,t)$(CommodityHasEqualityBalance(c)).. OutputAnnual(r,c,t) =E= InputAnnual(r,c,t) + sum(rr, (TradeAnnual(r,rr,c,t) * TradeRoute(r,rr,c,t))) + DemandAccumulatedAnnual(r,c,t);

*
* ############## Accounting Process Output/Input #############
*

*s.t. Acc1_CommodityOutputByProcess{r in REGION, l in TIMESLICE, t in PROCESS, f in COMMODITY, y in TIME}: OutputRateByProcess[r,l,p,c,y] * YearSplit[l,y] = OutputByProcess[r,l,p,c,y];
*Equation EQ_Acc1_CommodityOutputByProcess(REGION,TIMESLICE,PROCESS,COMMODITY,TIME);
*EQ_Acc1_CommodityOutputByProcess(r,l,p,c,t)$PrcHasOutputCom(P,C).. OutputByProcess(r,l,p,c,t) =E= OutputRateByProcess(r,l,p,c,t) * YearSplit(l,t);

*s.t. Acc2_CommodityUseByProcess{r in REGION, l in TIMESLICE, t in PROCESS, f in COMMODITY, y in TIME}: InputRateByProcess[r,l,p,c,y] * YearSplit[l,y] = InputByProcess[r,l,p,c,y];
*Equation EQ_Acc2_CommodityUseByProcess(REGION,TIMESLICE,PROCESS,COMMODITY,TIME);
*EQ_Acc2_CommodityUseByProcess(r,l,p,c,t)$PrcHasInputCom(P,C).. InputByProcess(r,l,p,c,t) =E= InputRateByProcess(r,l,p,c,t) * YearSplit(l,t);

*s.t. Acc3_AverageAnnualRateOfActivity{r in REGION, t in PROCESS, m in MODE_OF_OPERATION, y in TIME}: sum{l in TIMESLICE} RateOfActivity[r,l,p,m,y]*YearSplit[l,y] = TotalAnnualProcessActivityByMode[r,p,m,y];
Equation EQ_Acc3_AverageAnnualActivityRateByMode(REGION,PROCESS,MODE_OF_OPERATION,TIME);
EQ_Acc3_AverageAnnualActivityRateByMode(r,p,m,t)$(PrcHasMode(p,m)).. ActivityAnnualByMode(r,p,m,t) =E= sum(l, ActivityRateByMode(r,l,p,m,t)*YearSplit(l,t));
* Fix nonexistent modes to zero:
ActivityRateByMode.FX(r,l,p,m,t)$(not PrcHasMode(P,M)) = 0;

*s.t. Acc4_ModelPeriodCostByRegion{r in REGION}:sum{y in TIME}TotalDiscountedCost[r,y] = ModelPeriodCostByRegion[r];
*Equation EQ_Acc4_CumulativeCostByRegion(REGION);
*EQ_Acc4_CumulativeCostByRegion(r).. CumulativeCostByRegion(r) =E= sum((t), DiscountedCostTotal(r,t));

*
* ######### Storage Equations #############
*
*s.t. S1_RateOfStorageCharge{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in TIME}: sum{t in PROCESS, m in MODE_OF_OPERATION, l in TIMESLICE:ProcessToStorage[r,p,s,m]>0} RateOfActivity[r,l,p,m,y] * ProcessToStorage[r,p,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh] = RateOfStorageCharge[r,s,ls,ld,lh,y];
Equation EQ_S1_StorageChargeRate(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
EQ_S1_StorageChargeRate(r,s,ls,ld,lh,t)..  sum((p,m,l)$(ProcessToStorage(r,p,s,m)>0), ActivityRateByMode(r,l,p,m,t) * ProcessToStorage(r,p,s,m) * Conversionls(l,ls) * Conversionld(l,ld) * Conversionlh(l,lh)) =e= StorageChargeRate(r,s,ls,ld,lh,t);
*s.t. S2_RateOfStorageDischarge{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in TIME}: sum{t in PROCESS, m in MODE_OF_OPERATION, l in TIMESLICE:ProcessFromStorage[r,p,s,m]>0} RateOfActivity[r,l,p,m,y] * ProcessFromStorage[r,p,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh] = RateOfStorageDischarge[r,s,ls,ld,lh,y];
Equation EQ_S2_StorageDischargeRate(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
EQ_S2_StorageDischargeRate(r,s,ls,ld,lh,t)..  sum((p,m,l)$(ProcessFromStorage(r,p,s,m)>0),ActivityRateByMode(r,l,p,m,t) * ProcessFromStorage(r,p,s,m) * Conversionls(l,ls) * Conversionld(l,ld) * Conversionlh(l,lh)) =e= StorageDischargeRate(r,s,ls,ld,lh,t);
*s.t. S3_NetChargeWithinYear{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in TIME}: sum{l in TIMESLICE:Conversionls[l,ls]>0&&Conversionld[l,ld]>0&&Conversionlh[l,lh]>0}  (RateOfStorageCharge[r,s,ls,ld,lh,y] - RateOfStorageDischarge[r,s,ls,ld,lh,y]) * YearSplit[l,y] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh] = NetChargeWithinYear[r,s,ls,ld,lh,y];
Equation EQ_S3_StorageNetChargeWithinYear(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
EQ_S3_StorageNetChargeWithinYear(r,s,ls,ld,lh,t).. sum(l$(Conversionls(l,ls)>0 AND Conversionld(l,ld)>0 AND Conversionlh(l,lh)>0),  (StorageChargeRate(r,s,ls,ld,lh,t) - StorageDischargeRate(r,s,ls,ld,lh,t)) * YearSplit(l,t) * Conversionls(l,ls) * Conversionld(l,ld) * Conversionlh(l,lh)) =e= StorageNetChargeWithinYear(r,s,ls,ld,lh,t);
*s.t. S4_NetChargeWithinDay{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in TIME}: (RateOfStorageCharge[r,s,ls,ld,lh,y] - RateOfStorageDischarge[r,s,ls,ld,lh,y]) * DaySplit[lh,y] = NetChargeWithinDay[r,s,ls,ld,lh,y];
Equation EQ_S4_StorageNetChargeWithinDay(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
EQ_S4_StorageNetChargeWithinDay(r,s,ls,ld,lh,t).. (StorageChargeRate(r,s,ls,ld,lh,t) - StorageDischargeRate(r,s,ls,ld,lh,t)) * DaySplit(t,lh) =e= StorageNetChargeWithinDay(r,s,ls,ld,lh,t);

*s.t. S5_and_S6_StorageLevelYearStart{s in STORAGE, y in TIME, r in REGION}:
StorageLevelYearStart.fx(r,s,t)$(ord(t) = 1) = StorageLevelStart(r,s);
Equation EQ_S5_StorageLeveYearStart(REGION,STORAGE,TIME);
EQ_S5_StorageLeveYearStart(r,s,t)$(ord(t) > 1).. StorageLevelYearStart(r,s,t-1) + sum((ls,ld,lh), StorageNetChargeWithinYear(r,s,ls,ld,lh,t-1)) =e= StorageLevelYearStart(r,s,t);

*s.t. S7_and_S8_StorageLevelYearFinish{s in STORAGE, y in TIME, r in REGION}:
Equation EQ_S7_StorageLevelYearFinish(REGION,STORAGE,TIME);
EQ_S7_StorageLevelYearFinish(r,s,t)$(ord(t) < card(t)).. StorageLevelYearStart(r,s,t+1) =e=  StorageLevelYearFinish(r,s,t);
Equation EQ_S8_StorageLevelYearFinish(REGION,STORAGE,TIME);
EQ_S8_StorageLevelYearFinish(r,s,t)$(ord(t) = card(t)).. StorageLevelYearStart(r,s,t) + sum((ls , ld , lh), StorageNetChargeWithinYear(r,s,ls,ld,lh,t)) =e= StorageLevelYearFinish(r,s,t);

*s.t. S9_and_S10_StorageLevelSeasonStart{s in STORAGE, y in TIME, ls in SEASON, r in REGION}:
Equation EQ_S9_StorageLevelSeasonStart(REGION,STORAGE,SEASON,TIME);
EQ_S9_StorageLevelSeasonStart(r,s,ls,t)$(ord(ls) = 1)..  StorageLevelSeasonStart(r,s,ls,t) =e= StorageLevelYearStart(r,s,t);
Equation EQ_S10_StorageLevelSeasonStart(REGION,STORAGE,SEASON,TIME);
EQ_S10_StorageLevelSeasonStart(r,s,ls,t)$(ord(ls) > 1)..  StorageLevelSeasonStart(r,s,ls,t) =e= StorageLevelSeasonStart(r,s,ls-1,t) + sum((ld,lh), StorageNetChargeWithinYear(r,s,ls-1,ld,lh,t)) ;

*s.t. S11_and_S12_StorageLevelDayTypeStart{s in STORAGE, y in TIME, ls in SEASON, ld in DAYTYPE, r in REGION}:
Equation EQ_S11_StorageLevelDayTypeStart(REGION,STORAGE,SEASON,DAYTYPE,TIME);
EQ_S11_StorageLevelDayTypeStart(r,s,ls,ld,t)$(ord(ld) = 1).. StorageLevelSeasonStart(r,s,ls,t) =e=  StorageLevelDayTypeStart(r,s,ls,ld,t);
Equation EQ_S12_StorageLevelDayTypeStart(REGION,STORAGE,SEASON,DAYTYPE,TIME);
EQ_S12_StorageLevelDayTypeStart(r,s,ls,ld,t)$(ord(ld) > 1).. StorageLevelDayTypeStart(r,s,ls,ld-1,t) + sum(lh, StorageNetChargeWithinDay(r,s,ls,ld-1,lh,t) * DaysInDayType(t,ls,ld-1) )  =e=  StorageLevelDayTypeStart(r,s,ls,ld,t);

*s.t. S13_and_S14_and_S15_StorageLevelDayTypeFinish{s in STORAGE, y in TIME, ls in SEASON, ld in DAYTYPE, r in REGION}:
Equation EQ_S13_StorageLevelDayTypeFinish(REGION,STORAGE,SEASON,DAYTYPE,TIME);
EQ_S13_StorageLevelDayTypeFinish(r,s,ls,ld,t)$(smax(ldld,ld.val) and smax(lsls,ls.val))..  StorageLevelYearFinish(r,s,t) =E= StorageLevelDayTypeFinish(r,s,ls,ld,t);

Equation EQ_S14_StorageLevelDayTypeFinish(REGION,STORAGE,SEASON,DAYTYPE,TIME);
EQ_S14_StorageLevelDayTypeFinish(r,s,ls,ld,t)$(smax(ldld,ld.val) and not smax(lsls,ls.val))..  StorageLevelSeasonStart(r,s,ls+1,t) =E= StorageLevelDayTypeFinish(r,s,ls,ld,t);

Equation EQ_S15_StorageLevelDayTypeFinish(REGION,STORAGE,SEASON,DAYTYPE,TIME);
EQ_S15_StorageLevelDayTypeFinish(r,s,ls,ld,t)$(smax(ldld,ld.val) and not smax(lsls,ls.val)).. StorageLevelDayTypeFinish(r,s,ls,ld,t) =E= StorageLevelDayTypeFinish(r,s,ls,ld+1,t) - sum(lh,  StorageNetChargeWithinDay(r,s,ls,ld+1,lh,t)  * DaysInDayType(t,ls,ld+1) );

*
* ######### Storage Constraints #############
*
*s.t. SC1_LowerLimit_BeginningOfDailyTimeBracketOfFirstInstanceOfDayTypeInFirstWeekConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in TIME}: 0 <= (StorageLevelDayTypeStart[r,s,ls,ld,y]+sum{lhlh in DAILYTIMEBRACKET:lh-lhlh>0} NetChargeWithinDay[r,s,ls,ld,lhlh,y])-StorageLowerLimit[r,s,y];
Equation EQ_SC1_LowerLimit(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
EQ_SC1_LowerLimit(r,s,ls,ld,lh,t).. 0 =L= (StorageLevelDayTypeStart(r,s,ls,ld,t)+sum(lhlh$(ord(lh)-ord(lhlh) > 0),StorageNetChargeWithinDay(r,s,ls,ld,lhlh,t)))-StorageLowerLimit(r,s,t);

*s.t. SC1_UpperLimit_BeginningOfDailyTimeBracketOfFirstInstanceOfDayTypeInFirstWeekConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in TIME}: (StorageLevelDayTypeStart[r,s,ls,ld,y]+sum{lhlh in DAILYTIMEBRACKET:lh-lhlh>0} NetChargeWithinDay[r,s,ls,ld,lhlh,y])-StorageUpperLimit[r,s,y] <= 0;
Equation EQ_SC1_UpperLimit(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
EQ_SC1_UpperLimit(r,s,ls,ld,lh,t).. StorageLevelDayTypeStart(r,s,ls,ld,t) + sum(lhlh$(ord(lh)-ord(lhlh) > 0),StorageNetChargeWithinDay(r,s,ls,ld,lhlh,t))-StorageUpperLimit(r,s,t) =L= 0;

*s.t. SC2_LowerLimit_EndOfDailyTimeBracketOfLastInstanceOfDayTypeInFirstWeekConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in TIME}: 0 <= if ld > min{ldld in DAYTYPE} min(ldld) then (StorageLevelDayTypeStart[r,s,ls,ld,y]-sum{lhlh in DAILYTIMEBRACKET:lh-lhlh<0} NetChargeWithinDay[r,s,ls,ld-1,lhlh,y])-StorageLowerLimit[r,s,y];
Equation EQ_SC2_LowerLimit(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
EQ_SC2_LowerLimit(r,s,ls,ld,lh,t).. 0 =L= (StorageLevelDayTypeStart(r,s,ls,ld,t)-sum(lhlh$(ord(lh)-ord(lhlh) < 0), StorageNetChargeWithinDay(r,s,ls,ld-1,lhlh,t) ))$(ord(ld) > 1)-StorageLowerLimit(r,s,t);

*s.t. SC2_UpperLimit_EndOfDailyTimeBracketOfLastInstanceOfDayTypeInFirstWeekConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in TIME}: if ld > min{ldld in DAYTYPE} min(ldld) then (StorageLevelDayTypeStart[r,s,ls,ld,y]-sum{lhlh in DAILYTIMEBRACKET:lh-lhlh<0} NetChargeWithinDay[r,s,ls,ld-1,lhlh,y])-StorageUpperLimit[r,s,y] <= 0;
Equation EQ_SC2_UpperLimit(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
EQ_SC2_UpperLimit(r,s,ls,ld,lh,t).. (StorageLevelDayTypeStart(r,s,ls,ld,t)-sum(lhlh$(ord(lh)-ord(lhlh) < 0), StorageNetChargeWithinDay(r,s,ls,ld-1,lhlh,t)))$(ord(ld) > 1) -StorageUpperLimit(r,s,t) =L= 0;

*s.t. SC3_LowerLimit_EndOfDailyTimeBracketOfLastInstanceOfDayTypeInLastWeekConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in TIME}:  0 <= (StorageLevelDayTypeFinish[r,s,ls,ld,y] - sum{lhlh in DAILYTIMEBRACKET:lh-lhlh<0} NetChargeWithinDay[r,s,ls,ld,lhlh,y])-StorageLowerLimit[r,s,y];
Equation EQ_SC3_LowerLimit(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
EQ_SC3_LowerLimit(r,s,ls,ld,lh,t)..  0 =L= (StorageLevelDayTypeFinish(r,s,ls,ld,t) - sum(lhlh$(ord(lh)-ord(lhlh) <0), StorageNetChargeWithinDay(r,s,ls,ld,lhlh,t))) - StorageLowerLimit(r,s,t);

*s.t. SC3_UpperLimit_EndOfDailyTimeBracketOfLastInstanceOfDayTypeInLastWeekConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in TIME}:  (StorageLevelDayTypeFinish[r,s,ls,ld,y] - sum{lhlh in DAILYTIMEBRACKET:lh-lhlh<0} NetChargeWithinDay[r,s,ls,ld,lhlh,y])-StorageUpperLimit[r,s,y] <= 0;
Equation EQ_SC3_UpperLimit(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
EQ_SC3_UpperLimit(r,s,ls,ld,lh,t).. (StorageLevelDayTypeFinish(r,s,ls,ld,t) - sum(lhlh$(ord(lh)-ord(lhlh) <0), StorageNetChargeWithinDay(r,s,ls,ld,lhlh,t)) ) - StorageUpperLimit(r,s,t) =L= 0;

*s.t. SC4_LowerLimit_BeginningOfDailyTimeBracketOfFirstInstanceOfDayTypeInLastWeekConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in TIME}:         0 <= if ld > min{ldld in DAYTYPE} min(ldld) then (StorageLevelDayTypeFinish[r,s,ls,ld-1,y]+sum{lhlh in DAILYTIMEBRACKET:lh-lhlh>0} NetChargeWithinDay[r,s,ls,ld,lhlh,y])-StorageLowerLimit[r,s,y];
Equation EQ_SC4_LowerLimit(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
EQ_SC4_LowerLimit(r,s,ls,ld,lh,t).. 0 =L= (StorageLevelDayTypeFinish(r,s,ls,ld-1,t)+sum(lhlh$(ord(lh)-ord(lhlh) >0), StorageNetChargeWithinDay(r,s,ls,ld,lhlh,t) ))$(ord(ld) > 1) -StorageLowerLimit(r,s,t);

*s.t. SC4_UpperLimit_BeginningOfDailyTimeBracketOfFirstInstanceOfDayTypeInLastWeekConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in TIME}: if ld > min{ldld in DAYTYPE} min(ldld) then (StorageLevelDayTypeFinish[r,s,ls,ld-1,y]+sum{lhlh in DAILYTIMEBRACKET:lh-lhlh>0} NetChargeWithinDay[r,s,ls,ld,lhlh,y])-StorageUpperLimit[r,s,y] <= 0;
Equation EQ_SC4_UpperLimit(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
EQ_SC4_UpperLimit(r,s,ls,ld,lh,t).. (StorageLevelDayTypeFinish(r,s,ls,ld-1,t)+sum(lhlh$(ord(lh)-ord(lhlh) >0), StorageNetChargeWithinDay(r,s,ls,ld,lhlh,t) ))$(ord(ld) > 1) -StorageUpperLimit(r,s,t) =L= 0;

*s.t. SC5_MaxChargeConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in TIME}: RateOfStorageCharge[r,s,ls,ld,lh,y] <= StorageMaxChargeRate[r,s];
Equation EQ_SC5_MaxChargeConstraint(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
EQ_SC5_MaxChargeConstraint(r,s,ls,ld,lh,t).. StorageChargeRate(r,s,ls,ld,lh,t) =L= StorageMaxChargeRate(r,s);

*s.t. SC6_MaxDischargeConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in TIME}: RateOfStorageDischarge[r,s,ls,ld,lh,y] <= StorageMaxDischargeRate[r,s];
Equation EQ_SC6_MaxDischargeConstraint(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,TIME);
EQ_SC6_MaxDischargeConstraint(r,s,ls,ld,lh,t).. StorageDischargeRate(r,s,ls,ld,lh,t) =L= StorageMaxDischargeRate(r,s);

*
* ######### Storage Investments #############
*
*s.t. SI1_StorageUpperLimit{r in REGION, s in STORAGE, y in TIME}: AccumulatedNewStorageCapacity[r,s,y]+ResidualStorageCapacity[r,s,y] = StorageUpperLimit[r,s,y];
Equation EQ_SI1_StorageUpperLimit(REGION,STORAGE,TIME);
EQ_SI1_StorageUpperLimit(r,s,t).. StorageUpperLimit(r,s,t) =E= StorageCapacityNewAccumulated(r,s,t)+StorageResidualCapacity(r,s,t);

*s.t. SI2_StorageLowerLimit{r in REGION, s in STORAGE, y in TIME}: MinStorageCharge[r,s,y]*StorageUpperLimit[r,s,y] = StorageLowerLimit[r,s,y];
Equation EQ_SI2_StorageLowerLimit(REGION,STORAGE,TIME);
EQ_SI2_StorageLowerLimit(r,s,t).. StorageLowerLimit(r,s,t) =E= StorageMinCharge(r,s,t)*StorageUpperLimit(r,s,t);

*s.t. SI3_TotalNewStorage{r in REGION, s in STORAGE, y in TIME}: sum{yy in TIME: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]=AccumulatedNewStorageCapacity[r,s,y];
Equation EQ_SI3_TotalNewStorage(REGION,STORAGE,TIME);
EQ_SI3_TotalNewStorage(r,s,t)..  StorageCapacityNewAccumulated(r,s,t) =E= sum(tt$(t.val-tt.val < StorageOperationalLife(r,s) and t.val-tt.val gt 0), dur(t) * StorageCapacityNew(r,s,tt));

*s.t. SI4_UndiscountedCapitalInvestmentStorage{r in REGION, s in STORAGE, y in TIME}: CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y] = CapitalInvestmentStorage[r,s,y];
Equation EQ_SI4_StorageCapitalInvestmentUndiscounted(REGION,STORAGE,TIME);
EQ_SI4_StorageCapitalInvestmentUndiscounted(r,s,t).. StorageCapitalInvestment(r,s,t) =E= StorageCapitalCost(r,s,t) * StorageCapacityNew(r,s,t);

*s.t. SI5_DiscountingCapitalInvestmentStorage{r in REGION, s in STORAGE, y in TIME}: CapitalInvestmentStorage[r,s,y]/((1+DiscountRate[r])^(t-min{yy in TIME} min(tt))) = DiscountedCapitalInvestmentStorage[r,s,y];
Equation EQ_SI5_StorageCapitalInvestmentDiscounting(REGION,STORAGE,TIME);
EQ_SI5_StorageCapitalInvestmentDiscounting(r,s,t)..  StorageCapitalInvestmentDiscounted(r,s,t) =E= StorageCapitalInvestment(r,s,t)/((1+DiscountRate(r))**(t.val-smin(tt,tt.val)));

*s.t. SI6_SalvageValueStorageAtEndOfPeriod1{r in REGION, s in STORAGE, y in TIME: (t+OperationalLifeStorage[r,s]-1) <= (max{yy in TIME} max(tt))}: 0 = SalvageValueStorage[r,s,y];
Equation EQ_SI6_SalvageValueStorageAtEndOfPeriod1(REGION,STORAGE,TIME);
EQ_SI6_SalvageValueStorageAtEndOfPeriod1(r,s,t)$((t.val+StorageOperationalLife(r,s)-1) le smax(tt,tt.val))..
            StorageSalvageValue(r,s,t) =E= 0;

*s.t. SI7_SalvageValueStorageAtEndOfPeriod2{r in REGION, s in STORAGE, y in TIME: (DepreciationMethod[r]=1 && (t+OperationalLifeStorage[r,s]-1) > (max{yy in TIME} max(tt)) && DiscountRate[r]=0) || (DepreciationMethod[r]=2 && (t+OperationalLifeStorage[r,s]-1) > (max{yy in TIME} max(tt)))}: CapitalInvestmentStorage[r,s,y]*(1-(max{yy in TIME} max(tt) - y+1)/OperationalLifeStorage[r,s]) = SalvageValueStorage[r,s,y];
Equation EQ_SI7_SalvageValueStorageAtEndOfPeriod2(REGION,STORAGE,TIME);
EQ_SI7_SalvageValueStorageAtEndOfPeriod2(r,s,t)$((DepreciationMethod(r)=1 and (t.val+StorageOperationalLife(r,s)-1) > smax(tt,tt.val) and DiscountRate(r)=0) or (DepreciationMethod(r)=2 and (t.val+StorageOperationalLife(r,s)-1) > smax(tt,tt.val)))..
            StorageSalvageValue(r,s,t) =E= StorageCapitalInvestment(r,s,t)*(1- sum(tt$(ord(tt)=card(tt)),tt.val)  - t.val+1)/StorageOperationalLife(r,s);

*s.t. SI8_SalvageValueStorageAtEndOfPeriod3{r in REGION, s in STORAGE, y in TIME: DepreciationMethod[r]=1 && (t+OperationalLifeStorage[r,s]-1) > (max{yy in TIME} max(tt)) && DiscountRate[r]>0}: CapitalInvestmentStorage[r,s,y]*(1-(((1+DiscountRate[r])^(max{yy in TIME} max(tt) - y+1)-1)/((1+DiscountRate[r])^OperationalLifeStorage[r,s]-1))) = SalvageValueStorage[r,s,y];
Equation EQ_SI8_SalvageValueStorageAtEndOfPeriod3(REGION,STORAGE,TIME);
EQ_SI8_SalvageValueStorageAtEndOfPeriod3(r,s,t)$(DepreciationMethod(r)=1 and ((t.val+StorageOperationalLife(r,s)-1) > smax(tt,tt.val) and DiscountRate(r)>0))..
            StorageSalvageValue(r,s,t) =E= StorageCapitalInvestment(r,s,t)*(1-(((1+DiscountRate(r))**(smax(tt,tt.val)-t.val+1)-1)/((1+DiscountRate(r))**StorageOperationalLife(r,s)-1)));

*s.t. SI9_SalvageValueStorageDiscountedToStartYear{r in REGION, s in STORAGE, y in TIME}: SalvageValueStorage[r,s,y]/((1+DiscountRate[r])^(max{yy in TIME} max(tt)-min{yy in TIME} min(tt)+1)) = DiscountedSalvageValueStorage[r,s,y];
Equation EQ_SI9_SalvageValueStorageDiscountedToStartYear(REGION,STORAGE,TIME);
EQ_SI9_SalvageValueStorageDiscountedToStartYear(r,s,t).. StorageSalvageValueDiscounted(r,s,t) =E= StorageSalvageValue(r,s,t)/((1+DiscountRate(r))**(smax(tt,tt.val)-smin(tt,tt.val) +1));

*s.t. SI10_TotalDiscountedCostByStorage{r in REGION, s in STORAGE, y in TIME}: DiscountedCapitalInvestmentStorage[r,s,y]-DiscountedSalvageValueStorage[r,s,y] = TotalDiscountedStorageCost[r,s,y];
Equation EQ_SI10_DiscountedCostTotalByStorage(REGION,STORAGE,TIME);
EQ_SI10_DiscountedCostTotalByStorage(r,s,t).. StorageTotalDiscountedCost(r,s,t) =E= StorageCapitalInvestmentDiscounted(r,s,t) - StorageSalvageValueDiscounted(r,s,t);

*
* ############### Captial Costs #############
*
*s.t. CC1_UndiscountedCapitalInvestment{r in REGION, t in PROCESS, y in TIME}: CapitalCost[r,p,y] * NewCapacity[r,p,y] = CapitalInvestment[r,p,y];
Equation EQ_CC1_CapitalInvestmentUndiscounted(REGION,PROCESS,TIME);
EQ_CC1_CapitalInvestmentUndiscounted(r,p,t).. CapitalInvestment(r,p,t) =E= CapitalCost(r,p,t) * CapacityNew(r,p,t);

*s.t. CC2_DiscountingCapitalInvestment{r in REGION, t in PROCESS, y in TIME}: CapitalInvestment[r,p,y]/((1+DiscountRate[r])^(t-min{yy in TIME} min(tt))) = DiscountedCapitalInvestment[r,p,y];
Equation EQ_CC2_DiscountingCapitalInvestmenta(REGION,PROCESS,TIME);
EQ_CC2_DiscountingCapitalInvestmenta(r,p,t).. CapitalInvestmentDiscounted(r,p,t) =E= CapitalInvestment(r,p,t)/((1+DiscountRate(r))**(t.val-smin(tt, tt.val)));

*
* ##############* Salvage Value #############
*
*s.t. SV1_SalvageValueAtEndOfPeriod1{r in REGION, t in PROCESS, y in TIME: DepreciationMethod[r]=1 && (y + OperationalLife[r,p]-1) > (max{yy in TIME} max(tt)) && DiscountRate[r]>0}: SalvageValue[r,p,y] = CapitalCost[r,p,y]*NewCapacity[r,p,y]*(1-(((1+DiscountRate[r])^(max{yy in TIME} max(tt) - y+1)-1)/((1+DiscountRate[r])^OperationalLife[r,p]-1)));
Equation EQ_SV1_SalvageValueAtEndOfPeriod1(REGION,PROCESS,TIME);
EQ_SV1_SalvageValueAtEndOfPeriod1(r,p,t)$(DepreciationMethod(r)=1 and ((t.val + OperationalLife(r,p)-1 > smax(tt, tt.val)) and (DiscountRate(r) > 0))).. SalvageValue(r,p,t) =e= CapitalCost(r,p,t)*CapacityNew(r,p,t)*(1-(((1+DiscountRate(r))**(smax(tt, tt.val) - t.val+1) -1) /((1+DiscountRate(r))**OperationalLife(r,p)-1)));
*s.t. SV2_SalvageValueAtEndOfPeriod2{r in REGION, t in PROCESS, y in TIME: (DepreciationMethod[r]=1 && (y + OperationalLife[r,p]-1) > (max{yy in TIME} max(tt)) && DiscountRate[r]=0) || (DepreciationMethod[r]=2 && (y + OperationalLife[r,p]-1) > (max{yy in TIME} max(tt)))}: SalvageValue[r,p,y] = CapitalCost[r,p,y]*NewCapacity[r,p,y]*(1-(max{yy in TIME} max(tt) - y+1)/OperationalLife[r,p]);
Equation EQ_SV2_SalvageValueAtEndOfPeriod2(REGION,PROCESS,TIME);
EQ_SV2_SalvageValueAtEndOfPeriod2(r,p,t)$(((t.val + OperationalLife(r,p)-1 > smax(tt, tt.val)) and (DiscountRate(r) = 0)) or (DepreciationMethod(r)=2 and (t.val + OperationalLife(r,p)-1 > smax(tt, tt.val)))).. SalvageValue(r,p,t) =e= CapitalCost(r,p,t)*CapacityNew(r,p,t)*(1-smax(tt, tt.val)- t.val+1)/OperationalLife(r,p);
*s.t. SV3_SalvageValueAtEndOfPeriod3{r in REGION, t in PROCESS, y in TIME: (y + OperationalLife[r,p]-1) <= (max{yy in TIME} max(tt))}: SalvageValue[r,p,y] = 0;
Equation EQ_SV3_SalvageValueAtEndOfPeriod3(REGION,PROCESS,TIME);
EQ_SV3_SalvageValueAtEndOfPeriod3(r,p,t)$(t.val + OperationalLife(r,p)-1 <= smax(tt, tt.val)).. SalvageValue(r,p,t) =e= 0;
*s.t. SV4_SalvageValueDiscountedToStartYear{r in REGION, t in PROCESS, y in TIME}: DiscountedSalvageValue[r,p,y] = SalvageValue[r,p,y]/((1+DiscountRate[r])^(1+max{yy in TIME} max(tt)-min{yy in TIME} min(tt)));
Equation EQ_SV4_SalvageValueDiscToStartYr(REGION,PROCESS,TIME);
EQ_SV4_SalvageValueDiscToStartYr(r,p,t).. SalvageValueDiscounted(r,p,t) =e= SalvageValue(r,p,t)/((1+DiscountRate(r))**(1+smax(tt, tt.val) - smin(tt, tt.val)));

*
* ############### Operating Costs #############
*

*s.t. OC1_OperatingCostsVariable{r in REGION, t in PROCESS, l in TIMESLICE, y in TIME}: sum{m in MODE_OF_OPERATION} TotalAnnualProcessActivityByMode[r,p,m,y]*VariableCost[r,p,m,y] = AnnualVariableOperatingCost[r,p,y];
Equation EQ_OC1_OperatingCostsVariable(REGION,TIMESLICE,PROCESS,TIME);
EQ_OC1_OperatingCostsVariable(r,l,p,t).. OperatingCostVariableAnnual(r,p,t) =E= sum(m, (ActivityAnnualByMode(r,p,m,t)*VariableCost(r,p,m,t)));

*s.t. OC2_OperatingCostsFixedAnnual{r in REGION, t in PROCESS, y in TIME}: TotalCapacityAnnual[r,p,y]*FixedCost[r,p,y] = AnnualFixedOperatingCost[r,p,y];
Equation EQ_OC2_OperatingCostsFixedAnnual(REGION,PROCESS,TIME);
EQ_OC2_OperatingCostsFixedAnnual(r,p,t).. OperatingCostFixedAnnual(r,p,t) =E= CapacityTotal(r,p,t)*FixedCost(r,p,t);

*s.t. OC3_OperatingCostsTotalAnnual{r in REGION, t in PROCESS, y in TIME}: AnnualFixedOperatingCost[r,p,y]+AnnualVariableOperatingCost[r,p,y] = OperatingCost[r,p,y];
Equation EQ_OC3_OperatingCostsTotalAnnual(REGION,PROCESS,TIME);
EQ_OC3_OperatingCostsTotalAnnual(r,p,t).. OperatingCost(r,p,t) =E= OperatingCostFixedAnnual(r,p,t) + OperatingCostVariableAnnual(r,p,t);

*s.t. OC4_DiscountedOperatingCostsTotalAnnual{r in REGION, t in PROCESS, y in TIME}: OperatingCost[r,p,y]/((1+DiscountRate[r])^(t-min{yy in TIME} min(tt)+0.5)) = DiscountedOperatingCost[r,p,y];
Equation EQ_OC4_DiscountedOperatingCostsTotalAnnual(REGION,PROCESS,TIME);
EQ_OC4_DiscountedOperatingCostsTotalAnnual(r,p,t).. OperatingCostDiscounted(r,p,t) =E= OperatingCost(r,p,t)/((1+DiscountRate(r))**(t.val-smin(tt, tt.val)));

*
* ############### Total Discounted Costs #############
*

*s.t. TDC1_TotalDiscountedCostByProcess{r in REGION, t in PROCESS, y in TIME}: DiscountedOperatingCost[r,p,y]+DiscountedCapitalInvestment[r,p,y]+EmissionPenaltyDiscountedByProcess[r,p,y]-DiscountedSalvageValue[r,p,y] = TotalDiscountedCostByProcess[r,p,y];
* TEk: Note, this is not annual, but whole model period
Equation EQ_TDC1_DiscountedCostTotalByProcess(REGION,PROCESS,TIME);
EQ_TDC1_DiscountedCostTotalByProcess(r,p,t).. DiscountedCostTotalByProcess(r,p,t) =E= OperatingCostDiscounted(r,p,t) * dur(t)
                                                                                         + CapitalInvestmentDiscounted(r,p,t) * dur(t)
                                                                                         + EmissionPenaltyDiscountedByProcess(r,p,t) * dur(t)
                                                                                         - SalvageValueDiscounted(r,p,t);

*s.t. TDC2_TotalDiscountedCost{r in REGION, y in TIME}: sum{t in PROCESS} TotalDiscountedCostByProcess[r,p,y]+sum{s in STORAGE} TotalDiscountedStorageCost[r,s,y] = TotalDiscountedCost[r,y];
Equation EQ_TDC2_DiscountedCostTotal(REGION,TIME);
EQ_TDC2_DiscountedCostTotal(r,t).. DiscountedCostTotal(r,t) =E= sum(p, DiscountedCostTotalByProcess(r,p,t)) + sum(s,StorageTotalDiscountedCost(r,s,t));

*
* ############### Total Capacity Constraints ##############
*
*s.t. TCC1_TotalAnnualMaxCapacityConstraint{r in REGION, t in PROCESS, y in TIME}: TotalCapacityAnnual[r,p,y] <= TotalAnnualMaxCapacity[r,p,y];
Equation EQ_TCC1_TotalAnnualMaxCapacityConstraint(REGION,PROCESS,TIME);
EQ_TCC1_TotalAnnualMaxCapacityConstraint(r,p,t).. CapacityTotal(r,p,t) =L= CapacityTotalMax(r,p,t);

*s.t. TCC2_TotalAnnualMinCapacityConstraint{r in REGION, t in PROCESS, y in TIME: TotalAnnualMinCapacity[r,p,y]>0}: TotalCapacityAnnual[r,p,y] >= TotalAnnualMinCapacity[r,p,y];
Equation EQ_TCC2_TotalAnnualMinCapacityConstraint(REGION,PROCESS,TIME);
EQ_TCC2_TotalAnnualMinCapacityConstraint(r,p,t)$(CapacityTotalMin(r,p,t)>0).. CapacityTotal(r,p,t) =G= CapacityTotalMin(r,p,t);

*
* ############### New Capacity Constraints ##############
*
*s.t. NCC1_TotalAnnualMaxNewCapacityConstraint{r in REGION, t in PROCESS, y in TIME}: NewCapacity[r,p,y] <= TotalAnnualMaxCapacityInvestment[r,p,y];
Equation EQ_NCC1_TotalAnnualMaxNewCapacityConstraint(REGION,PROCESS,TIME);
EQ_NCC1_TotalAnnualMaxNewCapacityConstraint(r,p,t).. CapacityNew(r,p,t) =L= CapacityNewMax(r,p,t);

*s.t. NCC2_TotalAnnualMinNewCapacityConstraint{r in REGION, t in PROCESS, y in TIME: TotalAnnualMinCapacityInvestment[r,p,y]>0}: NewCapacity[r,p,y] >= TotalAnnualMinCapacityInvestment[r,p,y];
Equation EQ_NCC2_TotalAnnualMinNewCapacityConstraint(REGION,PROCESS,TIME);
EQ_NCC2_TotalAnnualMinNewCapacityConstraint(r,p,t)$(CapacityNewMin(r,p,t) > 0).. CapacityNew(r,p,t) =G= CapacityNewMin(r,p,t);

*
* ################ Annual Activity Constraints ##############
*
*s.t. AAC1_TotalAnnualProcessActivity{r in REGION, t in PROCESS, y in TIME}: sum{l in TIMESLICE} RateOfTotalActivity[r,p,l,y]*YearSplit[l,y] = TotalProcessAnnualActivity[r,p,y];
Equation EQ_AAC1_TotalAnnualProcessActivity(REGION,PROCESS,TIME);
EQ_AAC1_TotalAnnualProcessActivity(r,p,t).. ActivityAnnual(r,p,t) =E= sum(l, (ActivityRateTotal(r,l,p,t)*YearSplit(l,t)));
*s.t. AAC2_TotalAnnualProcessActivityUpperLimit{r in REGION, t in PROCESS, y in TIME}: TotalProcessAnnualActivity[r,p,y] <= TotalProcessAnnualActivityUpperLimit[r,p,y] ;
Equation EQ_AAC2_TotalAnnualProcessActivityUpperLimit(REGION,PROCESS,TIME);
EQ_AAC2_TotalAnnualProcessActivityUpperLimit(r,p,t).. ActivityAnnual(r,p,t) =l= ActivityAnnualMax(r,p,t);
*s.t. AAC3_TotalAnnualProcessActivityLowerLimit{r in REGION, t in PROCESS, y in TIME: TotalProcessAnnualActivityLowerLimit[r,p,y]>0}: TotalProcessAnnualActivity[r,p,y] >= TotalProcessAnnualActivityLowerLimit[r,p,y] ;
Equation EQ_AAC3_TotalAnnualProcessActivityLowerLimit(REGION,PROCESS,TIME);
EQ_AAC3_TotalAnnualProcessActivityLowerLimit(r,p,t)$(ActivityAnnualMin(r,p,t) > 0).. ActivityAnnual(r,p,t) =g= ActivityAnnualMin(r,p,t);

*
* ################ Total Activity Constraints ##############
*
*s.t. TAC1_TotalModelHorizonProcessActivity{r in REGION, t in PROCESS}: sum{y in TIME} TotalProcessAnnualActivity[r,p,y] = TotalProcessModelPeriodActivity[r,p];
Equation EQ_TAC1_TotalModelHorizenProcessActivity(REGION,PROCESS);
EQ_TAC1_TotalModelHorizenProcessActivity(r,p).. ActivityCumulative(r,p) =E= sum(t, dur(t) * ActivityAnnual(r,p,t));

*s.t. TAC2_TotalModelHorizonProcessActivityUpperLimit{r in REGION, t in PROCESS: TotalProcessModelPeriodActivityUpperLimit[r,p]>0}: TotalProcessModelPeriodActivity[r,p] <= TotalProcessModelPeriodActivityUpperLimit[r,p] ;
Equation EQ_TAC2_TotalModelHorizenProcessActivityUpperLimit(REGION,PROCESS);
EQ_TAC2_TotalModelHorizenProcessActivityUpperLimit(r,p)$(ActivityCumulativeMax(r,p) > 0).. ActivityCumulative(r,p) =L= ActivityCumulativeMax(r,p);

*s.t. TAC3_TotalModelHorizenProcessActivityLowerLimit{r in REGION, t in PROCESS: TotalProcessModelPeriodActivityLowerLimit[r,p]>0}: TotalProcessModelPeriodActivity[r,p] >= TotalProcessModelPeriodActivityLowerLimit[r,p] ;
Equation EQ_TAC3_TotalModelHorizenProcessActivityLowerLimit(REGION,PROCESS);
EQ_TAC3_TotalModelHorizenProcessActivityLowerLimit(r,p)$(ActivityCumulativeMin(r,p) > 0).. ActivityCumulative(r,p) =G= ActivityCumulativeMin(r,p);

* TEk: Reserve Margin Constraints disabled for SuCCESs to remove unnecessary variables/equations
**
** ############### Reserve Margin Constraint #############* NTS: Should change demand for Output
**
**s.t. RM1_ReserveMargin_TechnologiesIncluded_In_Activity_Units{r in REGION, l in TIMESLICE, y in TIME}: sum {t in PROCESS} TotalCapacityAnnual[r,p,y] * ReserveMarginTagProcess[r,p,y] * CapacityToActivityUnit[r,p]         =         TotalCapacityInReserveMargin[r,y];
*Equation EQ_RM1_ReserveMargin_TechologiesIncluded_In_Activity_Units(REGION,TIMESLICE,TIME);
*EQ_RM1_ReserveMargin_TechologiesIncluded_In_Activity_Units(r,l,t).. TotalCapacityInReserveMargin(r,t) =E= sum(p, CapacityTotal(r,p,t) * ReserveMarginTagProcess(r,p,t) * CapacityToActivityUnit(r,p));
*
**s.t. RM2_ReserveMargin_CommoditysIncluded{r in REGION, l in TIMESLICE, y in TIME}: sum {f in COMMODITY} OutputRate[r,l,c,y] * ReserveMarginTagCommodity[r,c,y] = DemandNeedingReserveMargin[r,l,y];
*Equation EQ_RM2_ReserveMargin_CommoditysIncluded(REGION,TIMESLICE,TIME);
*EQ_RM2_ReserveMargin_CommoditysIncluded(r,l,t).. DemandNeedingReserveMargin(r,l,t) =E= sum(c, OutputRate(r,l,c,t) * ReserveMarginTagCommodity(r,c,t));
*
**s.t. RM3_ReserveMargin_Constraint{r in REGION, l in TIMESLICE, y in TIME}: DemandNeedingReserveMargin[r,l,y] * ReserveMargin[r,y]<= TotalCapacityInReserveMargin[r,y];
*Equation EQ_RM3_ReserveMargin_Constraint(REGION,TIMESLICE,TIME);
*EQ_RM3_ReserveMargin_Constraint(r,l,t).. DemandNeedingReserveMargin(r,l,t) * ReserveMargin(r,t) =L= TotalCapacityInReserveMargin(r,t);

* TEk: RE Output Targets disabled for SuCCESs to remove unnecessary variables/equations
*
* ############### RE Output Target #############* NTS: Should change demand for production
*
*
**s.t. RE2_TechIncluded{r in REGION, y in TIME}: sum{t in PROCESS, f in COMMODITY} OutputByProcessAnnual[r,p,c,y]*RETagProcess[r,p,y] = TotalREOutputAnnual[r,y];
*Equation EQ_RE2_TechIncluded(REGION,TIME);
*EQ_RE2_TechIncluded(r,t).. TotalREOutputAnnual(r,t) =E= sum((p,c), (OutputByProcessAnnual(r,p,c,t)*RETagProcess(r,p,t)));
*
**s.t. RE3_CommodityIncluded{r in REGION, y in TIME}: sum{l in TIMESLICE, f in COMMODITY} OutputRate[r,l,c,y]*YearSplit[l,y]*RETagCommodity[r,c,y] = RETotalOutputOfTargetCommodityAnnual[r,y];
*Equation EQ_RE3_CommodityIncluded(REGION,TIME);
*EQ_RE3_CommodityIncluded(r,t).. RETotalOutputOfTargetCommodityAnnual(r,t) =E= sum((l,c), (OutputRate(r,l,c,t)*YearSplit(l,t)*RETagCommodity(r,c,t)));
*
**s.t. RE4_EnergyConstraint{r in REGION, y in TIME}:REMinOutputTarget[r,y]*RETotalOutputOfTargetCommodityAnnual[r,y] <= TotalREOutputAnnual[r,y];
*Equation EQ_RE4_EnergyConstraint(REGION,TIME);
*EQ_RE4_EnergyConstraint(r,t).. REMinOutputTarget(r,t)*RETotalOutputOfTargetCommodityAnnual(r,t) =L= TotalREOutputAnnual(r,t);



* TEk: these are not for the RE output target, but general equations to calculate annual input and output
*s.t. RE1_CommodityOutputByProcessAnnual{r in REGION, t in PROCESS, f in COMMODITY, y in TIME}: sum{l in TIMESLICE} OutputByProcess[r,l,p,c,y] = OutputByProcessAnnual[r,p,c,y];
Equation EQ_RE1_CommodityOutputAnnualByProcess(REGION,PROCESS,COMMODITY,TIME);
EQ_RE1_CommodityOutputAnnualByProcess(r,p,c,t)$(PrcHasOutputCom(P,C)).. OutputAnnualByProcess(r,p,c,t) =E= sum(l, OutputRateByProcess(r,l,p,c,t) * YearSplit(l,t));

*s.t. RE5_CommodityUseByProcessAnnual{r in REGION, t in PROCESS, f in COMMODITY, y in TIME}: sum{l in TIMESLICE} InputRateByProcess[r,l,p,c,y]*YearSplit[l,y] = InputByProcessAnnual[r,p,c,y];
Equation EQ_RE5_CommodityUseAnnualByProcess(REGION,PROCESS,COMMODITY,TIME);
EQ_RE5_CommodityUseAnnualByProcess(r,p,c,t)$PrcHasInputCom(P,C).. InputAnnualByProcess(r,p,c,t) =E= sum(l, (InputRateByProcess(r,l,p,c,t)*YearSplit(l,t)));

*
* ################ Emissions Accounting ##############
*


*s.t. E1_AnnualEmissionOutputByMode{r in REGION, t in PROCESS, e in EMISSION, m in MODE_OF_OPERATION, y in TIME: EmissionActivityRatio[r,p,e,m,y]<>0}: EmissionActivityRatio[r,p,e,m,y]*TotalAnnualProcessActivityByMode[r,p,m,y]=EmissionAnnualByProcessByMode[r,p,e,m,y];
Equation EQ_E1_AnnualEmissionOutputByMode(REGION,PROCESS,EMISSION,MODE_OF_OPERATION,TIME);
EQ_E1_AnnualEmissionOutputByMode(r,p,e,m,t)$(PrcHasMode(p,m)).. EmissionAnnualByProcessByMode(r,p,e,m,t) =E= EmissionActivityRatio(r,p,e,m,t)*ActivityAnnualByMode(r,p,m,t);
* Fix other modes to zero:
EmissionAnnualByProcessByMode.FX(r,p,e,m,t)$(not PrcHasMode(p,m)) = 0;

*s.t. E2_AnnualEmissionOutput{r in REGION, t in PROCESS, e in EMISSION, y in TIME}: sum{m in MODE_OF_OPERATION} EmissionAnnualByProcessByMode[r,p,e,m,y] = EmissionAnnualByProcess[r,p,e,y];
Equation EQ_E2_AnnualEmissionOutput(REGION,PROCESS,EMISSION,TIME);
EQ_E2_AnnualEmissionOutput(r,p,e,t).. EmissionAnnualByProcess(r,p,e,t) =E= sum(m, EmissionAnnualByProcessByMode(r,p,e,m,t));

*s.t. E3_EmissionPenaltyByTechAndEmission{r in REGION, t in PROCESS, e in EMISSION, y in TIME}: EmissionAnnualByProcess[r,p,e,y]*EmissionPenalty[r,e,y] = EmissionPenaltyByProcessByEmission[r,p,e,y];
Equation EQ_E3_EmissionPenaltyByTechAndEmission(REGION,PROCESS,EMISSION,TIME);
EQ_E3_EmissionPenaltyByTechAndEmission(r,p,e,t).. EmissionPenaltyByProcessByEmission(r,p,e,t) =E= EmissionAnnualByProcess(r,p,e,t)*EmissionPenalty(r,e,t);

*s.t. E4_EmissionPenaltyByProcess{r in REGION, t in PROCESS, y in TIME}: sum{e in EMISSION} EmissionPenaltyByProcessByEmission[r,p,e,y] = EmissionPenaltyByProcess[r,p,y];
Equation EQ_E4_EmissionPenaltyByProcess(REGION,PROCESS,TIME);
EQ_E4_EmissionPenaltyByProcess(r,p,t).. EmissionPenaltyByProcess(r,p,t) =E= sum(e, EmissionPenaltyByProcessByEmission(r,p,e,t));

*s.t. E5_DiscountedEmissionPenaltyByProcess{r in REGION, t in PROCESS, y in TIME}: EmissionPenaltyByProcess[r,p,y]/((1+DiscountRate[r])^(t-min{yy in TIME} min(tt)+0.5)) = EmissionPenaltyDiscountedByProcess[r,p,y];
Equation EQ_E5_DiscountedEmissionPenaltyByProcess(REGION,PROCESS,TIME);
EQ_E5_DiscountedEmissionPenaltyByProcess(r,p,t).. EmissionPenaltyDiscountedByProcess(r,p,t) =E= EmissionPenaltyByProcess(r,p,t)/((1+DiscountRate(r))**(t.val-smin(tt, tt.val)));

*s.t. E6_EmissionsAccounting1{r in REGION, e in EMISSION, y in TIME}: sum{t in PROCESS} EmissionAnnualByProcess[r,p,e,y] = EmissionAnnual[r,e,y];
Equation EQ_E6_EmissionsAccounting1(REGION,EMISSION,TIME);
EQ_E6_EmissionsAccounting1(r,e,t).. EmissionAnnual(r,e,t) =E= sum(p, EmissionAnnualByProcess(r,p,e,t)) + EmissionAnnualExogenous(r,e,t);

*s.t. E7_EmissionsAccounting2{r in REGION, e in EMISSION}: sum{y in TIME} EmissionAnnual[r,e,y] = EmissionsModelPeriod[r,e]- EmissionExogenousModelPeriod[r,e];
*Equation EQ_E7_EmissionsAccounting2(EMISSION,REGION);
*EQ_E7_EmissionsAccounting2(e,r).. EmissionCumulative(e,r) =E= sum(t, dur(t) * EmissionAnnual(r,e,t)) + EmissionExogenousCumulative(r,e);

*s.t. E8_EmissionsAnnualLimit{r in REGION, e in EMISSION, y in TIME}: EmissionAnnual[r,e,y]+EmissionAnnualExogenous[r,e,y] <= EmissionAnnualLimit[r,e,y];
Equation EQ_E8_EmissionsAnnualLimit(REGION,EMISSION,TIME);
EQ_E8_EmissionsAnnualLimit(r,e,t).. EmissionAnnual(r,e,t) =L= EmissionAnnualLimit(r,e,t);

*s.t. E9_EmissionsModelPeriodLimit{r in REGION, e in EMISSION}: EmissionsModelPeriod[r,e] <= EmissionLimitModelPeriod[r,e] ;
Equation EQ_E9_EmissionsCumulativeLimit(EMISSION,REGION);
EQ_E9_EmissionsCumulativeLimit(e,r).. EmissionCumulative(e,r) =L= EmissionLimitCumulative(r,e);
