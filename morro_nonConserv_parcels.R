library(dplyr)
library(tidyverse)
library(here)
library(janitor)
library(sf)
library(raster)
library(rgdal)


# read in csv files
morro_non <- read_csv("morro_non_conserv_pub_parcels.csv") %>% 
  clean_names()

morro_non_id <- morro_non %>% 
  select(id)
  
# read in shapefile

morro_parcels <- read_sf(dsn = "shapes",
                         layer = "MorroBay_parcels")

# merge it with the non_conserv parcels csv to get rid of the conserv and public parcels
id_merge <- merge(morro_parcels, morro_non, by = "id")

#select out all the extra unnecessary columns
morro_non_parcels <- id_merge %>% 
  dplyr::select(id, AREA, APN, APN2, LUC, FID_riverb, Acres)


# make it a spatial polygons data frame
morro_spatial <- as_Spatial(morro_non_parcels)

#and save it and go play with it in ArcMap and Marxan!
writeOGR(morro_spatial, ".", "MorroBay_non_conserv_parcels", driver="ESRI Shapefile")
