plot_career_data <- function(matches) {
  ggplot2::ggplot(
    matches,
    ggplot2::aes(x = player_age, y = age_diff, color = result)
  ) +
    ggplot2::geom_point()
}
