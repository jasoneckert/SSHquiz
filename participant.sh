#!/bin/bash
#Prompt the user for handle, remove any special characters, convert to lowercase, append PID to guarantee uniqueness
echo -e "Welcome Quiz Participant!\n\nEnter your handle (up to 7 letters, no spaces or special characters)-->\c"
read ANSWER
export HANDLE=$(echo $ANSWER | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]')-$$
echo "Thankyou $HANDLE, get ready to start the quiz!"
sleep 2


#Work in progress
for QUESTION in PSSH
do
CHOICE=""
while [ -d /quiz/1 -a -z $CHOICE ]
do
  echo -e 'Please enter your choice for QUESTION \#$QUESTION (enter 1, 2, 3, or 4 only!)-->\c'
  read CHOICE
  touch /quiz/1/$HANDLE_$CHOICE
done
