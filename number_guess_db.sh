#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

CREATE_TABLE_PLAYER=$($PSQL "CREATE TABLE player(player_id SERIAL PRIMARY KEY, username VARCHAR(22));")
echo "$CREATE_TABLE_PLAYER"

CREATE_TABLE_GAMES=$($PSQL "CREATE TABLE games(game_id SERIAL PRIMARY KEY, number_of_guesses INT, player_id INT REFERENCES player(player_id));")
echo "$CREATE_TABLE_GAMES"