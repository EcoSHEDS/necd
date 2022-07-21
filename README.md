EcoSHEDS Northeast Catchment Delineation (NECD)
===============================================

Documentation: https://ecosheds.github.io/necd

This repo contains code for generating the EcoSHEDS Northeast Catchment Delineation (NECD) and associated datasets and GIS layers.

The NECD is a high resolution catchment delineation of the northeast U.S. It was created in 2015 by Kyle O'Neil to support the EcoSHEDS northeast stream temperature and brook trout occupancy models.

The NECD dataset was formerly called the National Hydrography Dataset High Resolution Delineation Version 2 (NHDHRDV2). It has been renamed to avoid confusion with the [USGS NHDPlus High Resolution (HR)](https://www.usgs.gov/national-hydrography/nhdplus-high-resolution) dataset, which was not yet available when this dataset was originally created.

## Data Products

### Catchment Delineation

The `delineation/` folder contains python and R scripts for performing the high resolution catchment delineation from a digital elevation model (DEM) of the northeast region. Outputs from these scrips include shapefiles containing the flowlines, riparian buffers, catchment polygons, and a dataset of basic catchment characteristics (e.g., total flow line length,catchment area).

Documentation for the NECD dataset can be found in `delineation/EcoSHEDS NECD Catchment Delineation Documentation.docx`.

### Basin Characteristics

The `covariates/` folder contains python and R scripts for computing basin characteristics of the catchment delineation. These characteristics include a number of metrics representing land use cover, impounded area, climate, etc.

Tables listing all available metrics and the associated data sources can be found in `covariates/EcoSHEDS NECD Covariates Documentation.xlsx`.

### Daymet

The `daymet/` folder contains scripts for generating daily timeseries of air temperature and precipitation for each catchment based on [Daymet](https://daymet.ornl.gov/). These timeseries are used as inputs for the stream temperature model.

See `daymet/README.md` for more details.

### Impoundment Influence Zones

The `impoundments/` folder contains scripts for creating a spatial layer indicating the zones of impoundment influence. This layer is used to identify stream temperature monitoring locations that are likely to be influenced by upstream impoundments.

See `impoundments/README.md` for more details.

### Tidal Influence

The `tidal/` folder contains scripts for generating a spatial layer of tidal influence zones. This layer is used to identify stream temperature monitoring locations influenced by tidal exchanges.

See `tidal/README.md` for more details.

## License

See `LICENSE` file.