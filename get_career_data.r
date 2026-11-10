normalize_player_name <- function(player_name) {
  tolower(gsub("[[:space:]]+", "", player_name))
}


parse_career_js <- function(raw) {
  raw <- gsub("var morematchmx = ", "", raw, fixed = TRUE)
  raw <- gsub("[", "", raw, fixed = TRUE)
  raw <- gsub("]", "", raw, fixed = TRUE)
  raw <- gsub(";", "", raw, fixed = TRUE)

  raw <- gsub("^[[:space:]]+|[[:space:]]+$", "", raw)
  raw <- gsub(",$", "", raw)
  raw <- raw[raw != ""]
  raw <- gsub(', +"', ',"', raw)

  read.csv(
    text = paste(raw, collapse = "\n"),
    header = FALSE,
    colClasses = "character"
  )
}

clean_womens_matches <- function(matches, player_dob) {
  games <- matches[, c(1, 2, 3, 5, 12, 17)]
  names(games) <- c("date", "tournament", "surface", "result",
                    "opponent", "opponent_dob")

  games$date <- as.Date(games$date, "%Y%m%d")
  games$opponent_dob <- as.Date(games$opponent_dob, "%Y%m%d")
  keep <- !is.na(games$date) & !is.na(games$opponent_dob) &
    games$result %in% c("W", "L")
  games <- games[keep, ]

  games$player_age <- as.numeric(games$date - as.Date(player_dob)) / 365.25
  games$opponent_age <- as.numeric(games$date - games$opponent_dob) / 365.25
  games$age_diff <- games$player_age - games$opponent_age
  games
}


clean_mens_matches <- function(matches, player_dob) {
  games <- matches[, c(1, 2, 3, 5, 12, 17)]
  names(games) <- c("date", "tournament", "surface", "result",
                    "opponent", "opponent_age")

  games$date <- as.Date(games$date, "%Y%m%d")
  games$opponent_age <- as.numeric(games$opponent_age)
  keep <- !is.na(games$date) & !is.na(games$opponent_age) &
    games$result %in% c("W", "L")
  games <- games[keep, ]

  games$player_age <- as.numeric(games$date - as.Date(player_dob)) / 365.25
  games$age_diff <- games$player_age - games$opponent_age
  games
}

get_career_matches <- function(player_name) {
  key <- normalize_player_name(player_name)
  player_ids <- c(serenawilliams = "SerenaWilliams", rafaelnadal = "RafaelNadal")
  birth_dates <- c(serenawilliams = "1981-09-26", rafaelnadal = "1986-06-03")

  if (!(key %in% names(player_ids))) {
    stop(paste0("No career data found for '", player_name, "'."))
  }

  file_url <- paste0("https://www.tennisabstract.com/jsmatches/",
                     player_ids[[key]], "Career.js")
  raw <- readLines(file_url, warn = FALSE)
  matches <- parse_career_js(raw)
  player_dob <- birth_dates[[key]]

  if (key == "serenawilliams") {
    return(clean_womens_matches(matches, player_dob))
  }
  clean_mens_matches(matches, player_dob)
}