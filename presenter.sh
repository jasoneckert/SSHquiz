#!/bin/bash
#Check for root access
if [ $UID -ne 0 ]; then
  echo -e "You must be root to run this script.\nSwitch to root (feel the power!) and try again."
  exit 255
fi

#Check for required programs
for PROGRAM in chpasswd shuf fold tr jq perl; do
if ! which $PROGRAM; then
  echo -e "You must install the $PROGRAM command."
  exit 255
fi

#Display instructions
clear
echo -e "What is the host name or IP address of your Linux server?--> \c"
read SERVER
echo -e "Increase the size of your terminal font. Next, adjust\nyour graphical terminal width such that it is slightly\nwider than the line shown here and press Enter."
echo -e "========================================================"
read DUMMY
clear
echo -e "\nPRESENTER INSTRUCTIONS (READ CAREFULLY):\nWhen you press Enter, the SSH username and password\nthat participants should use will be displayed.\n\nAt this point, share your terminal window in your\npresentation and advise users to SSH into the server\nusing these credentials. When you are satisfied that\neveryone is connected, press Enter to start the quiz\nand display the first question.\n\nNarrate the question and answers as needed. When you\nfeel enough time has passed for participants to answer,\npress Enter to view the results.\n\nAfter viewing the results, press Enter to continue to\nthe next question.\n\nREADY TO START?\nPRESS ENTER TO DISPLAY THE SSH CREDENTIALS"
read DUMMY

#Create /quiz directory, add quiz user, display credentials
mkdir -m 1777 /quiz
mkdir -m 1777 /quiz/participants
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
  cat quiztemplate.json | jq ".Question$QUESTION.Description" | fold -sw 56 | tr -d '"'
  echo -e "========================================================\n"
  cat quiztemplate.json | jq ".Question$QUESTION.Choice1" | fold -sw 56 | tr -d '"'
  cat quiztemplate.json | jq ".Question$QUESTION.Choice2" | fold -sw 56 | tr -d '"'
  cat quiztemplate.json | jq ".Question$QUESTION.Choice3" | fold -sw 56 | tr -d '"'
  cat quiztemplate.json | jq ".Question$QUESTION.Choice4" | fold -sw 56 | tr -d '"'
  echo -e "\n========================================================"
  read DUMMY
  clear
  export ANSWER=$(cat quiztemplate.json | jq ".Question$QUESTION.Answer" | tr -d '"'')
  find /quiz/$QUESTION -name "*-$ANSWER" | sed "s#/quiz/$QUESTION##" > /quiz/$QUESTIONresults
  echo -e "========================================================"
  echo -e "                         ANSWER"
  echo -e "========================================================"
  cat quiztemplate.json | jq ".Question$QUESTION.AnswerDescription" | fold -sw 56 | tr -d '"'
  echo -e "========================================================"
  echo -e "                         RESULTS"
  echo -e "========================================================\n"
  export RESULTS1=$(find /quiz/$QUESTION -name "*-1"|wc -l)
  echo -e "Answer 1. $(perl -e "print '*' x $RESULTS1")"
  export RESULTS2=$(find /quiz/$QUESTION -name "*-2"|wc -l)
  echo -e "Answer 2. $(perl -e "print '*' x $RESULTS2")"
  export RESULTS3=$(find /quiz/$QUESTION -name "*-3"|wc -l)
  echo -e "Answer 3. $(perl -e "print '*' x $RESULTS3")"
  export RESULTS4=$(find /quiz/$QUESTION -name "*-4"|wc -l)
  echo -e "Answer 4. $(perl -e "print '*' x $RESULTS4")"
  echo -e "\n========================================================"
  read DUMMY
done

#Tally results and top 5 scorers at end
cat /quiz/*results | sort > /quiz/totalresults
for PARTICIPANT in $(ls /quiz/participants); do
  echo -e "$PARTICIPANT: $(grep $PARTICIPANT /quiz/totalresults | wc -l) correct" >>/quiz/scores
done
echo -e "========================================================"
echo -e "                     TOP 5 SCORES"
echo -e "========================================================\n"
sort -rk 2 /quiz/scores | head -5 | tee /quiz/top5scores
echo -e "\n========================================================"
read DUMMY

#Archive results, delete /quiz directory, and remove quiz user account
echo -e "Press Enter to archive and remove all results and the quiz$$ user account"
read DUMMY
tar -zcvf /root/quiz-$(date +%F).tar.gz /quiz
rm -Rf /quiz
killall -u quiz$$
userdel -r quiz$$
