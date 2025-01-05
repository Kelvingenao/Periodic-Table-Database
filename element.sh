#!/bin/bash

# Configuración del comando para consultar la base de datos
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Validar si se proporciona un argumento
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Consulta para buscar el elemento por número atómico, símbolo o nombre
if [[ $1 =~ ^[0-9]+$ ]]; then
  QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
         FROM elements
         INNER JOIN properties USING(atomic_number)
         INNER JOIN types USING(type_id)
         WHERE atomic_number = $1"
else
  QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
         FROM elements
         INNER JOIN properties USING(atomic_number)
         INNER JOIN types USING(type_id)
         WHERE symbol = '$1' OR name = '$1'"
fi

# Ejecutar la consulta
RESULT=$($PSQL "$QUERY")

# Validar si el resultado de la consulta está vacío
if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
  exit 0
else
  # Procesar y mostrar los resultados
  IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$RESULT"
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi
