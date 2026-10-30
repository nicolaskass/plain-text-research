# Input:  data/penguins.csv
# Output: results/numbers.json (every number the documents report)
#         results/figures/*.png
# Nothing in content/ is typed by hand: it reads numbers.json.
library(ggplot2)
library(jsonlite)

penguins <- read.csv("data/penguins.csv", stringsAsFactors = TRUE)
complete <- na.omit(penguins[, c("species", "bill_length_mm", "bill_depth_mm",
                                 "flipper_length_mm", "body_mass_g")])

# Sample
n_total   <- nrow(penguins)
n_species <- as.list(table(penguins$species))

# Body mass by species
mass <- aggregate(body_mass_g ~ species, data = complete, FUN = mean)
mass_by_species <- setNames(as.list(round(mass$body_mass_g)), mass$species)

# Bill length vs. depth: pooled slope against within-species slopes
pooled <- coef(lm(bill_depth_mm ~ bill_length_mm, data = complete))[2]
within <- sapply(split(complete, complete$species),
                 function(d) unname(coef(lm(bill_depth_mm ~ bill_length_mm, data = d))[2]))

numbers <- list(
  n_total          = n_total,
  n_species        = n_species,
  mass_by_species  = mass_by_species,
  slope_pooled     = round(unname(pooled), 3),
  slope_by_species = as.list(round(setNames(within, names(within)), 3))
)
dir.create("results/figures", recursive = TRUE, showWarnings = FALSE)
write_json(numbers, "results/numbers.json", auto_unbox = TRUE, pretty = TRUE)

# Figures
palette <- c(Adelie = "#c0623b", Chinstrap = "#6a4c93", Gentoo = "#2a7f62")

p <- ggplot(complete, aes(bill_length_mm, bill_depth_mm)) +
  geom_point(aes(colour = species), alpha = .6, size = 1.6) +
  geom_smooth(method = "lm", se = FALSE, colour = "grey30", linetype = "dashed") +
  geom_smooth(aes(colour = species), method = "lm", se = FALSE) +
  scale_colour_manual(values = palette) +
  labs(x = "Bill length (mm)", y = "Bill depth (mm)", colour = NULL) +
  theme_minimal(base_size = 11) + theme(legend.position = "bottom")
ggsave("results/figures/bill.png", p, width = 5, height = 4, dpi = 200)

p <- ggplot(complete, aes(species, body_mass_g, fill = species)) +
  geom_boxplot(width = .5, outlier.size = .8, show.legend = FALSE) +
  scale_fill_manual(values = palette) +
  labs(x = NULL, y = "Body mass (g)") +
  theme_minimal(base_size = 11)
ggsave("results/figures/mass.png", p, width = 5, height = 3.5, dpi = 200)
