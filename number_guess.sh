# !/bin/bash

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
  PLAYER_USERNAME=$($PSQL "SELECT username FROM player WHERE username = $USERNAME";) 
  if  [[ -z $PLAYER_USERNAME ]]
  then 
    echo -e "\nWelcome, $PLAYER_USERNAME! It looks like this is your first time here."
  else
  # get player_id
    PLAYER_ID=$($PSQL "SELECT player_id FROM player WHERE username = $USERNAME;")
    GAMES_PLAYED=$($PSQL "SELECT COUNT(player_id) FROM games WHERE player_id = $PLAYER_ID;")
    BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE player_id = $PLAYER_ID;")
    echo -e "\nWelcome back, $PLAYER_USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi

  
}


