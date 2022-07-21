#!/bin/bash
# Project all catchment shapefiles to Daymet projection
# usage: ./project-catchments.sh </path/to/shapefiles>

set -eu

DIR=$1

for ID in {1..6}; do
  echo Re-projecting Catchments0"$ID".shp to Catchments0"$ID"_Daymet.shp
  ogr2ogr -t_srs "+proj=lcc +lat_1=25 +lat_2=60 +lat_0=42.5 +lon_0=-100 +x_0=0 +y_0=0 +ellps=WGS84 +units=m +no_defs" "$DIR"/Catchments0"$ID"_Daymet.shp "$DIR"/Catchments0"$ID".shp
done;

