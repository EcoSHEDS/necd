#!/bin/bash
# stream climateRecord table from sqlite file to stdout
# usage: ./sqlite_export_csv.sh <sqlite file>
# example: ./sqlite_export_csv.sh /path/to/NHDHRDV2_01

SQLITE_FILE=$1

sqlite3 $SQLITE_FILE <<!
.mode csv
.output stdout
select featureid, strftime('%Y', date) as year, date, tmax, tmin, prcp, dayl, srad, vp, swe from climateRecord;
!
