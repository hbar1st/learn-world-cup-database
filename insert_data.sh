#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# pg_dump -U freecodecamp -d worldcup -cC --inserts > worldcup.sql
TRUNCATE_RESULT=$($PSQL "truncate teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
  # is the team unique?
  OPPONENT_TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
  echo $OPPONENT_TEAM_ID
  if [[ -z $OPPONENT_TEAM_ID ]]
  then
    # add it (insert the new team into the teams table)
    INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
    echo $INSERT_TEAM_RESULT
  fi
done