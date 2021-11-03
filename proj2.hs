-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- File     : Proj2.hs
-- Author   : Kian Dsouza
-- Login id : KIAND
-- Date     : 17th October, 2021.

-- Purpose  : Project 2 Submission in Haskell, Declarative Programming.

-- The program implements both the hider and searcher parts of a 
-- two player logical guessing game

-- the two player logical guessing game is a simplified version of the game
-- of Battleship and is played on a 4*8 grid.
-- it involves a searcher trying to guess the locations of three battleships
-- hidden by the hider, and the game continues till the guesser guesses the 
-- exact locations of the three hidden ships in a single guess
-- After each guess the guesser receives the a feedback about his guess from
-- the hider which is in the form of three numbers, which are the number of 
-- ships exactly located, the number of guesses that were exactly one space 
-- away from a ship and the number of guesses that were exactly two spaces away
-- from a ship

-- locations on the board take the form of an upper case alphabet from A to H 
-- denoting the column and a digit from 1 to 4 denoting the row. 
-- for example,the upper left location is A1 and the lower right location is H4

-- the guesser makes an initial guess which is a fixed guess, and then from the
-- feedback recieved from the initial guess, the possible next guesses are  
-- pared to be consistent with the feedback from previous guess.

-- the next guess made is the best guess which is the one with lowest average 
-- remaining candidates, which means that if that guess were incorrect it 
-- would on average take the average number of guesses for reaching the 
-- correct guess

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

module Proj2 (Location, toLocation, fromLocation, feedback,
              GameState, initialGuess, nextGuess) where
              
import Data.List

-- |Location is a String representing the ship's location on the grid
data Location = Location String

instance Show Location where show (Location str) = str
instance Eq Location where (Location s1) == (Location s2) = (s1 == s2)

-- |GameState represents a list of the remaining possible guesses, which is 
-- pared down each time feedback is recieved for a guess
type GameState = [[Location]]

-- |score is a tuple of three Ints which represent the number of correct 
-- locations, the number of guesses exactly one square away from away from 
-- a ship, and the number exactly two squares away respectively
type Score = (Int, Int, Int)

-- |gives back the two character string version of the specified location.
-- for a Location loc, the function would return Just loc
fromLocation :: Location -> String
fromLocation location = show location 

-- |gives Just the Location named by the string, or Nothing if the string 
-- is not a valid location 
toLocation :: String -> Maybe Location 
toLocation location
    | location `elem` validPos = Just (Location location)
    | otherwise = Nothing
    where 
        validPos = [[x,y] | x <- ['A'..'H'],y <- ['1'..'4']]

-- |takes a target and a guess respectively and returns the appropriate 
-- feedback score, it does this by calling the guessScore function for each 
-- individual guess location and list of the targets, and then sums up 
-- each individual score to get the totalScore
feedback :: [Location] -> [Location] -> (Int, Int, Int)
feedback target (loc1:loc2:loc3:[]) = totalScore
    where 
        (s1X,s1Y,s1Z) = guessScore target loc1
        (s2X,s2Y,s2Z) = guessScore target loc2
        (s3X,s3Y,s3Z) = guessScore target loc3
        totalScore = (s1X+s2X+s3X,s1Y+s2Y+s3Y,s1Z+s2Z+s3Z)

-- |takes the target locations as a list and a guess location made by the 
-- searcher and returns a Score
guessScore :: [Location] -> Location -> Score
guessScore target guess
    | closestDistance == 0 = (1,0,0)
    | closestDistance == 1 = (0,1,0)
    | closestDistance == 2 = (0,0,1)
    | otherwise = (0,0,0)
    where 
        closestDistance = minimum guessDistances
        guessDistances = map (findDistance guess) target      

-- |takes a target ship location and a guess location respectively, and 
-- returns an Int by comparing the distance between the two locations
findDistance :: Location -> Location -> Int
findDistance target guess = max x y
    where 
        x = abs (fromEnum (head (fromLocation target)) - 
            fromEnum (head (fromLocation guess)))
        y = abs (fromEnum (last (fromLocation target)) - 
            fromEnum (last (fromLocation guess)))


-- |generates and returns a pair of the initial guess and the game state, which 
-- is a list of all the possible guesses except the initial guess
-- The initial guess is chosen and fixed to a specific guess which 
-- decreases the number of possible guesses, making the program more efficient
-- and faster
initialGuess :: ([Location],GameState)
initialGuess = (guess, initialState)
    where
        guess = map Location ["A1", "G3", "H3"]
        allguesses = [map Location [[c1,r1],[c2,r2],[c3,r3]] | c1 <- ['A'..'H'],
                    c2 <- ['A'..'H'], c3 <- ['A'..'H'], r1 <- ['1'..'4'],
                    r2 <- ['1'..'4'], r3 <- ['1'..'4'],
                    eliminateDuplitcates [c1,r1] [c2,r2] &&
                    eliminateDuplitcates [c2,r2] [c3,r3]]
        initialState = allguesses \\ [guess]


-- |takes two strings as input and returns true if the column value of the 
-- second string is greater than that of the first string, and if the column 
-- values are same, then the row value of the second must be greater than that 
-- of the first string, else it returns false
eliminateDuplitcates :: String -> String -> Bool
eliminateDuplitcates [c1,r1] [c2,r2] = c2val > c1val || 
                     (c2val == c1val && r2val > r1val)
    where
        c1val = fromEnum c1
        c2val = fromEnum c2
        r1val = fromEnum r1
        r2val = fromEnum r2

-- |takes as input a pair of the previous guess and the game state, and the 
-- score recieved as feedback to the previous guess 
-- it pares the current game state  with possible guesses which are consistent 
-- with the feedback recieved from the previous guesses made 
-- these possible guesses are then passed to the bestGuess function, where 
-- each possible guess is made as a target, and the average number of 
-- remaining guesses is calculated for if the target were to be used as an 
-- actual guess, and the target with lowest average is used 
-- is return by the best guess function, which becomes the players nextguess
nextGuess :: ([Location],GameState) -> (Int,Int,Int) -> ([Location],GameState)     
nextGuess (prevGuess, currentState) prevScore = (nextGuess, nextState)
    where
        nextState = [ state | state <- currentState , 
                    feedback state prevGuess == prevScore] \\ [prevGuess]
        nextGuess = bestGuess nextState

-- |takes as input the game state as input and generates and returns the best 
-- possible guess as list of Locations. It finds the best guess by calculating 
-- the guess with the lowest average remaining candidate guesses if that 
-- particular guess was incorrectly made, it therefore pares the 
-- possible guesses to lowest number achievable 
bestGuess :: GameState -> [Location]
bestGuess state =  bestguess
    where 
        targetCandidates = [(target,avgScore)|target <- state, 
                            let scores  = [score | guess <- state \\ [target], 
                                          let score = feedback target guess],
                            let avgScore = getAvgScore scores]        
        minAvg = minimum (map snd targetCandidates)
        bestguess = fst $ head [ x | x <- targetCandidates, snd x == minAvg]                  

-- |takes as input a list of Scores which is the feedback of each guess 
-- currently in the GameState with one of the guess' made as the target, and   
-- returns a Double which is the average number of remaining candidates for 
-- that target guess
getAvgScore :: [Score] -> Double
getAvgScore scores
    = sum [numCandidates * numCandidates
          | score <- group scores
          , let numCandidates = (fromIntegral . length) score]/ totalCandidates
    where
        totalCandidates = (fromIntegral . length) scores

