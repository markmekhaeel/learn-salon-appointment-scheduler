#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~ Welcome to my salon ~~\n"

echo -e "\nHow may I help you?"
MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  SERVICES=$($PSQL "SELECT * FROM services;")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
  do
    echo "$SERVICE_ID) $SERVICE"
  done
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")
  if [[ -z $SERVICE_NAME ]]
  then
    MAIN_MENU "Please, Enter a valid number of a service?"
  else
    #checking phone number
    echo -e "\nPlease enter your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
    #if phone not found
    if [[ -z $CUSTOMER_NAME ]]
    then  
      #ask for customer name
      echo -e "\nWhat's your name?"
      read CUSTOMER_NAME
      #insert customer info
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE');")
    fi
    #get customer id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
    #ask for the time
    echo -e "\nWhat time you prefer?"
    read SERVICE_TIME
    #insert the appointment
    INSERT_APP_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
    echo -e "\n\n I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    
  fi
}

MAIN_MENU