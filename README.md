# COMP30020-assignment2
Assignment 2 for COMP30020 - Declarative Programming. A two player logical guessing game solver similar to Battle Ships written in Haskell

# Overview

The program implements both the hider and searcher parts of a two player logical guessing game

The two player logical guessing game is a simplified version of the game of Battleship and is played on a 4*8 grid.it involves a searcher trying to guess the locations of three battleships hidden by the hider, and the game continues till the guesser guesses the exact locations of the three hidden ships in a single guess. After each guess the guesser receives the a feedback about his guess from the hider which is in the form of three numbers, which are the number of ships exactly located, the number of guesses that were exactly one space away from a ship and the number of guesses that were exactly two spaces away from a ship

Locations on the board take the form of an upper case alphabet from A to H, denoting the column and a digit from 1 to 4 denoting the row. 

For example,the upper left location is A1 and the lower right location is H4

the guesser makes an initial guess which is a fixed guess, and then from the feedback recieved from the initial guess, the possible next guesses are pared to be consistent with the feedback from previous guess.

The next guess made is the best guess which is the one with lowest average remaining candidates, which means that if that guess were incorrect it would on average take the average number of guesses for reaching the correct guess.

# Running the game
Compile using ghc -O2 --make Main, to run test. for example ./Main would search for the target "F1 D2 G4". It will then use the Proj2 module to guess the target; the output will look something like:

```
Searching for target F1 D2 G4
Your guess #1:  A1 G3 H3
    My answer:  (0,2,0)
Your guess #2:  A4 B4 H4
    My answer:  (0,1,1)
Your guess #3:  D4 E4 G4
    My answer:  (1,0,2)
Your guess #4:  D1 D2 G4
    My answer:  (2,1,0)
Your guess #5:  D2 E1 G4
    My answer:  (2,1,0)
Your guess #6:  D2 E2 G4
    My answer:  (2,1,0)
Your guess #7:  D2 F1 G4
    My answer:  (3,0,0)
You got it in 7 guesses!
```
