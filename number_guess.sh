#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN_GAME(){
  if [[ $1 ]] 
  then 
    echo -e "\n$1"
  fi

  # get username from player
  echo "Enter your username:"
  read USERNAME

  # checking if username is registred
  #PLAYER_USERNAME=$($PSQL "SELECT username FROM player WHERE username = '$USERNAME'";) 
  PLAYER_ID=$($PSQL "SELECT player_id FROM player WHERE username = '$USERNAME';")
  if  [[ -z $PLAYER_ID ]]
  then
    INSERT_PLAYER=$($PSQL "INSERT INTO player(username) VALUES('$USERNAME');") 
    echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  else
  # get player_id
    GAMES_PLAYED=$($PSQL "SELECT COUNT(player_id) FROM games LEFT JOIN player USING(player_id) WHERE player_id = $PLAYER_ID;")
    BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games LEFT JOIN player USING(player_id) WHERE player_id = $PLAYER_ID;")
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi

  DIV=$((1000+1))
  SECRET_NUMBER=$(($RANDOM%$DIV))
  
  echo -e "\nGuess the secret number between 1 and 1000:"
  read GUESS
  declare -i NUMBER_OF_GUESSES=0
  while [[ $GUESS -ne $SECRET_NUMBER ]]
  do
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      echo -e "\nThat is not an integer, guess again:"
      read GUESS
      ((NUMBER_OF_GUESSES++))
    fi
    if [[ $GUESS -lt $SECRET_NUMBER ]]
    then
      echo -e "\nIt's higher than that, guess again:"
      read GUESS
      ((NUMBER_OF_GUESSES++))
    elif [[ $GUESS -gt $SECRET_NUMBER ]]
    then 
        echo -e "\nIt's lower than that, guess again:"
        read GUESS
        ((NUMBER_OF_GUESSES++))
    fi
  done
  echo -e "\nYou guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
  
  PLAYER_ID=$($PSQL "SELECT player_id FROM player WHERE username = '$USERNAME';")
  INSERT_GAME=$($PSQL "INSERT INTO games(number_of_guesses, player_id) VALUES($NUMBER_OF_GUESSES, $PLAYER_ID);")
  #echo "$INSERT_GAME"
  
}


MAIN_GAME

