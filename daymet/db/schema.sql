CREATE SCHEMA IF NOT EXISTS data;

DROP TABLE IF EXISTS data.daymet_import;
CREATE TABLE data.daymet_import (
  featureid BIGINT,
  year INT,
  date DATE,
  tmax REAL,
  tmin REAL,
  prcp REAL,
  dayl REAL,
  srad REAL,
  vp REAL,
  swe REAL
);

CREATE TABLE data.daymet (
  featureid BIGINT,
  year INT,
  tmax REAL[],
  tmin REAL[],
  prcp REAL[],
  dayl REAL[],
  srad REAL[],
  vp REAL[],
  swe REAL[]
);

CREATE UNIQUE INDEX daymet_featureid_year_idx ON data.daymet(featureid, year);

