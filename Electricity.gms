

*==============================================================================*
* REPRESENTATION  OF  VARIABLE  RENEWABLE  ELECTRICITY  AND  DEMAND
*==============================================================================*

*------------------------------------------------------------------------------*
* Set definitions
*------------------------------------------------------------------------------*

Set     
        week                    representative weeks for the electricity module     / w06, w18, w20, w47 /
        hour                    hour for the electricity module             / t001 * t168 /
        hour_last(hour)         last time period
        ELEC_VRE_type           renewable energy (RE) type  / solar,  wind /
;

ALIAS(week, weekk);
ALIAS(hour, hourr);
hour_last(hour)  = yes$(ord(hour) eq card(hour));


* this should be in the ELEC_TECHS.gms file:
set ELEC_VRE(P)/
ELEC_Wnd1
ELEC_SPV1
/;


set ELEC_VRE_process_type(ELEC_VRE, ELEC_VRE_type)/
ELEC_Wnd1 . wind
ELEC_SPV1 . solar
/;



*------------------------------------------------------------------------------*
* Parameter definitions
*------------------------------------------------------------------------------*

Scalars
* NB. If timestep is changed,  you need to adjust the ref_demand data accordingly
        timestep                     Length of time period t (h)                    / 1 /
        HOURStoYEAR                  Scale-up from the hours of data to 1 year
        
* Existing large-scale storage in the system (mainly pumped hydro)
        ELEC_STORAGE_dec    periodic storage efficiency                 / 0.9999 /
        ELEC_STORAGE_eff    storage input efficiency                    / 0.75 /
        ELEC_STORAGE_in     rate at which storage can be charged        / 0.16 /
        ELEC_STORAGE_out    rate at which storage can be discharged     / 0.16 /
        ELEC_STORAGE_min    minimum state of charge                     / 1E-6 /
;

HOURStoYEAR = 8760 / ( card(week)*card(hour) );

Parameters
*        W(week)                                            weight of week week
* Demand
        ELEC_DemandVariation(week, hour)                      reference power demand
* Generation
        ELEC_VRE_availability(week, ELEC_VRE_type, hour)          VRE availability
*        ELEC_rampup(P)                                ramp up limit as a share of total installed capacity
*        ELEC_rampdown(P)                              ramp down limit as a share of total installed capacity
* Storage
        ELEC_STORAGE_costs(R,T)                                 storage operating costs
        ELEC_STORAGE_maxcap(R,T)                                storage maximum capacity in GWh
        ELEC_STORAGE_initial(R,T)                               initial storage level in GWh
        ELEC_STORAGE_minstate(R,T,week, hour)                 minimum state of charge in GWh
;




*------------------------------------------------------------------------------*
* Variable definitions
*------------------------------------------------------------------------------*

Positive Variables
        ELEC_Demand(R,T,week, hour)                           hourly electricity demand (PJ per h)
        ELEC_conventional_gen(R,T,week, hour, ELEC_TECH)      convetional power generation (PJ per h)
        ELEC_renewable_gen(R,T,week, hour, ELEC_VRE)          actual RE electricity generation (PJ per h)
*        ELEC_STORAGE_stored(R,T,week, hour)                   end-of-period stored energy
*        ELEC_STORAGE_charge(R,T,week, hour)                   energy charged into storage
*        ELEC_STORAGE_discharge(R,T,week, hour)                energy discharged from storage
;

* Exclude heat and steam techs that are in ELEC_TECH but do not produce electricity:
ELEC_conventional_gen.FX(R,T,week, hour, ELEC_TECH)$(sum(M, abs(OutputActivityRatio(R,ELEC_TECH,'ELECGen',M,T)) ) eq 0 ) = 0;
* Exclude VRE techs from conventional generation:
ELEC_conventional_gen.FX(R,T,week, hour, ELEC_TECH)$(ELEC_VRE(ELEC_TECH)) = 0;




*===============================================================================
* Equations:
*===============================================================================
* hourly sub-model for electricity generation and demand that links with the annual-level representation that is already there in SuCCESs


*How to connect the ELEC/VRE module to the rest of SuCCESs
*- the whole ELEC/VRE module needs to be indexed with (R,T)    DONE
*
* So, the variables/equations below need to be connected to the osemosys/success -level variables:
* - InputAnnualByProcess(R,P,C,T)  
* - OutputAnnualByProcess(R,L,C,T)
* - CapacityTotal(r,p,t)     -->  capacity available in success constrains generation

EQUATIONS
    EQ_ELEC_Demand(R,T,week, hour)
    EQ_ELEC_Balance(R,T,week, hour)                              hourly supply-demand balance
    EQ_ELEC_Max_Conv_Gen(R,T,week, hour,ELEC_TECH)             Hourly generation of conventional (non-VRE) Energy
    EQ_ELEC_VRE_Gen(R,T,week, hour, ELEC_VRE, ELEC_VRE_type)      Hourly generation of VR-Energy
    EQ_ELEC_Conv_Gen_Yearly(R,P,T)                               Yearly sum of generated conventional (non-VRE) energy
    EQ_ELEC_VRE_Gen_Yearly(R,ELEC_VRE,T)                         Yearly sum of generated VRE
*    ELEC_VRE_Solar_Gen_Yearly(R,T)                                  Yearly sum of generated solar energy
*    ELEC_VRE_Wind_Gen_Yearly(R,T)                                   Yearly sum of generated wind energy 
;



* Supply-demand balance
EQ_ELEC_Balance(R,T,week, hour)..
    ELEC_Demand(R,T,week, hour)
        =E=   sum(ELEC_TECH, ELEC_conventional_gen(R,T,week, hour, ELEC_TECH))
            + sum(ELEC_VRE,  ELEC_renewable_gen(R,T,week, hour, ELEC_VRE))
*            + ELEC_STORAGE_discharge(R,T,week, hour)
*            - ELEC_STORAGE_charge(R,T,week, hour)
            ;

*  Conventional generation max bound
EQ_ELEC_Max_Conv_Gen(R,T,week, hour,ELEC_TECH)..
        ELEC_conventional_gen(R,T,week, hour, ELEC_TECH) =L= CapacityTotal(R,ELEC_TECH,T)/8760
;

* Renewable Energy generation
EQ_ELEC_VRE_Gen(R,T,week, hour, ELEC_VRE, ELEC_VRE_type)$ELEC_VRE_process_type(ELEC_VRE, ELEC_VRE_type)..
        ELEC_renewable_gen(R,T,week, hour, ELEC_VRE) =L=  CapacityTotal(R,ELEC_VRE,T)/8760
                                                            * CapacityFactor(r,ELEC_VRE,'ANNUAL',t)
                                                            * CapacityToActivityUnit(r,ELEC_VRE)
                                                            * ELEC_VRE_availability(week, ELEC_VRE_type, hour) / (sum( (weekk, hourr), ELEC_VRE_availability(weekk, ELEC_VRE_type, hourr))/(card(week)*card(hour)) )
;



* VRE module-side generation and Success-side generation must be the same
* annual electricity produced by all processes in year T:  sum(p, OutputAnnualByProcess(R,P,C,T))
* the left sides was converted to annual level
EQ_ELEC_Conv_Gen_Yearly(R,ELEC_TECH,T)$(not ELEC_VRE(ELEC_TECH))..
        HOURStoYEAR * sum((week, hour), ELEC_conventional_gen(R,T,week, hour,ELEC_TECH) ) =E=  OutputAnnualByProcess(R,ELEC_TECH,'ELECGen',T)
;


EQ_ELEC_VRE_Gen_Yearly(R,ELEC_VRE,T)..
        HOURStoYEAR * sum((week, hour), ELEC_renewable_gen(R,T,week, hour, ELEC_VRE) ) =E=  OutputAnnualByProcess(R,ELEC_VRE,'ELECGen',T)
;

EQ_ELEC_Demand(R,T,week,hour)..
        ELEC_Demand(R,T,week,hour) =E= ELEC_DemandVariation(week,hour) * InputAnnualByProcess(R,'ELEC_DistributionGrid','ELECGen',T) / 8760
;




*===============================================================================
* Storages   -   for later
*===============================================================================

*EQUATIONS
*    ELEC_STORAGE_Max_Charge_Rate(R,T,week, hour)
*    etc...
*;
*
** Max storage charg rate
*ELEC_STORAGE_Max_Charge_Rate(R,T,week, hour)..
*        timestep * ELEC_STORAGE_in(R,T) * ELEC_STORAGE_maxcap(R,T) - ELEC_STORAGE_charge(R,T, week, hour) =g= 0 ;
*
** Max storage discharge rate            
*ELEC_STORAGE_Max_Discharge_Rate(R,T,week, hour)..
*        timestep * ELEC_STORAGE_out(R,T) * ELEC_STORAGE_maxcap(R,T) - ELEC_STORAGE_discharge(R,T, week, hour) =g= 0 ;
*
** Max end-of-period stored energy         
*ELEC_STORAGE_Max_Stored(R,T,week, hour)..
*        ELEC_STORAGE_maxcap(R,T) - ELEC_STORAGE_stored(R,T,week, hour) =g= 0 ;
*
** Min end-of-period stored energy      
*ELEC_STORAGE_Min_Stored(R,T,week, hour)..
*        - ELEC_STORAGE_minstate(R,T,week, hour) + ELEC_STORAGE_stored(R,T,week, hour) =g= 0 ;
*
** Storage balance
*Storage_balance_p(R,T,week, hour)$( ORD(t) ge 2 )..
*        ELEC_STORAGE_stored(R,T,week, hour) - power(R,T,ELEC_STORAGE_dec, timestep) * ELEC_STORAGE_stored(R,T,week, hour-1) - ELEC_STORAGE_eff(R,T) * ELEC_STORAGE_charge(R,T,week, hour) + ELEC_STORAGE_discharge(R,T,week, hour) =e= 0 ;
*
** Storage balance (for the first hour,  needs to be the same than for the last hour,  i.e. hour_last)
*Storage_balance_effi(R,T,week, hour)$( ORD(t) eq 1 )..
*        ELEC_STORAGE_stored(R,T,week, hour) - power(R,T,ELEC_STORAGE_dec, timestep) * sum(hour_last,  ELEC_STORAGE_stored(R,T,week, ELEC_hour_last)) - ELEC_STORAGE_eff(R,T) * ELEC_STORAGE_charge(R,T,week, hour) + ELEC_STORAGE_discharge(R,T,week, hour) =e= 0 ;
*
**Storage_balance_effi(R,T,week, hour, n, i)$( ORD(t) eq 1 )..
**        ELEC_STORAGE_stored(R,T,week, hour) - ELEC_STORAGE_initial(R,T) * ELEC_STORAGE_dec(R,T)  - ELEC_STORAGE_eff(R,T,) * ELEC_STORAGE_charge(R,T,week, hour) + ELEC_STORAGE_discharge(R,T,week, hour) =e= 0  ;
*
*
*



*===============================================================================
* Demand and VRE variability data
*===============================================================================

table ELEC_DemandVariation(week, hour)
             t001     t002     t003     t004     t005     t006     t007     t008     t009     t010     t011     t012     t013     t014     t015     t016     t017     t018     t019     t020     t021     t022     t023     t024     t025     t026     t027     t028     t029     t030     t031     t032     t033     t034     t035     t036     t037     t038     t039     t040     t041     t042     t043     t044     t045     t046     t047     t048     t049     t050     t051     t052     t053     t054     t055     t056     t057     t058     t059     t060     t061     t062     t063     t064     t065     t066     t067     t068     t069     t070     t071     t072     t073     t074     t075     t076     t077     t078     t079     t080     t081     t082     t083     t084     t085     t086     t087     t088     t089     t090     t091     t092     t093     t094     t095     t096     t097     t098     t099     t100     t101     t102     t103     t104     t105     t106     t107     t108     t109     t110     t111     t112     t113     t114     t115     t116     t117     t118     t119     t120     t121     t122     t123     t124     t125     t126     t127     t128     t129     t130     t131     t132     t133     t134     t135     t136     t137     t138     t139     t140     t141     t142     t143     t144     t145     t146     t147     t148     t149     t150     t151     t152     t153     t154     t155     t156     t157     t158     t159     t160     t161     t162     t163     t164     t165     t166     t167     t168
w06          1.112    1.065    1.029    0.971    0.940    0.938    0.938    0.969    0.996    1.052    1.102    1.134    1.168    1.129    1.079    1.045    1.031    1.053    1.159    1.159    1.160    1.118    1.095    1.156    1.120    1.077    1.069    1.016    0.988    1.024    1.124    1.255    1.312    1.338    1.335    1.339    1.333    1.306    1.277    1.245    1.230    1.250    1.343    1.358    1.282    1.207    1.203    1.219    1.168    1.123    1.096    1.049    1.033    1.079    1.179    1.281    1.313    1.324    1.322    1.318    1.304    1.276    1.246    1.210    1.194    1.210    1.306    1.330    1.261    1.193    1.195    1.212    1.162    1.120    1.098    1.053    1.042    1.089    1.191    1.295    1.332    1.346    1.343    1.347    1.348    1.327    1.302    1.268    1.251    1.262    1.348    1.373    1.300    1.233    1.239    1.259    1.213    1.173    1.153    1.111    1.097    1.144    1.250    1.359    1.389    1.401    1.400    1.396    1.384    1.357    1.328    1.290    1.274    1.289    1.385    1.412    1.338    1.271    1.272    1.291    1.246    1.206    1.182    1.139    1.129    1.177    1.280    1.378    1.409    1.424    1.414    1.402    1.388    1.352    1.313    1.272    1.255    1.275    1.366    1.391    1.329    1.271    1.283    1.305    1.253    1.217    1.186    1.133    1.106    1.119    1.154    1.198    1.237    1.287    1.305    1.311    1.330    1.298    1.253    1.215    1.193    1.209    1.293    1.320    1.266    1.217    1.238    1.265
w18          0.831    0.799    0.750    0.724    0.728    0.730    0.742    0.773    0.807    0.822    0.839    0.875    0.850    0.811    0.780    0.760    0.758    0.793    0.832    0.847    0.860    0.890    0.924    0.873    0.827    0.793    0.741    0.718    0.728    0.733    0.743    0.779    0.818    0.840    0.859    0.893    0.857    0.809    0.768    0.749    0.751    0.795    0.844    0.845    0.865    0.891    0.920    0.876    0.836    0.813    0.772    0.764    0.819    0.914    1.006    1.048    1.065    1.059    1.063    1.067    1.044    1.021    0.988    0.960    0.945    0.965    0.982    0.955    0.950    0.966    0.987    0.928    0.877    0.853    0.812    0.800    0.840    0.922    1.007    1.055    1.072    1.070    1.072    1.074    1.054    1.031    0.995    0.971    0.959    0.981    1.000    0.968    0.959    0.976    1.001    0.940    0.887    0.861    0.817    0.806    0.847    0.928    1.013    1.054    1.068    1.064    1.064    1.061    1.033    1.008    0.978    0.948    0.929    0.948    0.962    0.929    0.933    0.952    0.975    0.918    0.866    0.839    0.796    0.786    0.830    0.909    0.991    1.026    1.036    1.027    1.021    1.017    0.989    0.965    0.928    0.894    0.882    0.898    0.901    0.875    0.880    0.907    0.929    0.868    0.810    0.774    0.727    0.706    0.713    0.723    0.755    0.809    0.863    0.887    0.905    0.937    0.911    0.876    0.840    0.808    0.799    0.819    0.837    0.823    0.828    0.866    0.899    0.846
w20          0.730    0.692    0.641    0.616    0.612    0.604    0.620    0.658    0.705    0.735    0.754    0.795    0.764    0.724    0.691    0.668    0.670    0.703    0.741    0.740    0.759    0.802    0.830    0.778    0.729    0.697    0.654    0.648    0.690    0.764    0.852    0.894    0.919    0.923    0.931    0.944    0.930    0.915    0.888    0.865    0.851    0.869    0.880    0.839    0.830    0.856    0.874    0.807    0.750    0.720    0.677    0.662    0.693    0.758    0.846    0.890    0.912    0.921    0.935    0.946    0.933    0.922    0.900    0.878    0.861    0.875    0.881    0.840    0.829    0.858    0.872    0.802    0.745    0.713    0.667    0.654    0.680    0.741    0.825    0.879    0.909    0.924    0.938    0.952    0.939    0.936    0.909    0.884    0.865    0.878    0.884    0.840    0.823    0.849    0.867    0.800    0.745    0.715    0.673    0.656    0.685    0.749    0.841    0.896    0.923    0.943    0.957    0.965    0.948    0.938    0.912    0.888    0.872    0.887    0.895    0.843    0.821    0.850    0.863    0.795    0.743    0.716    0.677    0.671    0.699    0.767    0.858    0.910    0.937    0.943    0.952    0.949    0.927    0.909    0.879    0.851    0.837    0.846    0.848    0.814    0.811    0.858    0.880    0.812    0.753    0.718    0.672    0.651    0.657    0.667    0.699    0.748    0.790    0.811    0.824    0.851    0.822    0.790    0.757    0.729    0.723    0.742    0.755    0.738    0.741    0.801    0.837    0.785
w47          1.074    1.023    0.991    0.938    0.913    0.917    0.935    0.957    0.980    1.023    1.046    1.058    1.083    1.038    0.982    0.952    0.949    1.021    1.113    1.138    1.108    1.074    1.086    1.106    1.068    1.030    1.005    0.964    0.958    1.017    1.128    1.234    1.259    1.265    1.256    1.251    1.246    1.222    1.191    1.164    1.159    1.220    1.287    1.286    1.208    1.143    1.140    1.155    1.096    1.048    1.024    0.981    0.970    1.022    1.130    1.232    1.248    1.244    1.229    1.220    1.207    1.182    1.154    1.126    1.124    1.187    1.255    1.252    1.174    1.108    1.103    1.122    1.064    1.015    0.981    0.943    0.934    0.983    1.091    1.197    1.220    1.213    1.182    1.163    1.152    1.119    1.089    1.056    1.055    1.120    1.193    1.192    1.121    1.060    1.060    1.082    1.021    0.969    0.941    0.893    0.879    0.919    1.025    1.122    1.129    1.130    1.122    1.116    1.108    1.087    1.066    1.041    1.040    1.097    1.162    1.160    1.089    1.028    1.031    1.048    0.991    0.941    0.908    0.865    0.857    0.905    1.013    1.113    1.135    1.141    1.139    1.140    1.141    1.118    1.093    1.071    1.061    1.113    1.160    1.151    1.087    1.035    1.043    1.060    0.997    0.941    0.909    0.861    0.839    0.856    0.896    0.941    0.977    1.024    1.041    1.051    1.077    1.039    1.000    0.975    0.976    1.048    1.120    1.129    1.086    1.051    1.084    1.117
;

* Normalize demand variation to average at one:
ELEC_DemandVariation(week, hour) = ELEC_DemandVariation(week, hour) / (sum((weekk,hourr), ELEC_DemandVariation(weekk, hourr))/(card(week)*card(hour)))


* NOTE: the equation EQ_ELEC_VRE_Gen takes into account the osemosys availability factor and its change over time
table ELEC_VRE_availability(week, ELEC_VRE_type, hour)
             t001     t002     t003     t004     t005     t006     t007     t008     t009     t010     t011     t012     t013     t014     t015     t016     t017     t018     t019     t020     t021     t022     t023     t024     t025     t026     t027     t028     t029     t030     t031     t032     t033     t034     t035     t036     t037     t038     t039     t040     t041     t042     t043     t044     t045     t046     t047     t048     t049     t050     t051     t052     t053     t054     t055     t056     t057     t058     t059     t060     t061     t062     t063     t064     t065     t066     t067     t068     t069     t070     t071     t072     t073     t074     t075     t076     t077     t078     t079     t080     t081     t082     t083     t084     t085     t086     t087     t088     t089     t090     t091     t092     t093     t094     t095     t096     t097     t098     t099     t100     t101     t102     t103     t104     t105     t106     t107     t108     t109     t110     t111     t112     t113     t114     t115     t116     t117     t118     t119     t120     t121     t122     t123     t124     t125     t126     t127     t128     t129     t130     t131     t132     t133     t134     t135     t136     t137     t138     t139     t140     t141     t142     t143     t144     t145     t146     t147     t148     t149     t150     t151     t152     t153     t154     t155     t156     t157     t158     t159     t160     t161     t162     t163     t164     t165     t166     t167     t168
w06.solar    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.020    0.075    0.146    0.181    0.208    0.203    0.169    0.126    0.068    0.019    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.033    0.127    0.241    0.320    0.364    0.359    0.301    0.203    0.095    0.024    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.026    0.098    0.192    0.253    0.280    0.287    0.250    0.170    0.091    0.024    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.032    0.115    0.222    0.273    0.306    0.291    0.258    0.194    0.112    0.034    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.039    0.138    0.255    0.333    0.381    0.384    0.336    0.258    0.145    0.042    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.039    0.139    0.261    0.353    0.405    0.401    0.323    0.232    0.124    0.033    0.008    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.039    0.123    0.213    0.256    0.278    0.278    0.244    0.175    0.089    0.024    0.008    0.000    0.000    0.000    0.000    0.000
w18.solar    0.000    0.000    0.000    0.000    0.000    0.009    0.042    0.132    0.263    0.357    0.390    0.418    0.415    0.395    0.335    0.281    0.225    0.160    0.076    0.023    0.008    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.008    0.040    0.139    0.284    0.433    0.535    0.573    0.559    0.543    0.510    0.436    0.333    0.201    0.087    0.022    0.008    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.009    0.039    0.110    0.201    0.299    0.367    0.381    0.384    0.390    0.386    0.373    0.316    0.214    0.101    0.030    0.010    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.011    0.043    0.126    0.256    0.366    0.471    0.517    0.522    0.484    0.430    0.390    0.335    0.227    0.108    0.030    0.010    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.012    0.041    0.128    0.251    0.361    0.437    0.489    0.512    0.532    0.514    0.462    0.354    0.239    0.114    0.032    0.008    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.010    0.047    0.146    0.270    0.384    0.472    0.503    0.511    0.511    0.487    0.393    0.297    0.189    0.086    0.025    0.008    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.008    0.032    0.086    0.169    0.258    0.321    0.374    0.418    0.436    0.417    0.400    0.339    0.234    0.113    0.030    0.008    0.000    0.000    0.000
w20.solar    0.000    0.000    0.000    0.000    0.000    0.017    0.055    0.156    0.308    0.447    0.554    0.606    0.614    0.598    0.578    0.526    0.419    0.289    0.142    0.044    0.013    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.019    0.068    0.191    0.358    0.510    0.616    0.675    0.698    0.690    0.643    0.550    0.440    0.283    0.132    0.040    0.010    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.015    0.064    0.182    0.344    0.497    0.606    0.674    0.697    0.678    0.639    0.551    0.438    0.293    0.140    0.043    0.010    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.016    0.067    0.194    0.361    0.502    0.602    0.630    0.622    0.600    0.527    0.429    0.315    0.191    0.089    0.029    0.010    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.013    0.040    0.103    0.189    0.273    0.341    0.371    0.377    0.364    0.338    0.301    0.249    0.173    0.086    0.031    0.010    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.014    0.057    0.162    0.308    0.431    0.505    0.533    0.562    0.553    0.526    0.470    0.383    0.266    0.135    0.043    0.012    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.018    0.072    0.197    0.345    0.463    0.527    0.542    0.564    0.567    0.556    0.498    0.408    0.290    0.147    0.048    0.012    0.000    0.000    0.000
w47.solar    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.029    0.128    0.277    0.376    0.414    0.404    0.343    0.223    0.085    0.019    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.030    0.118    0.227    0.306    0.358    0.361    0.315    0.198    0.069    0.013    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.031    0.130    0.259    0.346    0.389    0.382    0.319    0.205    0.074    0.013    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.028    0.132    0.288    0.404    0.457    0.439    0.361    0.227    0.078    0.013    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.021    0.089    0.190    0.281    0.329    0.319    0.261    0.167    0.060    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.016    0.056    0.110    0.154    0.170    0.168    0.139    0.084    0.033    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.000    0.015    0.064    0.160    0.235    0.278    0.314    0.287    0.183    0.064    0.000    0.000    0.000    0.000    0.000    0.000    0.000
w06.wind     0.203    0.206    0.220    0.216    0.220    0.226    0.220    0.224    0.270    0.328    0.322    0.307    0.314    0.296    0.273    0.256    0.251    0.244    0.239    0.254    0.287    0.319    0.324    0.311    0.305    0.309    0.299    0.288    0.287    0.271    0.247    0.235    0.206    0.169    0.143    0.127    0.121    0.128    0.137    0.141    0.143    0.147    0.148    0.149    0.157    0.169    0.169    0.183    0.188    0.192    0.197    0.195    0.194    0.203    0.205    0.211    0.208    0.198    0.185    0.178    0.189    0.207    0.201    0.196    0.165    0.137    0.126    0.120    0.119    0.124    0.124    0.134    0.141    0.149    0.148    0.150    0.155    0.157    0.159    0.159    0.159    0.157    0.147    0.151    0.157    0.158    0.161    0.154    0.154    0.160    0.164    0.168    0.164    0.163    0.165    0.155    0.142    0.131    0.126    0.122    0.119    0.115    0.117    0.121    0.117    0.108    0.093    0.090    0.089    0.093    0.101    0.105    0.108    0.112    0.121    0.129    0.133    0.136    0.135    0.133    0.130    0.133    0.129    0.128    0.126    0.124    0.123    0.121    0.116    0.114    0.113    0.112    0.114    0.114    0.108    0.115    0.128    0.132    0.136    0.138    0.133    0.125    0.125    0.128    0.118    0.112    0.105    0.098    0.094    0.096    0.096    0.101    0.100    0.093    0.087    0.086    0.089    0.090    0.090    0.091    0.093    0.094    0.094    0.099    0.106    0.114    0.123    0.128
w18.wind     0.363    0.383    0.390    0.387    0.386    0.397    0.403    0.366    0.338    0.365    0.404    0.432    0.479    0.494    0.480    0.464    0.438    0.390    0.425    0.413    0.373    0.340    0.310    0.327    0.334    0.354    0.390    0.385    0.393    0.411    0.414    0.407    0.415    0.423    0.429    0.438    0.436    0.399    0.354    0.302    0.263    0.230    0.192    0.171    0.173    0.173    0.159    0.139    0.118    0.110    0.094    0.086    0.082    0.077    0.073    0.069    0.069    0.074    0.071    0.071    0.075    0.084    0.102    0.119    0.132    0.123    0.110    0.098    0.095    0.091    0.080    0.071    0.062    0.059    0.053    0.047    0.043    0.044    0.042    0.040    0.036    0.035    0.040    0.042    0.043    0.045    0.053    0.063    0.071    0.065    0.064    0.063    0.066    0.073    0.076    0.075    0.077    0.077    0.081    0.081    0.078    0.074    0.076    0.068    0.064    0.065    0.069    0.077    0.081    0.092    0.101    0.111    0.123    0.122    0.120    0.115    0.125    0.138    0.148    0.161    0.169    0.182    0.176    0.185    0.185    0.181    0.189    0.173    0.176    0.198    0.215    0.232    0.248    0.245    0.237    0.236    0.241    0.232    0.249    0.274    0.345    0.385    0.392    0.374    0.344    0.310    0.287    0.274    0.263    0.258    0.256    0.239    0.214    0.209    0.223    0.233    0.230    0.220    0.214    0.213    0.229    0.243    0.250    0.244    0.235    0.231    0.236    0.234
w20.wind     0.155    0.163    0.149    0.141    0.142    0.155    0.152    0.127    0.123    0.137    0.140    0.131    0.129    0.136    0.147    0.134    0.133    0.117    0.093    0.069    0.058    0.057    0.059    0.060    0.058    0.066    0.078    0.091    0.102    0.115    0.127    0.116    0.090    0.080    0.081    0.081    0.076    0.069    0.067    0.064    0.063    0.059    0.053    0.052    0.062    0.079    0.098    0.109    0.115    0.120    0.125    0.125    0.126    0.121    0.109    0.082    0.059    0.051    0.050    0.051    0.050    0.048    0.045    0.041    0.038    0.037    0.036    0.038    0.048    0.058    0.066    0.074    0.076    0.079    0.082    0.079    0.084    0.092    0.101    0.087    0.067    0.062    0.069    0.090    0.121    0.142    0.154    0.154    0.158    0.166    0.163    0.172    0.162    0.167    0.161    0.129    0.104    0.087    0.081    0.081    0.079    0.075    0.070    0.063    0.064    0.073    0.086    0.104    0.112    0.113    0.123    0.167    0.207    0.247    0.257    0.277    0.317    0.329    0.323    0.310    0.289    0.255    0.230    0.202    0.179    0.162    0.145    0.134    0.137    0.148    0.156    0.164    0.163    0.155    0.164    0.167    0.184    0.193    0.178    0.166    0.138    0.123    0.130    0.136    0.129    0.119    0.112    0.110    0.117    0.112    0.098    0.079    0.078    0.088    0.099    0.110    0.113    0.114    0.118    0.110    0.100    0.091    0.080    0.067    0.060    0.060    0.059    0.058
w47.wind     0.249    0.252    0.252    0.255    0.249    0.219    0.191    0.172    0.151    0.132    0.110    0.099    0.095    0.094    0.095    0.098    0.090    0.086    0.087    0.088    0.083    0.080    0.078    0.079    0.083    0.094    0.104    0.120    0.130    0.145    0.158    0.167    0.182    0.194    0.207    0.226    0.246    0.264    0.278    0.279    0.305    0.341    0.366    0.384    0.392    0.386    0.367    0.351    0.349    0.329    0.317    0.307    0.300    0.293    0.273    0.262    0.263    0.250    0.230    0.223    0.214    0.213    0.202    0.189    0.186    0.195    0.209    0.221    0.243    0.259    0.261    0.261    0.272    0.283    0.300    0.311    0.313    0.319    0.328    0.348    0.358    0.342    0.322    0.312    0.311    0.314    0.332    0.376    0.448    0.516    0.579    0.595    0.610    0.621    0.627    0.625    0.635    0.663    0.673    0.676    0.679    0.679    0.671    0.667    0.643    0.625    0.603    0.586    0.570    0.544    0.493    0.414    0.362    0.331    0.325    0.316    0.308    0.307    0.316    0.336    0.349    0.351    0.370    0.419    0.408    0.368    0.350    0.339    0.317    0.276    0.243    0.207    0.162    0.131    0.112    0.104    0.104    0.113    0.121    0.124    0.122    0.114    0.112    0.110    0.106    0.110    0.115    0.120    0.121    0.137    0.164    0.193    0.206    0.231    0.262    0.305    0.318    0.326    0.345    0.313    0.254    0.236    0.228    0.233    0.257    0.274    0.278    0.276
;




