# SuCCESs Integrated Assessment Model

SuCCESs is a bottom-up Integrated Assessment Model (IAM) that represents energy production and use, materials production, land-use and climate globally. The primary use-case for SuCCESs is to calculate long-term scenarios of these systems until 2100, e.g. to find cost-effective strategies to reduce greenhouse gas emissions and reach specified climate targets globally.

The model is described in detail in the paper "SuCCESs – a global IAM for exploring the interactions between energy, materials, land-use and climate systems in long-term scenarios": https://gmd.copernicus.org/preprints/gmd-2024-196/

**Citation:** Tommi Ekholm, Nadine-Cyra Freistetter, Tuukka Mattlar, Theresa Schaber, Aapo Rautiainen: SuCCESs – a global IAM for exploring the interactions between energy, materials, land-use and climate systems in long-term scenarios. Geoscientific Model Development Discussions [preprint], https://doi.org/10.5194/gmd-2024-196, 2024.

## How to run SuCCESs
SuCCESs is implemented in GAMS and requires an optimization solver (preferably an LP solver, e.g. CPLEX or Gurobi) to run the model. We have also run the model successfully with an NLP solver, but solving the model takes more time with NLP solvers.
The model works straight out of the box by running SuCCESs.gms. Save the output to a GDX file by e.g. an argument ‘GDX = SuCCESs_results’. You can use the [SuCCESs toolbox](https://github.com/SuCCESsIAM/SuCCESsIAM-toolbox/) to visualize and analyze the scenario.
If you want to do modifications to the model (e.g. modify parameters, introduce new constraints), it is best to include all changes and additions through separate files, which can be read into GAMS in the ‘Scenario files’ section of SuCCESs.gms. This section contains already some scenario files, e.g. Scenario_15C_constraint.gms, which introduces a 1.5C limit for temperature increase for year 2100, which the model needs to satisfy.

**Note:** SuCCEss uses the GAMS option $ONMULTI, which allows multiple additions of set elements or data (e.g. the set of processes can be introduced in multiple files, instead of a single set declaration). This affects the behaviour of the GAMS code, so that all data entries are read first, and all other assignments (e.g. calculations with the data) are done only after that. This can produce seemingly unexpected results, as the result of a calculation can be affected by data entry that comes only after the calculation in the model code. It is best to give all input data so that it does not require further calculations in GAMS.

## Model structure
SuCCESs covers global energy use, materials production, land-use, greenhouse gas emissions of CO2, CH4 and N2O, and climate change. The representation of these systems is spread across the model files, which are read from the main file SuCCESs.gms. 
Main components are described below:

**Base model definitions:** Base.gms contains e.g. time period definitions, commodity listing (with descriptions and units) and the discount rate.

**Energy and materials production:** These are represented through conversion process descriptions, given by sector in Techs_xxxx.gms files.

**Land-use:** Represented with the CLASH model, which is in its own subfolder. CLASH_Connector.gms links SuCCESs and CLASH. CLASH_Core.gms contains the main model definitions and equations. Land-use variables are prefixed with “LU_”.

**Emissions:** Emissions.gms contains common emission factors (e.g. CO2 emission factors for each fossil fuel type). Process-specific emission factors are given in the process descriptions.

**Demand projections:** Demand.gms contains the projections for end-use demand the model needs to fulfill.

**Climate:** Climate.gms contains the climate module. Climate variables are prefixed with “CLIM_”.

## Main model variables
A list of main model variables, their descriptions and units, is provided below.

### Energy, material and emission flows
| Model variable | Description |
| ------------- | ------------- |
| `OutputAnnual` | Total commodity production per year by all processes at given year (unit depends on the commodity, e.g. Mt/year for materials or PJ/year for energy; see Base.gms for details) |
| `OutputAnnualByProcess` | Commodity production per year by each process at given year (unit depends on the commodity, e.g. Mt/year for materials or PJ/year for energy; see Base.gms for details)  |
| `InputAnnual` | Total commodity consumption per year by all processes at given year (unit depends on the commodity, e.g. Mt/year for materials or PJ/year for energy; see Base.gms for details) |
| `InputAnnualByProcess` | Commodity consumption per year by each process at given year (unit depends on the commodity, e.g. Mt/year for materials or PJ/year for energy; see Base.gms for details) |
| `EmissionAnnual` | Annual total net emissions by greenhouse gas (Mt/year). CO2 separated between fossil fuels & industry (CO2FFI), from managed lands and deforestation (CO2LU) and natural ecosystems (CO2nat). (Mt gas per year) |
| `EmissionAnnualByProcess` | Net emissions of greenhouse gases by each process (Mt gas per year) |


### Production processes
| Model variable | Description |
| ------------- | ------------- |
| ``ActivityAnnual`` | Annual operating activity of each process (unit depends on the process, e.g. Mt/year or PJ/year) |
| `CapacityTotal` | Total capacity of each process (unit depends on the process, e.g. Mt/year or PJ/year) |
| ``CapitalInvestment`` | Capital cost of new capacity installments (mln. $2020) |
| ``OperatingCost`` | Operating cost of each processes (mln. $2020) |

### Hourly electricity sub-model
| Model variable | Description |
| ------------- | ------------- |
| ``ELEC_Demand`` | Hourly electricity demand variations, modulated from the annual electricity demand for the representative weeks (PJ per hour) |
| ``ELEC_conventional_gen`` | Conventional (dispatchable) power generation (PJ per hour) |
| ``ELEC_renewable_gen`` | Hourly varying renewable electricity generation (PJ per hour) |

### Climate variables
| Model variable | Description |
| ------------- | ------------- |
| ``CLIM_DeltaT`` | Global mean temperature change from pre-industrial (degrees C) |
| ``CLIM_FORC_lin`` | Radiative forcing, linearized (W/m2) |
| ``CLIM_CO2conc`` | CO2 concentration in the atmosphere (ppm) |
| ``CLIM_CH4conc`` | CH4 concentration in the atmosphere (ppb) |
| ``CLIM_N2Oconc`` | N2O concentration in the atmosphere (ppb) |
| ``CLIM_CStock`` | Carbon stock in atmosphere, shallow, lower and deep oceans (GtC) |


### Land use
| Model variable | Description |
| ------------- | ------------- |
| ``LU_Area`` | Land area under different land-uses by land-pool (biome) (million km2) |
| ``LU_AreaByUse`` | Global area of land-use categories (million km2) |
| ``LU_AreaByPool`` | Global area of land-pools (biomes) (million km2) |
| ``LU_Area_SecdF`` | Area of secondary forest by age-class (million km2) |
| ``LU_NetCO2LandUse`` | Net CO2 emission from land-use, including managed lands and deforestation(Mt CO2 per year) |
| ``LU_NetCO2Terrestrial`` | Net CO2 flux from the terrestrial biosphere to the atmosphere (Mt CO2 per year) |
| ``LU_clear_pri`` | Cleared primary forest area (million km2)  |
| ``LU_clear_sec`` | Harvested secondary forest area by age-class (can be either replanted or repurposed)(million km2) |
| ``LU_regen_area`` | Area of planted secondary forest (afforested or regenerated after harvest) (million km2) |
| ``LU_harv_logs`` | Harvested logwood from primary and secondary forests for structural wood (million m3 per year) |
| ``LU_harv_pulp`` | Harvested pulpwood from primary and secondary forests for pulp production (million m3 per year) |
| ``LU_harv_wast`` | Harvested waste wood (small trunks) from primary and secondary forests for bioenergy (million m3 per year) |
| ``LU_harv_WoodResid`` | Harvested wood residues (branches, tree tops, etc.) from primary and secondary forests for bioenergy (Mt DM per year) |
| ``LU_harv_crops`` | Harvested crops (energy and food) (Mt DM per year)  |
| ``LU_harv_FoodCrops`` | Crops used as human food (Mt DM per year) |
| ``LU_harv_EnerCrops`` | Crops used for bioenergy (Mt DM per year) |
| ``LU_harv_CropResid`` | Harvested crop residues for bioenergy (Mt DM per year) |
| ``LU_emis_CropCH4`` | CH4 emissions from croplands (rice) (Mt CH4 per year)  |
| ``LU_emis_CropN2O`` | N2O emissions from croplands (Mt N2O per year)  |
| ``LVST_emissions_CH4`` | CH4 emissions from livestock enteric fermentation and manure management (Mt/year)  |
| ``LVST_emissions_N2O`` | N2O emissions from manure management (Mt/year) |
| ``LVST_headcount`` | Headcount of livestock by animal type (quantity) |
| ``LVST_product_output`` | Food production per animal type(Mt/year) |
| ``LVST_feed_intake`` | Human-produced feed required for livestock (Mt/year) |
| ``LU_CStockTotalVege`` | Total carbon stock of vegetation (GtC)  |
| ``LU_CStockTotalSoil`` | Total carbon stock of soil up to 1m (GtC)  |
| ``LU_CStockTotalLitt`` | Total carbon stock of litter (GtC) |
| ``LU_CStockVege`` | Carbon stock of vegetation by land-pool (biome) (GtC)  |
| ``LU_CStockLittHerb`` | Carbon stock of litter from herbaceous sources (GtC) |
| ``LU_CStockSoilHerb`` | Carbon stock of soil from herbaceous sources (GtC) |
| ``LU_CStockLittWoody`` | Carbon stock of litter from woody sources (GtC) |
| ``LU_CStockSoilWoody`` | Carbon stock of soil from woody sources (GtC)  |
