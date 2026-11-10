source("get_career_data.r")
female_raw <- readLines("FemalePlayerCareer.js", warn = FALSE)
male_raw <- readLines("MalePlayerCareer.js", warn = FALSE)

female_matches <- parse_career_js(female_raw)
male_matches <- parse_career_js(male_raw)

if (nrow(female_matches) != 3) {
  stop("Female JS data should contain 3 records.")
}

if (nrow(male_matches) != 3) {
  stop("Male JS data should contain 3 records.")
}

# Clean both data formats
female <- clean_womens_matches(female_matches, "1981-09-26")
male <- clean_mens_matches(male_matches, "1986-06-03")

if (nrow(female) != 3) {
  stop("Female cleaning should retain 3 matches.")
}

if (nrow(male) != 3) {
  stop("Male cleaning should retain 3 matches.")
}

female_dates <- as.Date(c(
  "1995-10-30", "1997-03-07", "1997-08-04"
))

male_dates <- as.Date(c(
  "2001-09-10", "2001-09-17", "2001-09-17"
))

# Check each of the three records
for (i in 1:3) {
  if (is.na(female$date[i]) || female$date[i] != female_dates[i]) {
    stop("Female match date is incorrect.")
  }

  if (is.na(male$date[i]) || male$date[i] != male_dates[i]) {
    stop("Male match date is incorrect.")
  }

  female_age <- as.numeric(
    female_dates[i] - as.Date("1981-09-26")
  ) / 365.25

  male_age <- as.numeric(
    male_dates[i] - as.Date("1986-06-03")
  ) / 365.25

  opponent_dob <- as.Date(female_matches[i, 17], "%Y%m%d")
  female_opponent_age <- as.numeric(
    female_dates[i] - opponent_dob
  ) / 365.25

  male_opponent_age <- as.numeric(male_matches[i, 17])

  if (is.na(female$player_age[i]) ||
      abs(female$player_age[i] - female_age) > 0.000001) {
    stop("Female player age is incorrect.")
  }

  if (is.na(male$player_age[i]) ||
      abs(male$player_age[i] - male_age) > 0.000001) {
    stop("Male player age is incorrect.")
  }

  if (is.na(female$opponent_age[i]) ||
      abs(female$opponent_age[i] - female_opponent_age) > 0.000001) {
    stop("Female opponent age is incorrect.")
  }

  if (is.na(male$opponent_age[i]) ||
      abs(male$opponent_age[i] - male_opponent_age) > 0.000001) {
    stop("Male opponent age is incorrect.")
  }

  if (female$result[i] != female_matches[i, 5]) {
    stop("Female match result is incorrect.")
  }

  if (male$result[i] != male_matches[i, 5]) {
    stop("Male match result is incorrect.")
  }

  female_diff <- female_age - female_opponent_age
  male_diff <- male_age - male_opponent_age

  if (is.na(female$age_diff[i]) ||
      abs(female$age_diff[i] - female_diff) > 0.000001) {
    stop("Female age difference is incorrect.")
  }

  if (is.na(male$age_diff[i]) ||
      abs(male$age_diff[i] - male_diff) > 0.000001) {
    stop("Male age difference is incorrect.")
  }
}

source("plot_career_data.r")
female_plot <- plot_career_data(female)
male_plot <- plot_career_data(male)

print("All tests passed!")