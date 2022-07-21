#!/bin/bash
# Download Daymet NetCDF files for all variables and a single year
# usage: ./download-daymet-year.sh <year> </path/to/output/dir>
# example: ./download-daymet-year.sh 2015 ../data/nc4

set -eu

YEAR=$1
DIR=$2

BASE_URL=https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1840

VARS="tmax tmin prcp dayl srad vp swe"

for VAR in $VARS; do
  URL=$BASE_URL/daymet_v4_daily_na_"$VAR"_"$YEAR".nc
  FILENAME=$(basename $URL)
  FILEPATH="$DIR"/"$FILENAME"
  if [ -f $FILEPATH ]; then
    echo $FILEPATH already exists, skipping
  else
    echo Downloading $FILEPATH....
    wget -P $DIR $URL
  fi
done
