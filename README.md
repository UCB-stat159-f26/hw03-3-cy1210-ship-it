# STAT 159 HW3 — R/Python Package

Author — Chengjing Yang  
Project start date — 11/08/2026

## Overview

This project develops reusable R functions to retrieve, clean, and visualize tennis career data from Tennis Abstract. It extends the Serena Williams plot from HW2 to support both Serena Williams and Rafael Nadal. The workflow has two main functions. `get_career_matches()` retrieves and cleans match records, and `plot_career_data()` creates a scatter plot from the cleaned data.

## Files

get_career_data.r — Defines get_career_matches() and helper functions for normalizing player names, parsing JavaScript records, and cleaning match data.

plot_career_data.r — Defines plot_career_data().

serena-hw3-preview.png — Scatter plot for Serena Williams.

nadal-hw3-preview.png — Scatter plot for Rafael Nadal.

instructions.md — Assignment instructions.

README.md — Project description and reproduction instructions.

All listed files are located in the repository root.

## Requirements

The workflow requires R, the ggplot2 package, and an internet connection to download match records. If ggplot2 is not installed, run install.packages("ggplot2") in the R console.

## Inputs and Outputs

### Data function

`get_career_matches(player_name)` takes a player's name as a character string. The current implementation supports Serena Williams and Rafael Nadal. Capitalization and whitespace are normalized, so inputs such as `"serena williams"` and `"SerenaWilliams"` are accepted.

The function returns a cleaned data frame containing match dates, tournaments, surfaces, results, opponents, player ages, opponent ages, and age differences. Serena's data also includes opponents' dates of birth. Unsupported names produce an error message.

### Plotting function

`plot_career_data(matches)` takes the cleaned data frame and returns a ggplot scatter plot.

- The x-axis shows the player's age at the time of each match.
- The y-axis shows the player's age minus the opponent's age.
- Points are colored by match result, with `W` for wins and `L` for losses.

A positive age difference means the player was older than the opponent. A negative value means the player was younger.

## Reproduce the Outputs

Run the following commands in R from the repository root to retrieve the data and display both plots.

```r
source("get_career_data.r")
source("plot_career_data.r")

serena <- get_career_matches("Serena Williams")
nadal <- get_career_matches("Rafael Nadal")

plot_career_data(serena)
plot_career_data(nadal)
```

## Make Rules

To reproduce the data and plots, run the R commands in the “Reproduce the Outputs” section from the repository root.

## Personal Reflection

This assignment taught me how to create an R package and turn my HW2 code into reusable functions. I learned to separate data cleaning from plotting and use helper functions to organize the steps. One challenge was that Serena Williams’s data contains opponents’ birth dates, while Rafael Nadal’s data provides opponent ages directly. I wrote separate cleaning functions to handle these differences and create consistent columns. This allowed me to use the same plotting function for both players. I also learned how to call the data function with a player’s name and pass its output to the plotting function to generate a graph.