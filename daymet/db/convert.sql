-- convert daymet from daily to annual array format and insert into daymet table

INSERT INTO daymet
  SELECT
    featureid,
    year,
    array_agg(tmax ORDER BY date) as tmax,
    array_agg(tmin ORDER BY date) as tmin,
    array_agg(prcp ORDER BY date) as prcp,
    array_agg(dayl ORDER BY date) as dayl,
    array_agg(srad ORDER BY date) as srad,
    array_agg(vp ORDER BY date) as vp,
    array_agg(swe ORDER BY date) as swe
  FROM daymet_import
  GROUP BY featureid, year;
