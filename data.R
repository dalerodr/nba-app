library(tidyverse)          # Easily Install and Load the 'Tidyverse'
library(shiny)              # Web Application Framework for R
library(shinydashboard)     # Create Dashboards with 'Shiny'
library(bslib)              # Custom 'Bootstrap' 'Sass' Themes for 'shiny' and 'rmarkdown'
library(lubridate)          # Make Dealing with Dates a Little Easier
library(here)               # A Simpler Way to Find Your Files
library(feather)            # R Bindings to the Feather 'API'
library(nbastatR)           # R's interface to NBA data
library(shinyWidgets)       # Custom Inputs Widgets for Shiny
library(fontawesome)        # Easily Work with 'Font Awesome' Icons
library(shinycustomloader)  # Custom Loader for Shiny Outputs
library(c3)                 # 'C3.js' Chart Library
library(overviewR)          # Easily Extracting Information About Your Data
library(ggthemes)           # Extra Themes, Scales and Geoms for 'ggplot2'
library(ggplot2)            # Create Elegant Data Visualisations Using the Grammar of Graphics
library(plotly)             # Create Interactive Web Graphics via 'plotly.js'
library(DT)                 # A Wrapper of the JavaScript Library 'DataTables'
library(rsconnect)          # Deployment Interface for R Markdown Documents and Shiny Applications
library(reactablefmtr)      # Easily Customize Interactive Tables Made with Reactable
library(scatterD3)          # D3 JavaScript Scatterplot from R
library(sever)              # Customise 'Shiny' Disconnected Screens and Error Messages

library(duckdb)

`%notin%` <- Negate(`%in%`)


# functions ----------------------------------------------------------------
# columna_dummy
# get_team_data
# get_player_data
# get_teams
# get_players
# get_teammates_player1
# get_teammates_player2
# get_record_data

columna_dummy <- function(df, columna) {
  df %>% 
    mutate(valor = df$game) %>% 
    spread(key = columna, value = valor, fill = 0)
}

get_team_data <- function(team) {
  # DuckDB can read files from folder by using a glob pattern
  parquet_path <- "data/game_data.parquet"
  
  # Connection
  conexion <- dbConnect(duckdb(), read_only = TRUE)
  on.exit(dbDisconnect(conexion, shutdown = FALSE))
  
  # SQL statement to perform data aggregation
  # String interpolation is used to inject dynamic string parts into the query
  duck_query <- str_interp("
    select
      *
    from parquet_scan('${parquet_path}')
    where nameTeam = '${team}'
  ")
  
  # Run the query with DuckDB in memory
  res <- dbGetQuery(
    conn = conexion,
    statement = duck_query
  )
  
  return(res)
}

get_player_data <- function(player) {
  # DuckDB can read files from folder by using a glob pattern
  parquet_path <- 'data/game_data.parquet'

  # Connection
  conexion <- dbConnect(duckdb(), read_only = TRUE)
  on.exit(dbDisconnect(conexion, shutdown = FALSE))

  # SQL statement to perform data aggregation
  # String interpolation is used to inject dynamic string parts into the query
  duck_query <- glue::glue_sql("
    select
      *
    from parquet_scan({`parquet_path`})
    where name_idPlayer IN ({player})"
    , player = player
    , .con = conexion)

  # Run the query with DuckDB in memory
  res <- dbGetQuery(
    conn = conexion,
    statement = duck_query
  )

  return(res)
}

get_teams <- function() {
  # DuckDB can read files from folder by using a glob pattern
  parquet_path <- "data/game_data.parquet"
  
  # Connection
  conexion <- dbConnect(duckdb(), read_only = TRUE)
  on.exit(dbDisconnect(conexion, shutdown = FALSE))
  
  # SQL statement to perform data aggregation
  # String interpolation is used to inject dynamic string parts into the query
  duck_query <- str_interp("
    select
      distinct nameTeam
    from parquet_scan('${parquet_path}')
    order by 1 asc
  ")
  
  # Run the query with DuckDB in memory
  res <- dbGetQuery(
    conn = conexion,
    statement = duck_query
  )
  
  return(res)
}

get_players <- function() {
  # DuckDB can read files from folder by using a glob pattern
  parquet_path <- "data/game_data.parquet"
  
  # Connection
  conexion <- dbConnect(duckdb(), read_only = TRUE)
  on.exit(dbDisconnect(conexion, shutdown = FALSE))
  
  # SQL statement to perform data aggregation
  # String interpolation is used to inject dynamic string parts into the query
  duck_query <- str_interp("
    select
      distinct name_idPlayer
    from parquet_scan('${parquet_path}')
    order by 1 asc
  ")
  
  # Run the query with DuckDB in memory
  res <- dbGetQuery(
    conn = conexion,
    statement = duck_query
  )
  
  return(res)
}

get_teammates_player1 <- function(player) {
  # DuckDB can read files from folder by using a glob pattern
  parquet_path <- "data/game_data.parquet"
  
  # Connection
  conexion <- dbConnect(duckdb(), read_only = TRUE)
  on.exit(dbDisconnect(conexion, shutdown = FALSE))
  
  # SQL statement to perform data aggregation
  # String interpolation is used to inject dynamic string parts into the query
  duck_query <- glue::glue_sql("
    select distinct games_player_1.name_idPlayer
    from 
      (select distinct idGame, idTeam, name_idPlayer
      from parquet_scan({`parquet_path`})
      where name_idPlayer IN ({player})) player_1
    inner join
      (select distinct idGame, idTeam, name_idPlayer
      from parquet_scan({`parquet_path`})
      where idGame in (select distinct idGame
              				 from parquet_scan({`parquet_path`})
              				 where name_idPlayer IN ({player}))) games_player_1
    on player_1.idTeam = games_player_1.idTeam
    and player_1.idGame = games_player_1.idGame
    where games_player_1.name_idPlayer NOT IN ({player})
    order by 1 asc"
    , player = player
    , .con = conexion)
  
  # Run the query with DuckDB in memory
  res <- dbGetQuery(
    conn = conexion,
    statement = duck_query
  )
  
  return(res)
}

get_teammates_player2 <- function(player1, player2) {
  # DuckDB can read files from folder by using a glob pattern
  parquet_path <- "data/game_data.parquet"
  
  # Connection
  conexion <- dbConnect(duckdb(), read_only = TRUE)
  on.exit(dbDisconnect(conexion, shutdown = FALSE))
  
  # SQL statement to perform data aggregation
  # String interpolation is used to inject dynamic string parts into the query
  duck_query <- glue::glue_sql("
    select distinct games_1_2.name_idPlayer
    from
    -- games_1_2: consultamos sólo los partidos que han jugado juntos el jugador 1 y 2 para quedarnos con sus compañeros de equipo
    (select distinct idGame
     , idTeam
     , name_idPlayer
     from parquet_scan({`parquet_path`})
     where idGame in (select distinct games_player_1.idGame
     				  from 
     				      (select distinct idGame
     				       , idTeam
     				       , name_idPlayer
     				       from parquet_scan({`parquet_path`})
     				       where name_idPlayer IN ({player_1})
     					  ) games_player_1
     				     inner join
     				      (select distinct idGame
     				       , idTeam
     				       , name_idPlayer
     				       from parquet_scan({`parquet_path`})
     				       where name_idPlayer IN ({player_2})
     					  ) games_player_2
     				     on games_player_1.idGame = games_player_2.idGame
     				     and games_player_1.idTeam = games_player_2.idTeam
     				 )
    ) games_1_2
    inner join
    -- join_games: cruzamos con los partidos que han jugado juntos el jugador 1 y 2
    (select distinct games_player_1.idGame
    , games_player_1.idTeam
    from 
      (select distinct idGame
       , idTeam
       , name_idPlayer
       from parquet_scan({`parquet_path`})
       where name_idPlayer IN ({player_1})
      ) games_player_1
     inner join
      (select distinct idGame
       , idTeam
       , name_idPlayer
       from parquet_scan({`parquet_path`})
       where name_idPlayer IN ({player_2})
      ) games_player_2
     on games_player_1.idGame = games_player_2.idGame
     and games_player_1.idTeam = games_player_2.idTeam
    ) join_games
    on games_1_2.idGame = join_games.idGame
    and games_1_2.idTeam = join_games.idTeam
    where games_1_2.name_idPlayer NOT IN ({player_1})
    and games_1_2.name_idPlayer NOT IN ({player_2})"
    , player_1 = player1
    , player_2 = player2
    , .con = conexion)
  
  # Run the query with DuckDB in memory
  res <- dbGetQuery(
    conn = conexion,
    statement = duck_query
  )
  
  return(res)
}

get_record_data <- function(record_pts_1, record_pts_2, record_minutes_1, record_minutes_2, Records_player) {
  # DuckDB can read files from folder by using a glob pattern
  parquet_path <- "data/game_data.parquet"
  
  # Connection
  conexion <- dbConnect(duckdb(), read_only = TRUE)
  on.exit(dbDisconnect(conexion, shutdown = FALSE))
  
  # SQL statement to perform data aggregation
  # String interpolation is used to inject dynamic string parts into the query
  duck_query <- glue::glue_sql("
    select
      *
    from parquet_scan({`parquet_path`})
    where pts between {pts_1} and {pts_2}
      and minutes between {minutes_1} and {minutes_2}
      and name_idPlayer IN ({player})"
    , pts_1 = record_pts_1
    , pts_2 = record_pts_2
    , minutes_1 = record_minutes_1
    , minutes_2 = record_minutes_2
    , player = Records_player
    , .con = conexion )
  
  # Run the query with DuckDB in memory
  res <- dbGetQuery(
    conn = conexion,
    statement = duck_query
  )
  
  return(res)
}


# year & team logos data
current_year <- year(date(Sys.Date()))
teams_logos <- read_feather("data/teams_logos.feather")

