
* Fix land-areas to SSP2-4.5:
LU_Area.LO(t,pool,use)$(ord(t) >= 2) = 0.99*LU_area_SSP245(t,pool,use);

* SecdN area increases in the SSP scenario, so the constraint that limits its increase cannot be introduced. Set a swich for that:
$setglobal SecdNAreaIsFixed '1'
