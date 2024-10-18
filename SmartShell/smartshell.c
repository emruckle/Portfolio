//----------------------------
// Name: Emma Ruckle
// Date: Spring 2024
// Class: Operating Systems
// Assignment: Smart Shell
//----------------------------

#include <string.h>    /* for strcpy and strtok */
#include <unistd.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <fcntl.h>

#define MAX_ARGV  10 /* maximum number of command tokens */
#define MAX_CMD   80 /* maximum length of command */

void tokenize_cmd (char * cmd, int max, char * argv[])
/* Input:  cmd is the command to be tokenized
 *         max is the maximum number of tokens allowed  
 * Output: argv is the array of tokens (command arguments) 
 */
{
    int num_args = 0;           /* number of arguments (tokens) in cmd */

    if(cmd == NULL) return;     /* nothing to do */

    /* Tokenize the command */
    argv[0] = strtok(cmd, " \n");
    while((num_args < max) && (argv[num_args] != NULL))
    {
       num_args++;
       argv[num_args] = strtok(NULL, " \n");
    }
}

void execute_cmd(char * cmd)
{
    char * argv[MAX_ARGV];  /* array of command arguments*/
    char cmd_copy[MAX_CMD]; /* buffer to store local copy of cmd*/

    /* Make a local copy of the command */
    if(cmd == NULL) return; /* nothing to do */
    strcpy(cmd_copy, cmd);

    /* Tokenize the command */
    tokenize_cmd(cmd_copy, MAX_ARGV, argv);

    /* Fork a child to execute the command 
     *   - if execvp fails, print an error message and exit
     */
    /* Parent waits for child to finish execution */
    int ret = fork();
    if (ret < 0) {
      printf("Fork error \n");
      exit(1);
    }
    if (ret == 0) {
      execvp(argv[0], argv);
      // if there was an exec error, exit
      printf("Exec error \n");
      exit(1);
    }
    else {
      // parent wait for child
      wait(NULL);
    }
}

void execute_output_redirect_cmd(char * cmd, char * fname) {
      char * argv[MAX_ARGV];  /* array of command arguments*/
      char cmd_copy[MAX_CMD]; /* buffer to store local copy of cmd*/

       /* Make a local copy of the command */
      if(cmd == NULL) return; /* nothing to do */
      strcpy(cmd_copy, cmd);

       /* Tokenize the command */
      tokenize_cmd(cmd_copy, MAX_ARGV, argv);

      // fork a child
      int ret = fork();
      // check if fork was successful, if it wasn't.. exit
      if (ret < 0) {
            printf("Fork error \n");
            exit(1);
      }
      // if child
      if (ret == 0) {
            // open file, can read from and written to, if it doesn't exist create it
            int fd = open(fname, O_RDWR | O_CREAT);
            // make sure opening file was successful
            if (fd == -1) {
                  printf("File error \n");
                  exit(1);
            }
            // redirect standard output to the file
            dup2(fd, 1);
            // close the file descriptor fd
            int ret = close(fd);
            // check if close was successful
            if (ret == -1) {
                  printf("File error \n");
                  exit(1);
            }
            // execute the command
            execvp(argv[0], argv);
            // if exec fails, exit
            printf("Exec error \n");
            exit(1);
      }
      else {
      wait(NULL);
      }
}

void execute_input_redirect_cmd(char * cmd, char * fname) {
      char * argv[MAX_ARGV];  /* array of command arguments*/
      char cmd_copy[MAX_CMD]; /* buffer to store local copy of cmd*/

       /* Make a local copy of the command */
      if(cmd == NULL) return; /* nothing to do */
      strcpy(cmd_copy, cmd);

       /* Tokenize the command */
      tokenize_cmd(cmd_copy, MAX_ARGV, argv);

      // parent forks a child
      int ret = fork();
      // check that fork was succesful, exit if it wasn't
      if (ret < 0) {
            printf("Fork error \n");
            exit(1);
      }
      // if child
      if (ret == 0) {
            // open file, read only
            int fd = open(fname, O_RDONLY);
            // check that open was successful, exit if it wasn't
            if (fd == -1) {
                  printf("File error \n");
                  exit(1);
            }
            // redirect standard input to the file
            dup2(fd, 0);
            // close the file descriptor fd
            int ret = close(fd);
            // check that close was successful, exit if not
            if (ret == -1) {
                  printf("File error \n");
                  exit(1);
            }
            // execute the command, exit if exec is not successful
            execvp(argv[0], argv);
            printf("Exec error \n");
            exit(1);
      }
      else {
            // parent waits for child
            wait(NULL);
      }
}

void execute_piped_cmd (char * cmd1, char * cmd2) {
      // check if cmd1 or cmd2 is NULL
      if (cmd1 == NULL || cmd2 == NULL) {
            return;
      }

      // dealing with cmd1
      char * cmdargv1[MAX_ARGV];  /* array of command arguments*/
      char cmd1_copy[MAX_CMD]; /* buffer to store local copy of cmd*/
      /* Make a local copy of the command */
      strcpy(cmd1_copy, cmd1);
      /* Tokenize the command */
      tokenize_cmd(cmd1_copy, MAX_ARGV, cmdargv1);

      // dealing with cmd2
      char * cmdargv2[MAX_ARGV];  /* array of command arguments*/
      char cmd2_copy[MAX_CMD]; /* buffer to store local copy of cmd*/
      /* Make a local copy of the command */
      strcpy(cmd2_copy, cmd2);
      /* Tokenize the command */
      tokenize_cmd(cmd2_copy, MAX_ARGV, cmdargv2);

      // pipe
      int ret, p[2];
      // create pipe
      ret = pipe(p);
      // check to see if pipe was successful
      if (ret == -1) {
            // if it was unsucessful.. exit
            exit(1);
      }

      // parent forks two children
      // parent forks first child
      ret = fork();
      // check that fork was succesful, exit if it wasn't
      if (ret < 0) {
            printf("Fork error \n");
            exit(1);
      }
      else if (ret != 0) {
            // parent forks a second child
            ret = fork();
            // check that fork was successful, exit if it wasn't
            if (ret < 0) {
                  printf("Fork error \n");
                  exit(1);
            }
            if (ret != 0) {
                  // if parent, close read and write ends of the pipe
                  // wait for child one and child two
                  close(p[0]);
                  close(p[1]);
                  wait(NULL);
                  wait(NULL);
            }
            else {
                  // second child
                  // close write end of the pipe
                  close(p[1]);
                  // redirect standard input to read end of the pipe
                  dup2(p[0], 0);
                  // execute cmd 
                  execvp(cmdargv2[0], cmdargv2);
                  // if exec fails, close read end of pipe
                  printf("Exec error \n");
                  close(p[0]);
                  // should i exit???
                  exit(1);
            }
      }
      else {
            // first child
            // close read end of the pipe
            close(p[0]);
            // redirect standard ouput to write end of the pipe
            dup2(p[1], 1);
            // execute cmd
            execvp(cmdargv1[0], cmdargv1);
            // if exec fails, close the write end of the pipe
            printf("Exec error \n");
            close(p[1]);
            // should i exit???
            exit(1);
      }
}

/* Prints a randomly selected haiku (1 of 3) */
void haiku() {
      // sets the seed
      srand(time(NULL));
      // gets a random int between 0 and 2
      int randomNum = rand() % 3;
      if (randomNum == 0) {
            printf("Running strings of code \n Together we write programs \n We code the future \n");
      }
      if (randomNum == 1) {
            printf("Duck is a hamster \n She climbs the walls so speedy \n Yes Duck slay go Duck \n");
      }
      if (randomNum == 2) {
            printf("Trolls Two is the best \n Almost as good as Trolls Three \n Oh, I feel the rush \n");
      }
}

/* Prints an asterisk heart */
void prettyPrint() {
      printf("    ****      **** \n");
      printf("   *******  ******* \n");
      printf("  ****************** \n");
      printf("   **************** \n");
      printf("     ************ \n");
      printf("       ******** \n");
      printf("	 **** \n");
      printf("	  ** \n");
}

int main()
{
    /* Step 1:
     *   Add calls to execute_cmd here to test it out. 
     *   Example: execute_cmd("ps -f");
     *   ... other commands you wish to try here ...
     */
      // testing!
      // execute_cmd("ps -f");
      // execute_cmd("mkdir bbb");
      // execute_cmd(man system);
      // execute_output_redirect_cmd("ls", "ls2.txt");
      // ls > ls2.txt
      // return 0;
    /*
     * Step 2: 
     *   Add code for your smart shell
     *   Read and process commands in an infinite loop
     *   Exit when the user types "quit" 
     */
      while (1) {
            printf("seashell$ ");
            char args[MAX_CMD];
            // get user input
            fgets(args, MAX_CMD, stdin);
            // checks user input for an instance of '>', '<' or '|'
            char* out = strchr(args, '>');
            char* in = strchr(args, '<');
            char* pipe = strchr(args, '|');
            // if '>', '<', or '|' are present...
            if (out != NULL || in != NULL || pipe != NULL) {
                  if (out != NULL) {
                        // if '>' was present
                        // pointer arithmetic to find index of '>'
                        int outPos = (int)(out - args);
                        // copy of args up to index of symbol - 1 (to account for a space before the symbol)
                        char *outCmd = malloc(sizeof(char *) * (outPos - 1) + 1);
                        char *outFile = malloc(sizeof(char *) * (strlen(args) - (outPos + 2) + 1));
                        strncpy(outCmd, args, outPos - 1);
                        // manually add null terminating char
                        outCmd[outPos - 1] = '\0';
                        // copy of args from index of the symbol + 2 (to account for symbol and space after) to the end of the string
                        strncpy(outFile, (args + outPos + 2), (strlen(args) - (outPos + 2)));
                        // manually add null terminating character
                        outFile[(strlen(args) - (outPos + 2) + 1) - 2] = '\0';
                        // pass in newCmd and file strings
                        execute_output_redirect_cmd(outCmd, outFile);
                        // free memory
                        free(outCmd);
                        free(outFile);
                  }
                  if (in != NULL) {
                        // if '<' was present
                        // pointer arithmetic to find index of '<'
                        int inPos = (int)(in - args);
                        char *inCmd = malloc(sizeof(char *) * (inPos - 1) + 1);
                        char *inFile = malloc(sizeof(char *) * (strlen(args) - (inPos + 2) + 1));
                        strncpy(inCmd, args, inPos - 1);
                        inCmd[inPos - 1] = '\0';
                        strncpy(inFile, (args + inPos + 2), (strlen(args) - (inPos + 2)));
                        inFile[(strlen(args) - (inPos + 2) + 1) - 2] = '\0';
                        execute_input_redirect_cmd(inCmd, inFile);
                        free(inCmd);
                        free(inFile);
                  }
                  if (pipe != NULL) {
                        // if '|' was present
                        // pointer arithmetic to find index of '|'
                        int pipePos = (int)(pipe - args);
                        char *pCmd1 = malloc(sizeof(char *) * (pipePos - 1) + 1);
                        char *pCmd2 = malloc(sizeof(char *) * (strlen(args) - (pipePos + 2) + 1));
                        strncpy(pCmd1, args, pipePos - 1);
                        pCmd1[pipePos - 1] = '\0';
                        strncpy(pCmd2, (args + pipePos + 2), (strlen(args) - (pipePos + 2)));
                        pCmd2[(strlen(args) - (pipePos + 2) + 1) - 2] = '\0';
                        execute_piped_cmd(pCmd1, pCmd2);
                        free(pCmd1);
                        free(pCmd2);
            }     }
            // if input = quit, then exit
            else if (strncmp(args, "quit", 4) == 0) {
                  exit(1);
            }
            // if input = mem...
            else if (strncmp(args, "mem", 3) == 0) {
                  execute_cmd("free -m -t");
            }
            // if input = disk..
            else if (strncmp(args, "disk", 4) == 0) {
                  execute_cmd("df -h /dev/sda1");
            }
            // if input = haiku call haiku()
            else if (strncmp(args, "haiku", 4) == 0) {
                  haiku();
            }
            // if input = heart call prettyPrint()
            else if (strncmp(args, "heart", 5) == 0) {
                  prettyPrint();
            }
            // otherwise, execute the cmd
            else {
                  execute_cmd(args);
            }
      }
      return 0;
}
