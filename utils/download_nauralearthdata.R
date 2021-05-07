library(rnaturalearth)
library(sf)

cr <- ne_countries(scale = 10, type = "countries", continent = "Europe", returnclass = c("sf"),
             country = c("Ukraine","Bulgaria", "Hungary", "Republic of Serbia", "Moldova", "Slovakia"), geounit = NULL, sovereignty = NULL
            )

plot(st_geometry(cr))
sort(cr$sovereignt)


write_sf(cr, "www/data/shp/countries.shp")


ro <- ne_download(scale = "large" , type = 'admin_1_states_provinces', category = 'cultural', returnclass = "sf")


ro2 <- ro %>% filter(admin == "Romania")
st_write(ro2, "www/data/shp/counties.shp")
plot(st_geometry(ro2))

library(raster)

pol <- extent(c(25,33, 43,50)) %>% as( 'SpatialPolygons') %>% st_as_sf()
st_crs(pol) <- st_crs(oc)
oc <-  ne_download(scale = "large" , type = 'ocean_scale_rank', category = 'physical', returnclass = "sf")

oc.ro <- st_crop(oc, pol)
plot(oc.ro)
st_write(oc.ro, "www/data/shp/sea.shp")
