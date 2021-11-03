# COMP30020-assignment2
Assignment 2 for COMP30020 - Declarative Programming. A two player logical guessing game solver similar to Battle Ships written in Haskell

# Overview

The program implements both the hider and searcher parts of a two player logical guessing game

The two player logical guessing game is a simplified version of the game of Battleship and is played on a 4*8 grid.it involves a searcher trying to guess the locations of three battleships hidden by the hider, and the game continues till the guesser guesses the exact locations of the three hidden ships in a single guess. After each guess the guesser receives the a feedback about his guess from the hider which is in the form of three numbers, which are the number of ships exactly located, the number of guesses that were exactly one space away from a ship and the number of guesses that were exactly two spaces away from a ship

Locations on the board take the form of an upper case alphabet from A to H, denoting the column and a digit from 1 to 4 denoting the row. 

For example,the upper left location is A1 and the lower right location is H4

the guesser makes an initial guess which is a fixed guess, and then from the feedback recieved from the initial guess, the possible next guesses are pared to be consistent with the feedback from previous guess.

The next guess made is the best guess which is the one with lowest average remaining candidates, which means that if that guess were incorrect it would on average take the average number of guesses for reaching the correct guess.

