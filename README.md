# Kahoot-like quizzer made with BASH scripts and accessed via SSH

## Overview:
To keep things simple, both the presenter and participants connect using SSH to a single Linux server. Quiz questions and answers are recorded in `quiztemplate.json`, participant answers are stored in local files (the UNIX way), and all quiz functionality is provided by two BASH scripts: `presenter.sh` run by the presenter, and `participant.sh` (which is run instead of BASH upon SSH login).

![Layout](https://github.com/jasoneckert/SSHquiz/blob/main/docs/layout.png?raw=true)

## Why does this exist?
I recently did a Linux trivia Kahoot at KW-LUG (https://kwlug.org/) but using a slide deck presented via BigBlueButton (https://bigbluebutton.org/) instead of Kahoot because we practice open sourcery. I originally played around with making a web service based alternative to Kahoot that is more interactive than our slide deck approach in December 2022, but got distracted by other projects. John Steel (https://github.com/BlackthornYugen) suggested that the whole thing can be done with just shell scripts and files (the UNIX way), which is very much appropriate for Linux people that attend a LUG ;-)

## Instructions:
On any Linux server (container, VM, bare metal, IoT):
- Copy `participant.sh` to the `/bin` directory
- Copy `presenter.sh` to the `/root` directory
- Copy `quiztemplate.json` to the `/root` directory

Prior to the presentation, modify the sample contents of `/root/quiztemplate.json` to add your questions.

During an existing video presentation (e.g., BigBlueButton, MS Teams, Zoom), the presenter will connect to the Linux server using SSH, switch to `/root` and execute the `presenter.sh` script, which:
- Creates a temporary user and password that can be shared with participants on the video presentation for SSH connectivity
- Sets up the directories used to record participant results
- Presents the questions in `/root/quiztemplate.json` to the participants until no more questions are left
- Displays answer and question statistics following each question, as well as the top 5 scorers at the end
- Archives results, deletes all quiz files and directories, and removes the temporary user at quiz completion

![Presenter1](https://github.com/jasoneckert/SSHquiz/blob/main/docs/presenter1.png?raw=true)

![Presenter2](https://github.com/jasoneckert/SSHquiz/blob/main/docs/presenter2.png?raw=true)

After participants SSH into the Linux server using the temporary user credentials provided by the presenter, they choose their handle and answer quiz questions:

![Participants](https://github.com/jasoneckert/SSHquiz/blob/main/docs/participants.png?raw=true)

