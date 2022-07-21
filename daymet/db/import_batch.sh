#!/bin/bash
# Import multiple daymet sqlite databases to postgresql as a batch
# usage: ./import_batch.sh <dbname> <list file> ...
#   <dbname>    database name
#   <list file> text file listing daymet sqlite files line by line
#   example list file:
#     /path/to/daymet/1980-2014/NHDHRDV2_01
#     /path/to/daymet/1980-2014/NHDHRDV2_02
#     /path/to/daymet/1980-2014/NHDHRDV2_03

set -eu

DBNAME=$1
LISTFILE=$2

while read -r SQLITE_FILE; do
  echo
  echo --------------------------------------------
  echo Importing $SQLITE_FILE...
  echo
  if [ ! -f $SQLITE_FILE ]; then
    echo Cannot find $SQLITE_FILE, skipping...
  else
    ./import_sqlite.sh $DBNAME $SQLITE_FILE
  fi
done < $LISTFILE

echo
echo Cleaning up...
psql -d $DBNAME -c "VACUUM ANALYZE;"
