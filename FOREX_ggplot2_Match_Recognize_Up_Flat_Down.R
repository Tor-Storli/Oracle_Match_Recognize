library(ggplot2)
library(dplyr)

# Load the dataset
df <- read.table(text = "symbol	'date'	match_num	var_match	adjusted adjusted_diff
GBPUSD=X	05-APR-20	1	STRT	1.2220158576965332	-0.017479419708252
GBPUSD=X	06-APR-20	1	UP	1.2240501642227173	0.0020343065261841
GBPUSD=X	07-APR-20	1	UP	1.2338672876358032	0.0098171234130859
GBPUSD=X	08-APR-20	1	UP	1.23931086063385	0.0054435729980468
GBPUSD=X	09-APR-20	1	UP	1.2454850673675537	0.0061742067337037
GBPUSD=X	12-APR-20	1	UPFLAT	1.2461059093475342	0.0006208419799805
GBPUSD=X	13-APR-20	1	UP	1.2523951530456543	0.0062892436981201
GBPUSD=X	14-APR-20	1	UP	1.26262629032135	0.0102311372756957
GBPUSD=X	15-APR-20	1	DOWN	1.252097249031067	-0.010529041290283
GBPUSD=X	16-APR-20	1	DOWN	1.2487823963165283	-0.0033148527145387
GBPUSD=X	19-APR-20	1	DOWNFLAT	1.248751163482666	-0.0000312328338623
GBPUSD=X	20-APR-20	1	DOWN	1.2442762851715088	-0.0044748783111572
GBPUSD=X	21-APR-20	1	DOWN	1.2298610210418701	-0.0144152641296387", header = TRUE)

# Convert date column to date format
df$date <- as.Date(df$date, format = "%d-%b-%y")

# Create a new column for the trend
df <- df |>
  mutate(trend = case_when(
    var_match == "STRT" ~ "Start",
    var_match == "UP" ~ "Up",
    var_match == "UPFLAT" ~ "UpFlat",
    var_match == "DOWNFLAT" ~ "DownFlat",
    TRUE ~ "Down"
  ))

# Create the plot
ggplot(df, aes(x = date, y = adjusted, group = 1)) +
  geom_line() +
  geom_segment(aes(x = date, xend = date, y = adjusted, yend = adjusted, color = trend), 
               arrow = arrow(length = unit(0.2, "cm"), angle = 30), size = 1.5) +
  geom_text(aes(x = date, y = adjusted, label = trend), size = 3, vjust = 1.5) +
  scale_color_manual(values = c("red", "orange","green", "blue", "purple")) +
  labs(title = "Up-Flat-Down Pattern", 
       subtitle = "Year: 2020", 
       caption= "GBPUSD=X",
       x = "Date", y = "Adjusted", color = "Trend") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text( size = 12, face = "bold", hjust=0.5),
        plot.caption = element_text(color = "blue", size = 14, face = "bold", hjust=0.5))
