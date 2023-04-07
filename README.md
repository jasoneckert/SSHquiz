# Kahoot-like quizzer made with BASH scripts and accessed via SSH

To keep things simple, everyone connects using SSH to a single Linux server, everything is stored in a file (the UNIX way), and all functionality is provided by two BASH scripts.

![Layout](https://github.com/jasoneckert/SSHquiz/blob/main/docs/layout.png?raw=true)

## Instructions:
On any Linux server (container, VM, bare metal, IoT):
- Copy `participant.sh` to the `/bin` directory
- Copy `quiz.sh` to the `/root` directory

During an existing video presentation (e.g., BigBlueButton, MS Teams, Zoom), the quiz presenter will connect to the Linux server using SSH, switch to `/root` and execute `quiz.sh` - this script will set up a temporary user and password that can be shared with participants on the video presentation.

Next, the presenter will share their `quiz.sh` terminal window with the audience to display questions:

![Presenter](https://github.com/jasoneckert/SSHquiz/blob/main/docs/presenterscreen.png?raw=true)

Participants will SSH into the Linux server using the temporary user credentials provided by the presenter, choose a handle, and answer quiz questions:

![Participants](https://github.com/jasoneckert/SSHquiz/blob/main/docs/participantscreen.png?raw=true)

