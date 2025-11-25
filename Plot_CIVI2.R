
# Install required packages if not already installed
# install.packages("ggplot2")

# Load necessary library
library(ggplot2)
library(tidyr)
library(dplyr)

# Read the CSV file
data <- read.csv("../CIVI 2.csv")

# Check the structure to confirm the column exists
str(data)

# Create the histogram
ggp <- ggplot(data, aes(x = ind_sch_proximity_Value)) +
  geom_histogram(binwidth = 0.1, fill = "steelblue", color = "black", na.rm = TRUE) +
  labs(x = "Proximity Value", y = "Frequency") +
  theme_minimal()

ggsave("ind_prox_value.png", bg = 'white', width = 7, height = 7, units = "in")

#############################################################################

#dev.new()
# Select the 9 columns you want to facet
cols_to_plot2 <- c("ind_coastal_sensitivity_index_Score",
                  "ind_harbour_condition_Score",
                  "ind_degree_of_protection_Score",
                  "ind_sea_level_change_Score",
                  "ind_ice_day_change_Score",
                  "ind_replacement_cost_Score",
                  "ind_harbour_utilization_Score",
                  "ind_sch_proximity_Score",
                  "CIVI")

# Reshape to long format
data_long2 <- data %>%
  select(all_of(cols_to_plot2)) %>%
  pivot_longer(cols = everything(), names_to = "Variable", values_to = "Score")

# Ensure Variable is a factor with the desired order
data_long2$Variable <- factor(data_long2$Variable, levels = cols_to_plot2)

# Remove NAs
data_long2 <- data_long2 %>% filter(!is.na(Score))

# Create facet histogram
ggp2 <- ggplot(data_long2, aes(x = Score)) +
  geom_histogram(bins = 5, fill = "steelblue", color = "black") +
  facet_wrap(~ Variable, scales = "free") +
  #labs(title = "Facet Histograms for Selected Variables") +
  theme_minimal()

ggsave("ind_score.png", bg = 'white', width = 7, height = 7, units = "in")

#############################################################################

#dev.new()
# Select the 8 columns you want to facet
cols_to_plot3 <- c("ind_coastal_sensitivity_index_Value",
                  "ind_harbour_condition_Value",
                  "ind_degree_of_protection_Value",
                  "ind_sea_level_change_Value",
                  "ind_ice_day_change_Value",
                  "ind_replacement_cost_Value",
                  "ind_harbour_utilization_Value",
                  "ind_sch_proximity_Value")

# Reshape to long format
data_long3 <- data %>%
  select(all_of(cols_to_plot3)) %>%
  pivot_longer(cols = everything(), names_to = "Variable", values_to = "Value")

# Ensure Variable is a factor with the desired order
data_long3$Variable <- factor(data_long3$Variable, levels = cols_to_plot3)

# Remove NAs
data_long3 <- data_long3 %>% filter(!is.na(Value))

# Create facet histogram
ggp3 <- ggplot(data_long3, aes(x = Value)) +
  geom_histogram(bins = 5, fill = "steelblue", color = "black") +
  facet_wrap(~ Variable, scales = "free") +
  #labs(title = "Facet Histograms for Selected Variables") +
  theme_minimal()

ggsave("ind_value.png", bg = 'white', width = 7, height = 7, units = "in")


#############################################################################

ggp4 <- ggplot(data, aes(x = ind_sch_proximity_Value, y = ind_sch_proximity_Score)) + geom_point()
ggsave("ind_prox_value_score.png", bg = 'white', width = 7, height = 7, units = "in")






