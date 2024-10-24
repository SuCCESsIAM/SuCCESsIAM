
set PROCESS /  
Remove_CroplandCH4_1 
Remove_CroplandCH4_2 
Remove_CroplandCH4_3 
Remove_CroplandCH4_4 
Remove_CroplandCH4_5 
*
Remove_LivestockCH4_1
Remove_LivestockCH4_2
Remove_LivestockCH4_3
Remove_LivestockCH4_4
Remove_LivestockCH4_5
*
Remove_WasteCH4_1
Remove_WasteCH4_2
Remove_WasteCH4_3
Remove_WasteCH4_4
Remove_WasteCH4_5
*
Remove_CroplandN2O_1 
Remove_CroplandN2O_2 
Remove_CroplandN2O_3 
Remove_CroplandN2O_4 
Remove_CroplandN2O_5 
*
Remove_LivestockN2O_1
Remove_LivestockN2O_2
Remove_LivestockN2O_3
Remove_LivestockN2O_4
Remove_LivestockN2O_5
*
Remove_WasteN2O_1    
Remove_WasteN2O_2    
Remove_WasteN2O_3    
Remove_WasteN2O_4  
Remove_WasteN2O_5  
/;

set Processes_NonCO2(P) /  
Remove_CroplandCH4_1 
Remove_CroplandCH4_2 
Remove_CroplandCH4_3 
Remove_CroplandCH4_4 
Remove_CroplandCH4_5 
*
Remove_LivestockCH4_1
Remove_LivestockCH4_2
Remove_LivestockCH4_3
Remove_LivestockCH4_4
Remove_LivestockCH4_5
*
Remove_WasteCH4_1
Remove_WasteCH4_2
Remove_WasteCH4_3
Remove_WasteCH4_4
Remove_WasteCH4_5
*
Remove_CroplandN2O_1 
Remove_CroplandN2O_2 
Remove_CroplandN2O_3 
Remove_CroplandN2O_4 
Remove_CroplandN2O_5 
*
Remove_LivestockN2O_1
Remove_LivestockN2O_2
Remove_LivestockN2O_3
Remove_LivestockN2O_4
Remove_LivestockN2O_5
*
Remove_WasteN2O_1    
Remove_WasteN2O_2    
Remove_WasteN2O_3    
Remove_WasteN2O_4  
Remove_WasteN2O_5 
/;

* Reduction percentage with each cost-step
Table data_NonCO2_NonCO2reduction(p,t)
                        2020    2030    2040    2050    2060    2070    2080    2090    2100
Remove_CroplandCH4_1    0.0358  0.1141  0.1443  0.2037  0.1899  0.1946  0.1841  0.2469  0.2739
Remove_CroplandCH4_2    0.0000  0.0301  0.0707  0.0422  0.0588  0.0711  0.1001  0.0614  0.0538
Remove_CroplandCH4_3    0.0000  0.0569  0.0537  0.0779  0.0588  0.0711  0.0852  0.0614  0.0538
Remove_CroplandCH4_4    0.0000  0.2587  0.1598  0.1111  0.0792  0.0746  0.0410  0.0558  0.0319
Remove_CroplandCH4_5    0.0000  0.0000  0.0000  0.1111  0.1924  0.1585  0.1151  0.0916  0.0896
*
Remove_LivestockCH4_1   0.0358  0.1141  0.1443  0.2037  0.1899  0.1946  0.1841  0.2469  0.2739
Remove_LivestockCH4_2   0.0000  0.0301  0.0707  0.0422  0.0588  0.0711  0.1001  0.0614  0.0538
Remove_LivestockCH4_3   0.0000  0.0569  0.0537  0.0779  0.0588  0.0711  0.0852  0.0614  0.0538
Remove_LivestockCH4_4   0.0000  0.2587  0.1598  0.1111  0.0792  0.0746  0.0410  0.0558  0.0319
Remove_LivestockCH4_5   0.0000  0.0000  0.0000  0.1111  0.1924  0.1585  0.1151  0.0916  0.0896
*
Remove_WasteCH4_1       0.0358  0.1141  0.1443  0.2037  0.1899  0.1946  0.1841  0.2469  0.2739
Remove_WasteCH4_2       0.0000  0.0301  0.0707  0.0422  0.0588  0.0711  0.1001  0.0614  0.0538
Remove_WasteCH4_3       0.0000  0.0569  0.0537  0.0779  0.0588  0.0711  0.0852  0.0614  0.0538
Remove_WasteCH4_4       0.0000  0.2587  0.1598  0.1111  0.0792  0.0746  0.0410  0.0558  0.0319
Remove_WasteCH4_5       0.0000  0.0000  0.0000  0.1111  0.1924  0.1585  0.1151  0.0916  0.0896
*
Remove_CroplandN2O_1    0.0258  0.1040  0.0781  0.1172  0.0892  0.1042  0.0869  0.1335  0.1539 
Remove_CroplandN2O_2    0.0000  0.0543  0.0673  0.0325  0.0449  0.0396  0.0813  0.0512  0.0493 
Remove_CroplandN2O_3    0.0000  0.0543  0.0245  0.0413  0.0449  0.0396  0.0262  0.0512  0.0493 
Remove_CroplandN2O_4    0.0000  0.0983  0.0930  0.0573  0.0325  0.0396  0.0262  0.0543  0.0271 
Remove_CroplandN2O_5    0.0000  0.0000  0.0000  0.0573  0.1336  0.1548  0.1060  0.0543  0.0271 
*
Remove_LivestockN2O_1   0.0258  0.1040  0.0781  0.1172  0.0892  0.1042  0.0869  0.1335  0.1539 
Remove_LivestockN2O_2   0.0000  0.0543  0.0673  0.0325  0.0449  0.0396  0.0813  0.0512  0.0493 
Remove_LivestockN2O_3   0.0000  0.0543  0.0245  0.0413  0.0449  0.0396  0.0262  0.0512  0.0493 
Remove_LivestockN2O_4   0.0000  0.0983  0.0930  0.0573  0.0325  0.0396  0.0262  0.0543  0.0271 
Remove_LivestockN2O_5   0.0000  0.0000  0.0000  0.0573  0.1336  0.1548  0.1060  0.0543  0.0271 
*
Remove_WasteN2O_1       0.0258  0.1040  0.0781  0.1172  0.0892  0.1042  0.0869  0.1335  0.1539   
Remove_WasteN2O_2       0.0000  0.0543  0.0673  0.0325  0.0449  0.0396  0.0813  0.0512  0.0493 
Remove_WasteN2O_3       0.0000  0.0543  0.0245  0.0413  0.0449  0.0396  0.0262  0.0512  0.0493 
Remove_WasteN2O_4       0.0000  0.0983  0.0930  0.0573  0.0325  0.0396  0.0262  0.0543  0.0271 
Remove_WasteN2O_5       0.0000  0.0000  0.0000  0.0573  0.1336  0.1548  0.1060  0.0543  0.0271 
;

                                  
VariableCost(r, 'Remove_CroplandCH4_1' , mdfl, t) =   25*28;
VariableCost(r, 'Remove_CroplandCH4_2' , mdfl, t) =   50*28;
VariableCost(r, 'Remove_CroplandCH4_3' , mdfl, t) =  100*28;
VariableCost(r, 'Remove_CroplandCH4_4' , mdfl, t) =  500*28;
VariableCost(r, 'Remove_CroplandCH4_5' , mdfl, t) = 1000*28;
VariableCost(r, 'Remove_LivestockCH4_1', mdfl, t) =   25*28;
VariableCost(r, 'Remove_LivestockCH4_2', mdfl, t) =   50*28;
VariableCost(r, 'Remove_LivestockCH4_3', mdfl, t) =  100*28;
VariableCost(r, 'Remove_LivestockCH4_4', mdfl, t) =  500*28;
VariableCost(r, 'Remove_LivestockCH4_5', mdfl, t) = 1000*28;
VariableCost(r, 'Remove_WasteCH4_1'    , mdfl, t) =   25*28;
VariableCost(r, 'Remove_WasteCH4_2'    , mdfl, t) =   50*28;
VariableCost(r, 'Remove_WasteCH4_3'    , mdfl, t) =  100*28;
VariableCost(r, 'Remove_WasteCH4_4'    , mdfl, t) =  500*28;
VariableCost(r, 'Remove_WasteCH4_5'    , mdfl, t) = 1000*28;
VariableCost(r, 'Remove_CroplandN2O_1' , mdfl, t) =   25*265;
VariableCost(r, 'Remove_CroplandN2O_2' , mdfl, t) =   50*265;
VariableCost(r, 'Remove_CroplandN2O_3' , mdfl, t) =  100*265;
VariableCost(r, 'Remove_CroplandN2O_4' , mdfl, t) =  500*265;
VariableCost(r, 'Remove_CroplandN2O_5' , mdfl, t) = 1000*265;
VariableCost(r, 'Remove_LivestockN2O_1', mdfl, t) =   25*265;
VariableCost(r, 'Remove_LivestockN2O_2', mdfl, t) =   50*265;
VariableCost(r, 'Remove_LivestockN2O_3', mdfl, t) =  100*265;
VariableCost(r, 'Remove_LivestockN2O_4', mdfl, t) =  500*265;
VariableCost(r, 'Remove_LivestockN2O_5', mdfl, t) = 1000*265;
VariableCost(r, 'Remove_WasteN2O_1'    , mdfl, t) =   25*265;
VariableCost(r, 'Remove_WasteN2O_2'    , mdfl, t) =   50*265;
VariableCost(r, 'Remove_WasteN2O_3'    , mdfl, t) =  100*265;
VariableCost(r, 'Remove_WasteN2O_4'    , mdfl, t) =  500*265;
VariableCost(r, 'Remove_WasteN2O_5'    , mdfl, t) = 1000*265;


EmissionActivityRatio(r, 'Remove_CroplandCH4_1' , 'CH4', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_CroplandCH4_2' , 'CH4', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_CroplandCH4_3' , 'CH4', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_CroplandCH4_4' , 'CH4', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_CroplandCH4_5' , 'CH4', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_LivestockCH4_1', 'CH4', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_LivestockCH4_2', 'CH4', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_LivestockCH4_3', 'CH4', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_LivestockCH4_4', 'CH4', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_LivestockCH4_5', 'CH4', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_WasteCH4_1'    , 'CH4', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_WasteCH4_2'    , 'CH4', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_WasteCH4_3'    , 'CH4', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_WasteCH4_4'    , 'CH4', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_WasteCH4_5'    , 'CH4', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_CroplandN2O_1' , 'N2O', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_CroplandN2O_2' , 'N2O', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_CroplandN2O_3' , 'N2O', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_CroplandN2O_4' , 'N2O', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_CroplandN2O_5' , 'N2O', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_LivestockN2O_1', 'N2O', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_LivestockN2O_2', 'N2O', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_LivestockN2O_3', 'N2O', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_LivestockN2O_4', 'N2O', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_LivestockN2O_5', 'N2O', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_WasteN2O_1'    , 'N2O', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_WasteN2O_2'    , 'N2O', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_WasteN2O_3'    , 'N2O', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_WasteN2O_4'    , 'N2O', mdfl,t) = -1;
EmissionActivityRatio(r, 'Remove_WasteN2O_5'    , 'N2O', mdfl,t) = -1;


OperationalLife(r, Processes_NonCO2 ) = 1000;
CapitalCost(r, Processes_NonCO2 , t) = 0;
AvailabilityFactor(r, Processes_NonCO2 , t) = 1;
CapacityFactor(r, Processes_NonCO2 , l, t) = 1;
CapacityToActivityUnit(r, Processes_NonCO2 ) = 1;
CapacityResidual(r, Processes_NonCO2 , t) = 0;


EQUATIONS
    EQ_Max_Remove_CroplandCH4_1(t)
    EQ_Max_Remove_CroplandCH4_2(t)
    EQ_Max_Remove_CroplandCH4_3(t)
    EQ_Max_Remove_CroplandCH4_4(t)
    EQ_Max_Remove_CroplandCH4_5(t)
    EQ_Max_Remove_LivestockCH4_1(t)
    EQ_Max_Remove_LivestockCH4_2(t)
    EQ_Max_Remove_LivestockCH4_3(t)
    EQ_Max_Remove_LivestockCH4_4(t)
    EQ_Max_Remove_LivestockCH4_5(t)
    EQ_Max_Remove_WasteCH4_1(t)  
    EQ_Max_Remove_WasteCH4_2(t)  
    EQ_Max_Remove_WasteCH4_3(t)  
    EQ_Max_Remove_WasteCH4_4(t)  
    EQ_Max_Remove_WasteCH4_5(t)  
    EQ_Max_Remove_CroplandN2O_1(t)
    EQ_Max_Remove_CroplandN2O_2(t)
    EQ_Max_Remove_CroplandN2O_3(t)
    EQ_Max_Remove_CroplandN2O_4(t)
    EQ_Max_Remove_CroplandN2O_5(t)
    EQ_Max_Remove_LivestockN2O_1(t)
    EQ_Max_Remove_LivestockN2O_2(t)
    EQ_Max_Remove_LivestockN2O_3(t)
    EQ_Max_Remove_LivestockN2O_4(t)
    EQ_Max_Remove_LivestockN2O_5(t)
    EQ_Max_Remove_WasteN2O_1(t)  
    EQ_Max_Remove_WasteN2O_2(t)  
    EQ_Max_Remove_WasteN2O_3(t)  
    EQ_Max_Remove_WasteN2O_4(t)  
    EQ_Max_Remove_WasteN2O_5(t)  
;

EQ_Max_Remove_CroplandCH4_1(t)..    ActivityAnnual('World','Remove_CroplandCH4_1' , t) =L= data_NonCO2_NonCO2reduction('Remove_CroplandCH4_1' ,t) * ActivityAnnual('World','LUConn_CroplandCH4Emissions' , t);
EQ_Max_Remove_CroplandCH4_2(t)..    ActivityAnnual('World','Remove_CroplandCH4_2' , t) =L= data_NonCO2_NonCO2reduction('Remove_CroplandCH4_2' ,t) * ActivityAnnual('World','LUConn_CroplandCH4Emissions' , t);
EQ_Max_Remove_CroplandCH4_3(t)..    ActivityAnnual('World','Remove_CroplandCH4_3' , t) =L= data_NonCO2_NonCO2reduction('Remove_CroplandCH4_3' ,t) * ActivityAnnual('World','LUConn_CroplandCH4Emissions' , t);
EQ_Max_Remove_CroplandCH4_4(t)..    ActivityAnnual('World','Remove_CroplandCH4_4' , t) =L= data_NonCO2_NonCO2reduction('Remove_CroplandCH4_4' ,t) * ActivityAnnual('World','LUConn_CroplandCH4Emissions' , t);
EQ_Max_Remove_CroplandCH4_5(t)..    ActivityAnnual('World','Remove_CroplandCH4_5' , t) =L= data_NonCO2_NonCO2reduction('Remove_CroplandCH4_5' ,t) * ActivityAnnual('World','LUConn_CroplandCH4Emissions' , t);
EQ_Max_Remove_LivestockCH4_1(t)..   ActivityAnnual('World','Remove_LivestockCH4_1', t) =L= data_NonCO2_NonCO2reduction('Remove_LivestockCH4_1',t) * ActivityAnnual('World','LUConn_LivestockCH4Emissions', t);
EQ_Max_Remove_LivestockCH4_2(t)..   ActivityAnnual('World','Remove_LivestockCH4_2', t) =L= data_NonCO2_NonCO2reduction('Remove_LivestockCH4_2',t) * ActivityAnnual('World','LUConn_LivestockCH4Emissions', t);
EQ_Max_Remove_LivestockCH4_3(t)..   ActivityAnnual('World','Remove_LivestockCH4_3', t) =L= data_NonCO2_NonCO2reduction('Remove_LivestockCH4_3',t) * ActivityAnnual('World','LUConn_LivestockCH4Emissions', t);
EQ_Max_Remove_LivestockCH4_4(t)..   ActivityAnnual('World','Remove_LivestockCH4_4', t) =L= data_NonCO2_NonCO2reduction('Remove_LivestockCH4_4',t) * ActivityAnnual('World','LUConn_LivestockCH4Emissions', t);
EQ_Max_Remove_LivestockCH4_5(t)..   ActivityAnnual('World','Remove_LivestockCH4_5', t) =L= data_NonCO2_NonCO2reduction('Remove_LivestockCH4_5',t) * ActivityAnnual('World','LUConn_LivestockCH4Emissions', t);
EQ_Max_Remove_WasteCH4_1(t)..       ActivityAnnual('World','Remove_WasteCH4_1'    , t) =L= data_NonCO2_NonCO2reduction('Remove_WasteCH4_1'    ,t) * data_EmissionExogenousWaste('World','CH4', t);
EQ_Max_Remove_WasteCH4_2(t)..       ActivityAnnual('World','Remove_WasteCH4_2'    , t) =L= data_NonCO2_NonCO2reduction('Remove_WasteCH4_2'    ,t) * data_EmissionExogenousWaste('World','CH4', t);
EQ_Max_Remove_WasteCH4_3(t)..       ActivityAnnual('World','Remove_WasteCH4_3'    , t) =L= data_NonCO2_NonCO2reduction('Remove_WasteCH4_3'    ,t) * data_EmissionExogenousWaste('World','CH4', t);
EQ_Max_Remove_WasteCH4_4(t)..       ActivityAnnual('World','Remove_WasteCH4_4'    , t) =L= data_NonCO2_NonCO2reduction('Remove_WasteCH4_4'    ,t) * data_EmissionExogenousWaste('World','CH4', t);
EQ_Max_Remove_WasteCH4_5(t)..       ActivityAnnual('World','Remove_WasteCH4_5'    , t) =L= data_NonCO2_NonCO2reduction('Remove_WasteCH4_5'    ,t) * data_EmissionExogenousWaste('World','CH4', t);
EQ_Max_Remove_CroplandN2O_1(t)..    ActivityAnnual('World','Remove_CroplandN2O_1' , t) =L= data_NonCO2_NonCO2reduction('Remove_CroplandN2O_1' ,t) * ActivityAnnual('World','LUConn_CroplandN2OEmissions' , t);
EQ_Max_Remove_CroplandN2O_2(t)..    ActivityAnnual('World','Remove_CroplandN2O_2' , t) =L= data_NonCO2_NonCO2reduction('Remove_CroplandN2O_2' ,t) * ActivityAnnual('World','LUConn_CroplandN2OEmissions' , t);
EQ_Max_Remove_CroplandN2O_3(t)..    ActivityAnnual('World','Remove_CroplandN2O_3' , t) =L= data_NonCO2_NonCO2reduction('Remove_CroplandN2O_3' ,t) * ActivityAnnual('World','LUConn_CroplandN2OEmissions' , t);
EQ_Max_Remove_CroplandN2O_4(t)..    ActivityAnnual('World','Remove_CroplandN2O_4' , t) =L= data_NonCO2_NonCO2reduction('Remove_CroplandN2O_4' ,t) * ActivityAnnual('World','LUConn_CroplandN2OEmissions' , t);
EQ_Max_Remove_CroplandN2O_5(t)..    ActivityAnnual('World','Remove_CroplandN2O_5' , t) =L= data_NonCO2_NonCO2reduction('Remove_CroplandN2O_5' ,t) * ActivityAnnual('World','LUConn_CroplandN2OEmissions' , t);
EQ_Max_Remove_LivestockN2O_1(t)..   ActivityAnnual('World','Remove_LivestockN2O_1', t) =L= data_NonCO2_NonCO2reduction('Remove_LivestockN2O_1',t) * ActivityAnnual('World','LUConn_LivestockN2OEmissions', t);
EQ_Max_Remove_LivestockN2O_2(t)..   ActivityAnnual('World','Remove_LivestockN2O_2', t) =L= data_NonCO2_NonCO2reduction('Remove_LivestockN2O_2',t) * ActivityAnnual('World','LUConn_LivestockN2OEmissions', t);
EQ_Max_Remove_LivestockN2O_3(t)..   ActivityAnnual('World','Remove_LivestockN2O_3', t) =L= data_NonCO2_NonCO2reduction('Remove_LivestockN2O_3',t) * ActivityAnnual('World','LUConn_LivestockN2OEmissions', t);
EQ_Max_Remove_LivestockN2O_4(t)..   ActivityAnnual('World','Remove_LivestockN2O_4', t) =L= data_NonCO2_NonCO2reduction('Remove_LivestockN2O_4',t) * ActivityAnnual('World','LUConn_LivestockN2OEmissions', t);
EQ_Max_Remove_LivestockN2O_5(t)..   ActivityAnnual('World','Remove_LivestockN2O_5', t) =L= data_NonCO2_NonCO2reduction('Remove_LivestockN2O_5',t) * ActivityAnnual('World','LUConn_LivestockN2OEmissions', t);
EQ_Max_Remove_WasteN2O_1(t)..       ActivityAnnual('World','Remove_WasteN2O_1'    , t) =L= data_NonCO2_NonCO2reduction('Remove_WasteN2O_1'    ,t) * data_EmissionExogenousWaste('World','N2O', t);
EQ_Max_Remove_WasteN2O_2(t)..       ActivityAnnual('World','Remove_WasteN2O_2'    , t) =L= data_NonCO2_NonCO2reduction('Remove_WasteN2O_2'    ,t) * data_EmissionExogenousWaste('World','N2O', t);
EQ_Max_Remove_WasteN2O_3(t)..       ActivityAnnual('World','Remove_WasteN2O_3'    , t) =L= data_NonCO2_NonCO2reduction('Remove_WasteN2O_3'    ,t) * data_EmissionExogenousWaste('World','N2O', t);
EQ_Max_Remove_WasteN2O_4(t)..       ActivityAnnual('World','Remove_WasteN2O_4'    , t) =L= data_NonCO2_NonCO2reduction('Remove_WasteN2O_4'    ,t) * data_EmissionExogenousWaste('World','N2O', t);
EQ_Max_Remove_WasteN2O_5(t)..       ActivityAnnual('World','Remove_WasteN2O_5'    , t) =L= data_NonCO2_NonCO2reduction('Remove_WasteN2O_5'    ,t) * data_EmissionExogenousWaste('World','N2O', t);
                       
