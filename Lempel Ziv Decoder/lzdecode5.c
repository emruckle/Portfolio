// Lempel Ziv Decoder by Emma Ruckle
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

//code adapted from in class lab                                                                              
//makes a copy of a given char pointer and appends a character                                                                                
char * makeCopyandAppend(char* str, char c) {
  char toAppend[2];
  char * copy = malloc(strlen(str) + 2);
  strcpy(copy, str);
  toAppend[0] = c;
  toAppend[1] = '\0';
  strcat(copy, toAppend);
  return copy;
}

//code given to us in assignment instructions                                                                                                 
//converts two chars to an int                                                                                                                
int convertCharsToInt(char char1, char char2) {
  return ((unsigned char) char1)
    + ( ((unsigned char) char2) << 8);
}

int main(int argc, char *argv[]) {
  char fileName[100];
  FILE *filep;
  int i;
  char c1;
  char c2;

  //display syntax if no arguments passed on command line                                                                                     
  if (argc <= 1) {
    printf("Syntax: %s filename\n", argv[0]);
    return -1;
  }

  //if an argument is passed, it must be a file name                                                                                          
  strcpy(fileName, argv[1]);

  //open the file                                                                                                                             
  filep = fopen(fileName, "r");

  //initialze the dictionary + d_cap counter                                                                                                  
  char **dict_arr;
  //max number of entries the dict can hold at its current size                                                                               
  int d_cap = 50;
  dict_arr = malloc(sizeof(char *) * 50);
  if (dict_arr == NULL) {
    printf("Malloc error.");
    return -1;
  }

  //initalize the current dictionary size counter                                                                                             
  int d_size = 0;

  //read the message                                                                                                                          
  if (filep != NULL) {
    while(fscanf(filep, "%c%c", &c1, &c2) != EOF) {
      // if the size is equal to the cap, need to realloc and update the cap                                                                  
      if (d_size == d_cap) {
        dict_arr = realloc(dict_arr, sizeof(char *) * (d_cap + 50));
        if (dict_arr == NULL) {
          printf("Realloc error.");
          return -1;
        }
        d_cap += 50;
      }
      i = convertCharsToInt(c1, c2);
      //if i is 0, need to malloc 2 chars worth of space in correct dictionary index                                                          
      //assign i and a null character to those two spots                                                                                      
      if (i == 0) {
        fscanf(filep, "%c", &c1);
        dict_arr[d_size + 1] = malloc(sizeof(char) * 2);
        dict_arr[d_size + 1][0] = c1;
        dict_arr[d_size + 1][1] = '\0';
        printf("%c", c1);
        d_size++;
      }
      else {
        //if i is not 0, need to use makeCopyandAppend to make a copy of the entry at index i and append new char                             
        //malloc length of the copy + 1 so there is space for the copy and null character                                                     
        int index = i;
        fscanf(filep, "%c", &c1);
        char * copy = makeCopyandAppend(dict_arr[index], c1);
        dict_arr[d_size + 1] = malloc(strlen(copy) + 1);
        dict_arr[d_size + 1] = copy;
        printf("%s", dict_arr[d_size+1]);
        d_size++;
      }
    }
  }
  for (i = 0; i < d_cap; i++) {
    free(dict_arr[i]);
  }
  free(dict_arr);
  return 0;
}