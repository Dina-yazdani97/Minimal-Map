library(ggplot2)
library(rnaturalearth)
library(sf)
library(dplyr)
library(export)
library(terra)
library(RColorBrewer)

data_nc <- rast("cru_tmp.nc")
tmp_var <- data_nc[["tmp"]]

target_crs <- "+proj=laea +x_0=0 +y_0=0 +lon_0=-74 +lat_0=40"
tmp_projected <- project(tmp_var, target_crs)


tmp_df <- as.data.frame(tmp_projected, xy = TRUE)
names(tmp_df) <- c("x", "y", "tmp")
tmp_df <- na.omit(tmp_df)

world <- ne_countries(returnclass = "sf")
world <- st_transform(world, crs = target_crs)

meridional_lines <- st_graticule(lat = seq(-80, 80, 15), 
                                 lon = seq(-180, 180, 20)) %>%
  st_transform(crs = target_crs)

americas <- world %>% filter(continent %in% c("North America", "South America"))
color_palette <- brewer.pal(9, "RdYlBu")

map <- ggplot() +
  geom_tile(data = tmp_df, aes(x = x, y = y, fill = tmp)) +
  scale_fill_gradientn(colors = rev(color_palette), name = "Mean Temperature(°C)\n(2011-2020)") +
  geom_sf(data = world, fill = NA, color = "black", linewidth = 0.3) +
  geom_sf(data = americas, fill = NA, color = "navy", linewidth = 0.4) +
  geom_sf(data = meridional_lines, color = "black", alpha = 0.5, linewidth = 0.3) +
  coord_sf(crs = target_crs) +
  theme_void()

graph2jpg(map, "map_with_tmp.jpg", dpi = 300, width = 10, height = 8)