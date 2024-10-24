
***************************************************************************************************
*
*   Model debugging technologies
*

*   Backstop technologies (for model infeasibility debugging: provide any commodity with a high price)

set m /BACKSTOP_001*BACKSTOP_100/;
set backstop_m(m) / BACKSTOP_001*BACKSTOP_100 /;
set PROCESS / 
  COMMODITY_BACKSTOP, COMMODITY_SINK
/;

OperationalLife(r,'COMMODITY_BACKSTOP') = 1000;
CapitalCost(r,'COMMODITY_BACKSTOP',t) = 0;
AvailabilityFactor(r,'COMMODITY_BACKSTOP',t) = 1;
CapacityFactor(r,'COMMODITY_BACKSTOP',l,t) = 1;
CapacityToActivityUnit(r,'COMMODITY_BACKSTOP') = 1;
CapacityResidual(r,'COMMODITY_BACKSTOP',t) = 0;
* Produce each commodity with its own mode
OutputActivityRatio(r,'COMMODITY_BACKSTOP',c,backstop_m,t)$(ord(c) = ord(backstop_m)) = 1;
VariableCost(r,'COMMODITY_BACKSTOP',backstop_m,t) = 999999999;


* General commodity sink: consume all unused commodities with very low price (easy check if some commodities have no use)

OperationalLife(r,'COMMODITY_SINK') = 1000;
CapitalCost(r,'COMMODITY_SINK',t) = 0;
AvailabilityFactor(r,'COMMODITY_SINK',t) = 1;
CapacityFactor(r,'COMMODITY_SINK',l,t) = 1;
CapacityToActivityUnit(r,'COMMODITY_SINK') = 1;
CapacityResidual(r,'COMMODITY_SINK',t) = 0;
* Consumer each commodity with its own mode, negative price only for those modes actually taking any input
InputActivityRatio(r,'COMMODITY_SINK',c,backstop_m,t)$(ord(c) = ord(backstop_m)) = 1;
VariableCost(r,'COMMODITY_SINK',backstop_m,t)$(ord(backstop_m) <= card(c)) = -0.00000001;
EmissionActivityRatio(r,'COMMODITY_SINK',e,m,t) = 0;


