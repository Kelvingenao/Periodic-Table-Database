#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Buscar por número atómico, símbolo o nombre
RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
                FROM elements
                INNER JOIN properties USING(atomic_number)
                INNER JOIN types USING(type_id)
                WHERE atomic_number = $1 OR symbol = '$1' OR name = '$1'")

if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
  exit 0
else
  echo "$RESULT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
fi
