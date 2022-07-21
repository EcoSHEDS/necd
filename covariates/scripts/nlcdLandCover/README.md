Land Cover Categories
=====================

This script produces the categorical rasters for specified land use types based 
on the National Land Cover Dataset. In each raster, a value of 1 represents the 
presence the specified land cover classification and a 0 represents the absence.


## Data Sources
| Layer           | Source                                              |
|:-----:          | ------                                              |
| Land Use Raster | [National Land Cover Dataset](http://www.mrlc.gov/) |
| Catchments      | Conte Ecology Group - NHDHRDV2                      |

## Steps to Run:

The folder structure is set up within the scripts. In general, the existing 
structure in the repo should be followed. Raw data should be unzipped, but 
otherwise kept in the same format as it is downloaded.

1. Open the script `nlcdLandCover.py`

2. Change the values in the "Specify inputs" section of the script
 - `baseDirectory` is the path to the `\nlcdLandCover` folder
 - `catchmentsFilePath` is the file path to the catchments polygons shapefile 
 (See "Notes" section)
 - `rasterFilePath` is the file path to the raw NLCD Land Use raster (`.img` 
 format)
 - `reclassTable` is the file path to the table used to reclassify the raw 
 raster into individual categorical rasters. (See current version in the 
 `\nlcdLandCover` folder)
    1. A value of 1 means to include this class
    2. A value of 0 means to exclude this class
    3. A value of -9999 means this class will be converted to NA 
    4. Reclassification Table Example: 

| Class                        | Value  | forest | developed | devel_opn |
| -----                        | -----  | ------ | --------- | --------- |
| Open Water                   |  11    |	0      | 0         | 0         |
| Perennial Ice/Snow           |	12    |	0	     | 0         | 0         |
| Developed, Open Space        |	21    |	0      | 1         | 1         |
| Developed, Low Intensity     |	22    |	0      | 1         | 0         |
| Developed, Medium Intensity  |	23    |	0      | 1         | 0         |
| Developed, High Intensity    |	24    |	0      | 1         | 0         |
| Barren Land (Rock/Sand/Clay) |	31    |	0      | 0         | 0         |

 - `outputName` is the name that will be associated with this particular run 
 of the tool (e.g. `NHDHRDV2` for all High Resolution Catchments)
 - `keepFiles` specifies whether or not to keep the intermediate GIS files. 
 Enter "NO" to delete or "YES" to keep.
 
3. Run the script in ArcPython. It does the following:
 - Sets up the folder structure in the specified directory
 - Generates the processing boundary from the specified shapefile and clips 
 the source raster to this spatial range
 - Creates the individual categorical rasters based on the reclassification 
 table
 - Saves the completed rasters to the 
 `[baseDirectory]\gisFiles\[outputName]\outputFiles` directory

## Output Rasters

The number of rasters generated by this script will be equal to the number of 
columns (beyond the first 2) specified in the reclassification table. The 
rasters will receive the same name as the column name. Be sure to adhere to 
[ArcGIS field name restrictions](http://resources.arcgis.com/en/help/main/10.2/index.html#/Fundamentals_of_adding_and_deleting_fields/005s0000000t000000/) as well as the 13 character limit 
on ArcGrid file names. Currently, the created rasters are:

#### Percent Forest
*Raster name:* forest <br>
*Description:* This layer represents the NLCD land cover defined as forested 
(where "Land_Cover" = "Deciduous Forest", "Evergreen Forest", "Mixed Forest", 
"Woody Wetlands", "Palustrine Forested Wetland", or "Estuarine Forested 
Wetland").

#### Percent Developed
*Raster name:* developed <br>
*Description:* This layer represents the NLCD land cover defined as developed 
(where "Land_Cover" = "Developed, Open Space", "Developed, Low Intensity", 
"Developed, Medium Intensity", "Developed, High Intensity", "Unconsolidated 
Shore/Quarries/Gravel Pits/Strip Mines", or "Urban/Recreational Grasses").

#### Percent Developed, High Intensity
*Raster name:* devel_hi <br>
*Description:* This layer represents the NLCD land cover defined as high 
intensity development (where "Land_Cover" = "Developed, High Intensity").

#### Percent Developed, Medium Intensity
*Raster name:* devel_med <br>
*Description:* This layer represents the NLCD land cover defined as medium 
intensity development (where "Land_Cover" = "Developed, Medium Intensity").

#### Percent Developed, Low Intensity
*Raster name:* devel_low <br>
*Description:* This layer represents the NLCD land cover defined as low intensity 
development (where "Land_Cover" = "Developed, Low Intensity").

#### Percent Developed, Open
*Raster name:* devel_opn <br>
*Description:* This layer represents the NLCD land cover defined as developed 
land that is open space (where "Land_Cover" = "Developed, Open Space").

#### Percent Deciduous Forest
*Raster name:* forest_decid <br>
*Description:* This layer represents the NLCD land cover defined as deciduous 
forest (where "Land_Cover" = "Deciduous Forest").

#### Percent Evergreen Forest
*Raster name:* forest_evgrn <br>
*Description:* This layer represents the NLCD land cover defined as evergreen 
forest (where "Land_Cover" = "Evergreen Forest").

#### Percent Mixed Forest
*Raster name:* forest_mixed <br>
*Description:* This layer represents the NLCD land cover defined as mixed forest, 
not defined in the previous two layers (where "Land_Cover" = "Mixed Forest", 
"Woody Wetlands", "Palustrine Forested Wetland", or "Estuarine Forested 
Wetland").

#### Percent Wetland
*Raster name:* wetland <br>
*Description:* This layer represents the NLCD land cover defined as wetlands 
(where "Land_Cover" = "Woody Wetlands", "Palustrine Forested Wetland", 
"Palustrine Scrub/Shrub Wetland", "Estuarine Forested Wetland", "Estuarine 
Scrub/Shrub Wetland", "Emergent Herbaceous Wetlands", "Palustrine Emergent
Wetland (Persistent)", "Estuarine Emergent Wetland", "Palustrine Aquatic 
Bed", or "Estuarine Aquatic Bed").

#### Percent Open Water
*Raster name:* wetland <br>
*Description:* This layer represents the NLCD land cover defined as open water 
(where "Land_Cover" = "Open Water").

#### Percent Herbaceous
*Raster name:* herbaceous <br>
*Description:* This layer represents the NLCD land cover defined as herbaceous 
(where "Land_Cover" = "Transitional", "Dwarf Scrub", "Shrub/Scrub", 
"Grassland/Herbaceous", "Sedge/Herbaceous", "Lichens", "Moss", 
"Urban/Recereational Grasses", "Palustrine Scrub/Shrub Wetland", "Estuarine 
Scrub/Shrub Wetland", "Emergent Herbaceous Wetlands", "Palustrine Emergent 
Wetland (Persistent)", or "Estuarine Emergent Wetland").

#### Percent Agriculture
*Raster name:* agriculture <br>
*Description:* This layer represents the NLCD land cover defined as agricultural 
land (where "Land_Cover" = "Orchards/Vineyards", "Pasture/Hay", "Cultivated 
Crops - row crops", "Cultivated Crops - small grains", or "Fallow").

#### Percent Undeveloped Forest
*Raster name:* undev_forest <br>
*Description:* This layer represents the NLCD land cover defined as land that is 
forested. (where "Land_Cover" = "Deciduous Forest", "Evergreen Forest", "Mixed 
Forest", "Woody Wetlands", "Palustrine Forested Wetland", "Estuarine Forested 
Wetland"). Additionally, land defined as being developed (where "Land_Cover" = 
"Developed, Open Space", "Developed, Low Intensity", "Developed, Medium 
Intensity", "Developed, High Intensity", "Barren Land (Rock/Sand/Clay)", and 
"Unconsolidated Shore/Quarries/Gravel Pits/Strip Mines") is removed from the 
layer and counted as NA.


## Notes

- Typically, the `catchmentsFilePath` variable specifies a shapefile of 
hydrologic catchments defining the range over which the "Zonal Statistics" tool 
will be applied. It is possible to enter another polygon shapefile, such as 
state or town boundaries, as this variable. The primary purpose of this layer is 
to trim the original raster, which represents the continental US, to a manageable 
size.

## Next Steps
- Classification definitions can be changed by editing the `reclassTable.csv` 
file.