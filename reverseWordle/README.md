# Reverse Wordle (Wordle Solver)

This program implements a Reverse Wordle game, where the user selects a five-letter word, and the program endeavors to guess it within six attempts. Utilizing advanced data structures such as graphs, arrays, hashsets, and arraylists, the program efficiently narrows down possibilities and hones in on the correct word through a series of logical guesses and user feedback.

- Technologies Used: Java, Guava Library.
- Description: For more specific information about the components of the program and an example of its output, see below.
- Skills Demonstrated: Java Programming, algorithm development, data structures, user interaction, debugging and testing.

## Detailed Program Information and Example Ouput
The program is centered around the Guava MutableGraph data structure. We used this data structure so that we could efficiently hold information about the relationships among many pieces of data. This project filters through the list of all five-letter 
words in the English language in order to find a 
combination of five five-letter words which between them
contain 25 of the 26 letters in the English alphabet. 
The program then operates with user input to find an 
undisclosed five-letter word chosen by the user in 6 or 
fewer guesses. An example of how this user-interaction 
would function is shown below.

     Program: Pick a five-letter word, 
     but do not share it. I will attempt 
     to guess it. For each letter in my 
     guess, type "N" if it is not in the
     word, "Y" if it is in the word and 
     in the correct place, and "P" if it
     is in the word but not in the right
     place.
     Program: Is your word "word1"?
     User: PNNNN
     Program: Is your word "word2"?
     User: NNPNP
     Program: Is your word "word3"?
     User: NYNPN
     Program: Is your word "word4"?
     User: YYYYY
     Program: Hooray! I guessed your word 
     in 4 guesses. Play again?
     User: No.
     

## Phase One:
First, the program must read in the dictionary of 
five-letter words, creating a graph vertex for each. 
To save space in the graph, we can skip any word with 
repeated letters or more than one vowel (not including
y), since these would make it impossible for a group
of five words to span 25 letters. Once the verticies 
have all been added, the program should use a stacked 
for-each loop to compare verticies and add an edge 
between any two verticies which share no letters. 

## Phase Two:
A clique of size 5 will hold five five-letter words 
which span 25 letters between them. In this phase, the 
program will search through the graph to locate the 
first clique of size 5. The values of the verticies 
within that clique will be saved to be used as guesses
in phase three.

## Phase Three:
This part of the program interacts with the user to guess
a five-letter word of their choosing. The program will 
print out each guess, and for every letter of the guess,
the user will respond with one of the following:

"Y" if the letter is correct \
"P" if the letter is in the word \
"N" if the letter is not in the word.

For example, if the user's word was "hello" and the 
program's guess was "bolds", the user would respond 
"NPYNN"

The program will contain a built-in process to handle 
misformatted user input. 

The program will make five guesses using the 
predetermined guess words. If the user responds with 
"YYYYY" at any point before the sixth guess, the program
will stop guessing and consider the game finished. 
Otherwise, it will continue through all of the 
predetermined guesses in order to gather the list of the
five letters that are in the final word. Then, it will 
search through the full dictionary, collecting all 
five-letter words composed of the given five letters. 
Finally, it will compare these words against the letter
location restrictions given by the user and guess the first
found word that fits all of the given criteria. 

If multiple words fit the criteria, it may not necessarily
guess correctly. Most of the time, though, this will not be
an issue, and the program should be able to correctly guess
any five-letter word in only six guesses. 

After the program wins or loses the game, the user has the option
to play again.
