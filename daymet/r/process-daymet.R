#!/usr/bin/env Rscript
# Process Daymet data
# Extracts data from NetCDF files, intersects with catchments, and saves to sqlite3 database for specified years
# usage: Rscript process-daymet.R --dir_nc4 </path/to/nc4> --dir_shp </path/to/shapefiles> --dir_db <path/to/output-db> --year <year>

library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(lubridate)
library(janitor)
library(glue)
library(optparse)
library(sf)
library(exactextractr)

pt <- proc.time()

if (interactive()) {
  opt <- list(
    year = 2020,
    dir_shp = "/mnt/data/sheds/gis/NHDHRDV2/catchments",
    dir_db = "/mnt/data/sheds/daymet/db/2020",
    dir_nc4 = "/mnt/data/sheds/daymet/nc4"
  )
} else {
  option_list <- list(
    make_option("--dir_nc4", type="character", help="Path to directory Daymet NetCDF files"),
    make_option("--dir_shp", type="character", help="Path to directory of catchment shapefiles"),
    make_option("--dir_db", type="character", help="Path to director for saving output database"),
    make_option("--year", type="integer", help="Year")
  )
  
  opt <- parse_args(OptionParser(option_list=option_list))
  
  if (is.null(opt$dir_nc4)) {
    stop("NetCDF directory (--dir_nc4) is required")
  }
  
  if (!file.exists(opt$dir_nc4)) {
    stop(glue("Cannot find NetCDF directory (--dir_nc4): {opt$dir_nc4}"))
  }
  
  if (is.null(opt$dir_shp)) {
    stop("Catchment shapefiles directory (--dir_shp) is required")
  }
  
  if (!file.exists(opt$dir_shp)) {
    stop(glue("Cannot find catchment shapefiles directory (--dir_shp): {opt$dir_shp}"))
  }
  
  if (is.null(opt$dir_db)) {
    stop("Output database directory (--dir_db) is required")
  }
  
  if (!file.exists(opt$dir_db)) {
    stop(glue("Cannot find output database directory (--dir_db): {opt$dir_db}"))
  }
  
  if (is.null(opt$year)) {
    stop("Year (--year) is required")
  }
}

extract_daymet_param <- function (x, yr, param) {
  cat(glue("extracting daymet: {yr} {param}"), "\n")

  daymet_filename <- glue("daymet_v4_daily_na_{param}_{yr}.nc")
  daymet_layer <- raster::stack(file.path(opt$dir_nc4, daymet_filename))
  x_bbox_buffer <- st_buffer(st_as_sfc(st_bbox(x)), 1000)
  daymet_crop <- raster::crop(daymet_layer, as(x_bbox_buffer, "Spatial"))

  daymet_extract <- exact_extract(
    daymet_crop,
    x,
    "mean",
    append_cols = c("FEATUREID")
  )
  
  names(daymet_extract) <- stringr::str_replace_all(names(daymet_extract), "\\.", "-")

  daymet_extract %>%
    pivot_longer(-c("FEATUREID"), names_to = "Date", names_prefix = "mean-X") %>%
    arrange(FEATUREID, Date)
}

for (region in 1:6) {
  cat(glue("processing region: {region}"), "\n")
  
  file_shp <- file.path(opt$dir_shp, paste0("Catchments0", region, "_Daymet.shp"))
  file_db <- file.path(opt$dir_db, paste0("sheds_daymet_0", region, ".db"))
  
  cat(glue("loading shapefile: {file_shp}"), "\n")
  shp <- st_read(file_shp)
  shp_proj <- st_transform(shp, crs = st_crs("+proj=lcc +lon_0=-100 +lat_0=42.5 +x_0=0 +y_0=0 +a=6378137 +rf=298.257223563 +lat_1=25 +lat_2=60"))
  shp_proj$FEATUREID <- as.integer(shp_proj$FEATUREID)
  
  # shp_proj <- head(shp_proj)

  x_tmax <- extract_daymet_param(shp_proj, opt$year, "tmax")
  x_tmin <- extract_daymet_param(shp_proj, opt$year, "tmin")
  x_prcp <- extract_daymet_param(shp_proj, opt$year, "prcp")
  #x_dayl <- extract_daymet_param(shp_proj, opt$year, "dayl")
  #x_srad <- extract_daymet_param(shp_proj, opt$year, "srad")
  #x_vp <- extract_daymet_param(shp_proj, opt$year, "vp")
  #x_swe <- extract_daymet_param(shp_proj, opt$year, "swe")

  cat("merging variables\n")
  x <- tibble(
    FEATUREID = x_tmax[["FEATUREID"]],
    Date = x_tmax[["Date"]],
    tmax = x_tmax[["value"]],
    tmin = x_tmin[["value"]],
    prcp = x_prcp[["value"]],
    #dayl = x_dayl[["value"]],
    #srad = x_srad[["value"]],
    #vp = x_vp[["value"]],
    #swe = x_swe[["value"]]
    dayl = NA_real_,
    srad = NA_real_,
    vp = NA_real_,
    swe = NA_real_
  )

  if (file.exists(file_db)) {
    cat(glue("deleting existing db: {file_db}"), "\n")
    unlink(file_db)
  }

  db <- DBI::dbConnect(RSQLite::SQLite(), file_db)
  
  cat(glue("inserting to db: {file_db}"), "\n")
  DBI::dbWriteTable(db, "climateRecord", x, append = TRUE)

  DBI::dbDisconnect(db)
  gc()
}

elapsed_minutes <- (proc.time() - pt)[[3]] / 60
cat(glue("done: {sprintf('%.1f', elapsed_minutes)} minutes"), "\n")
