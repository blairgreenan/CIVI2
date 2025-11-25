
library(ggplot2)

# Remove NAs and ensure numeric
data$ind_sch_proximity_Value <- suppressWarnings(as.numeric(data$ind_sch_proximity_Value))
data_no_na <- subset(data, !is.na(ind_sch_proximity_Value))

# Plot cumulative distribution
ggp_cdf <- ggplot(data_no_na, aes(x = ind_sch_proximity_Value)) +
  stat_ecdf(geom = "step", color = "blue", size = 1) +
  labs(title = "Cumulative Distribution of ind_sch_proximity_Value",
       x = "ind_sch_proximity_Value",
       y = "Cumulative Probability") +
  theme_minimal()


