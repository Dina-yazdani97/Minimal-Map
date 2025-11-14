library(ggplot2)
library(rnaturalearth)
library(sf)
library(dplyr)
library(export)

world <- ne_countries(returnclass = "sf")
target_crs <- "+proj=laea +x_0=0 +y_0=0 +lon_0=-74 +lat_0=40"

world <- st_transform(world, crs = target_crs)
world
meridional_lines <- st_graticule(lat = seq(-80, 80, 15), 
                                 lon = seq(-180, 180, 20)) %>%
  st_transform(crs = target_crs)

americas <- world %>% filter(continent %in% c("North America", "South America"))

map <- ggplot() +
  geom_sf(data = world, fill = "#d9d9d9", color = "#8B0000", linewidth = 0.3) +
  geom_sf(data = americas, fill = "#00F5FF", color = "#8B0000", linewidth = 0.3) +
  geom_sf(data = meridional_lines, color = "black", alpha = 10.5, linewidth = 0.2) +
  coord_sf(crs = target_crs) +
  theme_void()


graph2jpg(map, "map.jpg", dpi = 300, width = 10, height =8)
