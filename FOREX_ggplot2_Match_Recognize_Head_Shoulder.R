library(ggplot2)
library(dplyr)

# Load the dataset
df <- read.table(text = "symbol	'date'	match_num	var_match	adjusted
AUDUSD=X	14-JUN-15	1	STRT	0.7730364799499512
AUDUSD=X	15-JUN-15	1	UP	0.7757951617240906
AUDUSD=X	16-JUN-15	1	DOWN	0.774713397026062
AUDUSD=X	17-JUN-15	1	DOWN	0.7725587487220764
AUDUSD=X	18-JUN-15	1	UP2	0.7789981961250305
AUDUSD=X	21-JUN-15	1	UP2	0.7765783667564392
AUDUSD=X	22-JUN-15	1	DOWN	0.7728572487831116
AUDUSD=X	23-JUN-15	1	UP	0.7742335200309753
AUDUSD=X	24-JUN-15	1	DOWN2	0.7709506154060364", header = TRUE)

# Convert date column to date format
df$date <- as.Date(df$date, format = "%d-%b-%y")

# Create a new column for the trend
df <- df |>
  mutate(trend = case_when(
    var_match == "STRT" ~ "Start",
    var_match == "UP" ~ "Up",
    var_match == "UP2" ~ "Up2",
    var_match == "DOWN2" ~ "Down2",
    TRUE ~ "Down"
  ))

# Create the plot
ggplot(df, aes(x = date, y = adjusted, group = 1)) +
  geom_line() +
  geom_segment(aes(x = date, xend = date, y = adjusted, yend = adjusted, color = trend), 
               arrow = arrow(length = unit(0.2, "cm"), angle = 30), size = 1.5) +
  geom_text(aes(x = date, y = adjusted, label = trend), size = 3, vjust = 1.5) +
  scale_color_manual(values = c("red", "orange","green", "blue", "purple")) +
  labs(title = "Head and Shoulder Pattern", 
       subtitle = "Year: 2015", 
       caption= "AUDUSD=X",
       x = "Date", y = "Adjusted", color = "Trend") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text( size = 12, face = "bold", hjust=0.5),
        plot.caption = element_text(color = "blue", size = 14, face = "bold", hjust=0.5))