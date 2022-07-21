-- Extract all daymet data for set of featureids in daily-row format
-- examples: select * from get_daymet_featureids('{201407707}');
--           select * from get_daymet_featureids('{201407707,201407708}');
CREATE OR REPLACE FUNCTION get_daymet_featureids(featureid int[])
RETURNS TABLE (
  featureid bigint,
  date date,
  tmax real,
  tmin real,
  prcp real,
  dayl real,
  srad real,
  vp real,
  swe real
) AS $$
WITH t1 AS (
  SELECT featureid,
         year,
         unnest(tmax) AS tmax,
         unnest(tmin) AS tmin,
         unnest(prcp) AS prcp,
         unnest(dayl) AS dayl,
         unnest(srad) AS srad,
         unnest(vp) AS vp,
         unnest(swe) AS swe
  FROM daymet
  WHERE featureid = ANY($1)
), t2 AS (
  SELECT
    featureid,
    (DATE (year || '-01-01')) + ((row_number() OVER (PARTITION BY featureid, year)) - 1)::integer AS date,
    tmax, tmin, prcp, dayl, srad, vp, swe
  FROM t1
)
SELECT *
FROM t2
ORDER BY featureid, date;
$$ LANGUAGE 'sql';

-- Extract daymet data between date range for set of featureids in daily-row format
-- examples: select * from get_daymet_featureids_date_range('{201407707}', '2015-01-01', '2015-02-28');
--           select * from get_daymet_featureids_date_range('{201407707, 201407708}', '2015-01-01', '2015-02-28');
CREATE OR REPLACE FUNCTION get_daymet_featureids_date_range(featureid int[], start_date date, end_date date)
RETURNS TABLE (
  featureid bigint,
  date date,
  tmax real,
  tmin real,
  prcp real,
  dayl real,
  srad real,
  vp real,
  swe real
) AS $$
WITH t1 AS (
  SELECT featureid, year,
         unnest(tmax) AS tmax,
         unnest(tmin) AS tmin,
         unnest(prcp) AS prcp,
         unnest(dayl) AS dayl,
         unnest(srad) AS srad,
         unnest(vp) AS vp,
         unnest(swe) AS swe
  FROM daymet
  WHERE featureid = ANY($1) AND
        year >= date_part('year', $2) AND
        year <= date_part('year', $3)
), t2 AS (
  SELECT featureid,
         (DATE (year || '-01-01')) + ((row_number() OVER (PARTITION BY featureid, year)) - 1)::integer AS date,
         tmax, tmin, prcp, dayl, srad, vp, swe
  FROM t1
)
SELECT *
FROM t2
WHERE date >= $2 AND date <= $3
ORDER BY featureid, date;
$$ LANGUAGE 'sql';


-- Extract all daymet data for set of featureids in daily-row format
-- examples: select * from get_daymet_featureids('{201407707}');
--           select * from get_daymet_featureids('{201407707,201407708}');
CREATE OR REPLACE FUNCTION get_daymet_featureids_bigint(featureid bigint[])
RETURNS TABLE (
  featureid bigint,
  date date,
  tmax real,
  tmin real,
  prcp real,
  dayl real,
  srad real,
  vp real,
  swe real
) AS $$
WITH t1 AS (
  SELECT featureid,
         year,
         unnest(tmax) AS tmax,
         unnest(tmin) AS tmin,
         unnest(prcp) AS prcp,
         unnest(dayl) AS dayl,
         unnest(srad) AS srad,
         unnest(vp) AS vp,
         unnest(swe) AS swe
  FROM daymet
  WHERE featureid = ANY($1)
), t2 AS (
  SELECT
    featureid,
    (DATE (year || '-01-01')) + ((row_number() OVER (PARTITION BY featureid, year)) - 1)::integer AS date,
    tmax, tmin, prcp, dayl, srad, vp, swe
  FROM t1
)
SELECT *
FROM t2
ORDER BY featureid, date;
$$ LANGUAGE 'sql';

-- Extract daymet data between date range for set of featureids in daily-row format
-- examples: select * from get_daymet_featureids_date_range('{201407707}', '2015-01-01', '2015-02-28');
--           select * from get_daymet_featureids_date_range('{201407707, 201407708}', '2015-01-01', '2015-02-28');
CREATE OR REPLACE FUNCTION get_daymet_featureids_date_range_bigint(featureid bigint[], start_date date, end_date date)
RETURNS TABLE (
  featureid bigint,
  date date,
  tmax real,
  tmin real,
  prcp real,
  dayl real,
  srad real,
  vp real,
  swe real
) AS $$
WITH t1 AS (
  SELECT featureid, year,
         unnest(tmax) AS tmax,
         unnest(tmin) AS tmin,
         unnest(prcp) AS prcp,
         unnest(dayl) AS dayl,
         unnest(srad) AS srad,
         unnest(vp) AS vp,
         unnest(swe) AS swe
  FROM daymet
  WHERE featureid = ANY($1) AND
        year >= date_part('year', $2) AND
        year <= date_part('year', $3)
), t2 AS (
  SELECT featureid,
         (DATE (year || '-01-01')) + ((row_number() OVER (PARTITION BY featureid, year)) - 1)::integer AS date,
         tmax, tmin, prcp, dayl, srad, vp, swe
  FROM t1
)
SELECT *
FROM t2
WHERE date >= $2 AND date <= $3
ORDER BY featureid, date;
$$ LANGUAGE 'sql';
