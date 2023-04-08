#!/bin/bash
#Check for root access
#if [ $UID -ne 0 ]; then
#  echo -e "You must be root to run this script.\nSwitch to root (feel the power!) and try again."
#  exit 255
#fi
#if ! which chpasswd; then
#  echo -e "You must install the chpasswd command."
#  exit 255
#fi
#if ! which shuf; then
#  echo -e "You must install the shuf command."
#  exit 255
#fi

clear
echo -e "What is the host name or IP address of your Linux server?--> \c"
read SERVER
echo -e "\nPRESENTER INSTRUCTIONS (READ CAREFULLY):\nWhen you press Enter, the SSH username and password\nthat participants should use will be displayed.\n\nAt this point, share your terminal window in your presentation\nand advise users to SSH into the server using these credentials.\n\nWhen you are satisfied that everyone is connected, press Enter to\nstart the quiz and display the first question.\n\nNarrate the question and answers as needed. When you feel enough time has\npassed for participants to answer, press Enter to view the results.\n\nAfter viewing the results, press Enter to continue to the next question.\n\nREADY TO START? PRESS ENTER TO DISPLAY THE SSH CREDENTIALS"
mkdir -m 1777 /quiz
read DUMMY
useradd -m -s /bin/participant.sh quiz$$
PW=$(shuf -n 1 /usr/share/dict/words)
echo "quiz$$:$PW" | chpasswd
clear
echo -e "========================================================\n SSH server: $SERVER\n========================================================\n SSH username: quiz$$\n========================================================\n SSH password: $PW\n========================================================\n\n When everyone has connected, the presenter will press\n Enter to start the quiz and display the first question.\n\n========================================================"
read DUMMY

#Logic to display quiz question and create submission directory (put in function?)
#Work in progress...
clear
mkdir -m 1777 /quiz/1


