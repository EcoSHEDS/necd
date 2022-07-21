#!/bin/bash
# Imports daymet dataset from single sqlite3 database to daymet_import table,
# and then runs convert.sql to append dataset to daymet table as vectors
#
# usage: ./import_sqlite.sh <db_name> <sqlite file>
# example: ./import_sqlite.sh sheds /path/to/NHDHRDV1_01

set -eu

DBNAME=$1
SQLITE_FILE=$2

echo Truncating daymet_import
psql -d $DBNAME -c "TRUNCATE TABLE daymet_import;" -v ON_ERROR_STOP=1 --single-transaction

echo
echo Dropping index on daymet_import
psql -d $DBNAME -c "DROP INDEX IF EXISTS daymet_import_featureid_year_idx;"

echo
echo Importing $SQLITE_FILE into daymet_import...
./sqlite_export_csv.sh $SQLITE_FILE | psql -d $DBNAME -c "COPY daymet_import FROM STDIN WITH CSV" -v ON_ERROR_STOP=1 --single-transaction

echo
echo Adding index to daymet_import
psql -d $DBNAME -c "CREATE INDEX daymet_import_featureid_year_idx ON daymet_import (featureid, year);"

echo
echo Moving from daymet_import to daymet
psql -d $DBNAME -f convert.sql


