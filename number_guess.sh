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
  PLAYER_USERNAME=$($PSQL "SELECT username FROM player WHERE username = '$USERNAME'";) 
  if  [[ -z $PLAYER_USERNAME ]]
  then
    INSERT_PLAYER=$($PSQL "INSERT INTO player(username) VALUES('$USERNAME');") 
    echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  else
  # get player_id
    PLAYER_ID=$($PSQL "SELECT player_id FROM player WHERE username = '$USERNAME';")
    GAMES_PLAYED=$($PSQL "SELECT COUNT(player_id) FROM games WHERE player_id = $PLAYER_ID;")
    BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE player_id = $PLAYER_ID;")
    echo -e "\nWelcome back, $PLAYER_USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi

  DIV=$((1000+1))
  R=$(($RANDOM%$DIV))
  
  echo -e "\nGuess the secret number between 1 and 1000:"
  read GUESS
  declare -i GUESS_COUNT=0
  while [[ $GUESS -ne $R ]]
  do
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      echo -e "\nThat is not an integer, guess again:"
      read GUESS
      $GUESS_COUNT+=1
    fi
    if [[ $GUESS -lt $R ]]
    then
      echo -e "\nIt's higher than that, guess again:"
      read GUESS
      $GUESS_COUNT+=1
    elif [[ $GUESS -gt $R ]]
    then 
        echo -e "\nIt's lower than that, guess again:"
        read GUESS
        $GUESS_COUNT+=1
    fi
  done
  echo -e"\nYou guessed it in $GUESS_COUNT tries. The secret number was $R. Nice job!"
  
}


MAIN_GAME

