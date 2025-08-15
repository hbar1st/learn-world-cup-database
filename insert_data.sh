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

# parameters are $1 the name of the team
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
  #echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
  # is the team unique?
  if [[ $OPPONENT != 'opponent' ]]
  then
    OPPONENT_TEAM_ID=$(INSERT_TEAM $OPPONENT)
    WINNER_TEAM_ID=$(INSERT_TEAM $WINNER)
  
    echo $OPPONENT_TEAM_ID
    
    echo $WINNER_TEAM_ID
  fi
  
done

