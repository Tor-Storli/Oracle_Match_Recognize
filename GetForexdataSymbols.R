# Load Libraries
# ---------------
library(tidyverse)
library(rvest)

url <- "https://finance.yahoo.com/currencies"

symbols <- read_html(url) |>
    html_nodes(xpath = '//*[@data-test="quoteLink"]') |>
    html_text()
    # html_attr("href") |>
    # str_extract_all("(?<=p=)[A-Z]{3,6}%3DX") |>
    # unlist()
  
# symbols <- gsub("%3DX", "=X", symbols)
symbols <- c(symbols)
symbols
