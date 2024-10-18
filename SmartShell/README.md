# Smart Shell

This project implements a custom Unix-like shell that allows users to execute basic commands with added support for input/output redirection and command piping. The Smart Shell supports essential shell operations such as command execution, file redirection, and piping between commands, while also featuring custom commands like printing haikus and ASCII art. The shell runs in an infinite loop, accepting and executing commands until the user types quit.

Technologies Used: C
Description
- Command execution: Supports executing standard Unix commands by forking child processes and using the execvp system call to run commands
- Input/output redirection: Handles redirection of both input (<) and output (>) to/from files
- Command piping: Implements piping (|) between commands, allowing the output of one command to serve as the input to another.
- File handling: Integrates file I/O using system calls like open, close, and dup2 for redirection.
- Custom functionality: Includes unique features like printing random haikus and a heart-shaped ASCII art design.

Skills Demonstrated: Backend development, C programming, file I/O, concurrency management
