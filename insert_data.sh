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

# parameter: $1 is the name of the team
# output is the new team id if one is made or the matching team id from the table
INSERT_TEAM() {
  TEAM_ID=$($PSQL "select team_id from teams where name='$1'")

  if [[  $1 != 'opponent' && -z $TEAM_ID ]]
  then
    # add it (insert the new team into the teams table)
    INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$1')")
    TEAM_ID=$($PSQL "select team_id from teams where name='$1'")
  fi

  echo "$TEAM_ID"
}

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # skip dealing with the title row
  if [[ $OPPONENT != 'opponent' ]]
  then
    # populate the teams table with unique team names
    OPPONENT_TEAM_ID=$(INSERT_TEAM $OPPONENT)
    WINNER_TEAM_ID=$(INSERT_TEAM $WINNER)

    # populate the games table with each game played
    INSERT_GAME_RESULT=$($PSQL "insert into games(year,round,winner_goals,opponent_goals,winner_id,opponent_id) values($YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS,$WINNER_TEAM_ID,$OPPONENT_TEAM_ID)")
  fi
  
done

