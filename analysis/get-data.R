# Export the palmerpenguins data to plain text, once.
# After this, the analysis reads only data/penguins.csv.
library(palmerpenguins)

write.csv(penguins, "data/penguins.csv", row.names = FALSE, na = "")
