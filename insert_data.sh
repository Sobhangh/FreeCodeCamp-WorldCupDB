#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
CLEAR=$($PSQL "TRUNCATE teams, games;")
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv |  while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#echo $YEAR $WINNER
  if [[ $WINNER != winner ]]
  then
    ADDED_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #echo $ADDED_WINNER
    if [[ -z $ADDED_WINNER ]]
    then
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
    ADDED_OPP=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $ADDED_OPP ]]
    then
      INSERT_OPP=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
    #INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND','$ADDED_WINNER', '$ADDED_OPP', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  fi
done

cat games.csv |  while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#echo $YEAR $WINNER
  if [[ $WINNER != winner ]]
  then
    ADDED_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    ADDED_OPP=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$ADDED_WINNER, $ADDED_OPP, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done
echo "$($PSQL "SELECT * FROM teams")"