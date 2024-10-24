
* This constraint disallows increasing the area of SecdN land-use (secondary non-forests).
* SecdN has large carbon density, and increasing the area would increase rapidly the vegetation carbon stock, hence causing large carbon sink.
* This would be unrealistic, and unless the area of SecdN is fixed, this constraint is necessary to obtain realistic scenarios.

Equation EQ_LU_Area_SecdN(t,pool);
EQ_LU_Area_SecdN(t,pool)..      LU_Area(t+1,pool,'secdn') =L= LU_Area(t,pool,'secdn');
