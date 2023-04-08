#!/bin/bash
#Check for root access
if [ $UID -ne 0 ]; then
  echo -e "You must be root to run this script.\nSwitch to root (feel the power!) and try again."
  exit 255
fi

#Check for required programs
if ! which chpasswd; then
  echo -e "You must install the chpasswd command."
  exit 255
fi
if ! which shuf; then
  echo -e "You must install the shuf command."
  exit 255
fi
if ! which fold; then
  echo -e "You must install the fold command."
  exit 255
fi
if ! which tr; then
  echo -e "You must install the tr command."
  exit 255
fi
if ! which jq; then
  echo -e "You must install the jq command."
  exit 255
fi
if ! which perl; then
  echo -e "You must install the perl command."
  exit 255
fi

#Display instructions
clear
echo -e "What is the host name or IP address of your Linux server?--> \c"
read SERVER
echo -e "Adjust the size of your graphical terminal such that it is\nslightly wider than the line shown here and press Enter.
echo -e "========================================================"
read DUMMY
clear
echo -e "\nPRESENTER INSTRUCTIONS (READ CAREFULLY):\nWhen you press Enter, the SSH username and password\nthat participants should use will be displayed.\n\nAt this point, share your terminal window in your presentation\nand advise users to SSH into the server using these credentials.\n\nWhen you are satisfied that everyone is connected, press Enter to\nstart the quiz and display the first question.\n\nNarrate the question and answers as needed. When you feel enough time has\npassed for participants to answer, press Enter to view the results.\n\nAfter viewing the results, press Enter to continue to the next question.\n\nREADY TO START? PRESS ENTER TO DISPLAY THE SSH CREDENTIALS"
read DUMMY

#Create /quiz directory, add quiz user, display credentials
mkdir -m 1777 /quiz
useradd -m -s /bin/participant.sh quiz$$
PW=$(shuf -n 1 /usr/share/dict/words)
echo "quiz$$:$PW" | chpasswd
clear
echo -e "========================================================\n SSH server: $SERVER\n========================================================\n SSH username: quiz$$\n========================================================\n SSH password: $PW\n========================================================\n\n When everyone has connected, the presenter will press\n Enter to start the quiz and display the first question.\n\n========================================================"
read DUMMY

#Display quiz question followed by answer and results
#Modify "20" to reflect the actual number of quiz questions.
for QUESTION in $(seq 1 20); do
  mkdir -m 1777 /quiz/$QUESTION
  clear
  echo -e "========================================================"
  echo -e "                       QUESTION #$QUESTION"
  echo -e "========================================================"
  cat quiztemplate.json | jq ".Question$QUESTION.Description" | fold -w 56 | tr -d '"'
  echo -e "========================================================\n"
  cat quiztemplate.json | jq ".Question$QUESTION.Choice1" | fold -w 56 | tr -d '"'
  cat quiztemplate.json | jq ".Question$QUESTION.Choice2" | fold -w 56 | tr -d '"'
  cat quiztemplate.json | jq ".Question$QUESTION.Choice3" | fold -w 56 | tr -d '"'
  cat quiztemplate.json | jq ".Question$QUESTION.Choice4" | fold -w 56 | tr -d '"'
  echo -e "\n========================================================"
  read DUMMY
  clear
  echo -e "========================================================"
  echo -e "                         ANSWER
  echo -e "========================================================"
  cat quiztemplate.json | jq ".Question$QUESTION.AnswerDescription" | fold -w 56 | tr -d '"'
  echo -e "========================================================"
  echo -e "                         RESULTS
  echo -e "========================================================\n"
  export RESULTS1=$(find /quiz/$QUESTION -name "*-1"|wc -l)
  echo -e "Answer 1. $(perl -e "print '*' x $RESULTS1")"
  export RESULTS2=$(find /quiz/$QUESTION -name "*-1"|wc -l)
  echo -e "Answer 2. $(perl -e "print '*' x $RESULTS2")"
  export RESULTS3=$(find /quiz/$QUESTION -name "*-1"|wc -l)
  echo -e "Answer 3. $(perl -e "print '*' x $RESULTS3")"
  export RESULTS4=$(find /quiz/$QUESTION -name "*-1"|wc -l)
  echo -e "Answer 4. $(perl -e "print '*' x $RESULTS4")"
  echo -e "\n========================================================"
  read DUMMY
done

#Tally results and top 3 scorers at end

#Archive results, delete /quiz directory, and remove quiz user account

