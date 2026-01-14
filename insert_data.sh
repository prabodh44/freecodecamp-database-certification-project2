#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

TEAMS_TABLE_COUNT=$($PSQL "SELECT count(*) FROM teams;")
if [[ TEAMS_TABLE_COUNT -eq 0 ]]
then
  cut -d',' -f3,4 games.csv | tail -n +2 | tr ',' '\n' | sort | uniq | while read -r TEAM
  do
    INSERT_INTO_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM')")
  done
fi

echo "reached here"

GAMES_TABLE_COUNT=$($PSQL "SELECT count(*) FROM games;")
if [[ $GAMES_TABLE_COUNT -eq 0 ]]
then
  tail -n +2 games.csv | while IFS=',' read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
    do
      # write insert query here
      WINNER_ID=$($PSQL "SELECT team_id from teams where name='$WINNER';")
      OPPONENT_ID=$($PSQL "SELECT team_id from teams where name='$OPPONENT';")
      $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);"
    done
fi
