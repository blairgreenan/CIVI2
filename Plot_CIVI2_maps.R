
# Install once (uncomment if you don't have these)
# install.packages(c("readr", "dplyr", "leaflet"))

library(readr)
library(dplyr)
library(leaflet)
library(htmlwidgets)
library(RColorBrewer)

# Path to your CSV file
csv_path <- "../CIVI 5.csv"

# Read the CSV; adjust delimiter/encoding if needed
df <- read_csv(csv_path, show_col_types = FALSE)

# --- Update these to match your column names ---
lat_col   <- "Lat"    # e.g., "lat" or "Latitude"
lon_col   <- "Long"   # e.g., "lon" or "Longitude"
value_col <- "ind_sch_proximity_Score"       # the column you want to color by
name_col <- "HarbourName"
label_col <- name_col     # shown in popup; change to a descriptive column if you have one
# ----------------------------------------------


# Keep only complete rows (no missing lat/lon or value)
df_clean <- df %>%
  rename(lat = !!lat_col,
         lon = !!lon_col,
         value = !!value_col) %>%
  filter(!is.na(lat), !is.na(lon), !is.na(value)) %>%
  mutate(lat = as.numeric(lat),
         lon = as.numeric(lon),
         value = as.numeric(value)) %>%
  filter(!is.na(lat), !is.na(lon), !is.na(value))



# Continuous color palette based on values
#pal <- colorNumeric(
#  palette = "YlOrRd",    # try "Viridis" or "RdYlBu"
#  domain  = df_clean$value,
#  na.color = "#cccccc"
#)

pal_cat <- colorFactor(palette = "YlOrRd", domain = df_clean$value)

# Center map automatically using data bounds
map <- leaflet(df_clean) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%   # Clean basemap; options: OpenStreetMap, Esri.WorldImagery, etc.
  fitBounds(lng1 = min(df_clean$lon, na.rm = TRUE),
            lat1 = min(df_clean$lat, na.rm = TRUE),
            lng2 = max(df_clean$lon, na.rm = TRUE),
            lat2 = max(df_clean$lat, na.rm = TRUE)) %>%
  addCircleMarkers(
    lng = ~lon, lat = ~lat,
    #radius = ~scales::rescale(value, to = c(4, 12)), # size by value (optional). Remove `radius=...` to keep uniform sizes.
    color = "#333333",            # circle border color
    weight = 1,                   # border width
    fillColor = ~pal_cat(value),      # fill color by value
    fillOpacity = 0.8,
    popup = ~paste0(
      "<b>Value:</b> ", value,
      if ("id" %in% names(df_clean)) paste0("<br><b>ID:</b> ", df_clean$id) else ""
    )
    # If you have many points and want clustering, uncomment:
    # , clusterOptions = markerClusterOptions()
  ) %>%
  addLegend(
    position = "bottomright",
    pal = pal_cat,
    values = ~value,
    title = "Score",
    opacity = 1
  ) %>%
  addControl(html = "<h3 style='margin:4px;'>Proximity Score</h3>",
             position = "topleft")


map  # prints the interactive map in RStudio Viewer


# Assume `map` is your leaflet object created earlier
# Save as a standalone HTML file
saveWidget(map, file = "CIVI2_interactive_map.html", selfcontained = TRUE)


