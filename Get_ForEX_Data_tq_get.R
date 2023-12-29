# Load libraries
# ---------------
library(tidyverse)
library(tidyquant)

# Get data from the internet
# --------------------------
data <- tq_get(x = c(symbols), get = "stock.prices", 
               complete_cases = TRUE, from = "2015-01-01", to = "2023-12-31")

# Drop Rows with NA in any column
# -------------------------------
data <- drop_na(data)

# save to CSV File
# ----------------
data |>
  write_csv("C:/Temp/Stocks/ForexData.csv")


