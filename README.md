# Kahoot-like quizzer made with BASH scripts and accessed via SSH

To keep things simple, both the presenter and participants connect using SSH to a single Linux server. All quiz answers are stored in local files (the UNIX way), and all quiz functionality is provided by two BASH scripts: `presenter.sh` run by the presenter, and `participant.sh` (which is run instead of BASH upon SSH login).

![Layout](https://github.com/jasoneckert/SSHquiz/blob/main/docs/layout.png?raw=true)

## Instructions:
On any Linux server (container, VM, bare metal, IoT):
- Copy `participant.sh` to the `/bin` directory
- Copy `presenter.sh` to the `/root` directory

During an existing video presentation (e.g., BigBlueButton, MS Teams, Zoom), the quiz presenter will connect to the Linux server using SSH, switch to `/root` and execute `presenter.sh` - this script:
- Creates a temporary user and password that can be shared with participants on the video presentation for SSH connectivity
- Sets up the directories used to record participant results
- Starts the quiz and displays questions (shown below)
- Archives results, deletes all quiz files and directories, and removes the temporary user

![Presenter](https://github.com/jasoneckert/SSHquiz/blob/main/docs/presenterscreen.png?raw=true)

After participants SSH into the Linux server using the temporary user credentials provided by the presenter, they choose their handle and answer quiz questions:

![Participants](https://github.com/jasoneckert/SSHquiz/blob/main/docs/participantscreen.png?raw=true)

