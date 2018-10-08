-- Generate a random number given a range.
import System.IO.Unsafe
import System.Random
import Data.List

mazeSize = 5
wallIcon = '#'
maze = [['#', '#', '#', '#', '#'],
        ['#', ' ', ' ', ' ', 'E'],
        ['#', ' ', '#', '#', '#'],
        ['#', ' ', ' ', 'S', '#'],
        ['#', '#', '#', '#', '#']]

getRandomInteger :: (Int, Int) -> Int
getRandomInteger (a, b) = unsafePerformIO (randomRIO (a, b))

isValid :: (Int, Int) -> Bool
isValid (a, b) = (0 <= a) && (a < mazeSize) && (0 <= b) && (b < mazeSize) 

isAWall :: (Int, Int) -> Bool
isAWall (a, b) = (maze !! a) !! b == wallIcon

isExit :: (Int, Int) -> Bool
isExit (a, b) = isValid (a, b) && (maze !! a) !! b == 'E'

sumVectors :: (Num a) => (a, a) -> (a, a) -> (a, a)  
sumVectors (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

makeAMove :: (Int, Int) -> Char -> (Int, Int)
makeAMove (x, y) m =
    let move = getMove m
    in sumVectors (x, y) move

isValidMove :: (Int, Int) -> Bool
isValidMove (x, y) = isValid (x, y) && not (isAWall (x, y))

numOfWalls :: [[Char]] -> Int
--numOfWalls maze = sum [[1 | icon <- line, isAWall icon ]| line <- maze]
numOfWalls xxs = sum [sum [1 | x <- xs, x == '#' ]| xs <- xxs]

getMove 'U' = (-1, 0)
getMove 'D' = (1, 0)
getMove 'L' = (0, -1)
getMove 'R' = (0, 1)

randomMove :: Char
randomMove
    | num == 1 = 'U'
    | num == 2 = 'D'
    | num == 3 = 'L'
    | num == 4 = 'R'
    where
        num = getRandomInteger(1, 4)

randomMoves :: Int -> [Char]
randomMoves size = [randomMove | _ <- [1..size]]

cromossomeSize = mazeSize^2 - numOfWalls maze

data Individuo = Individuo {fitness :: Integer, moves :: [Char]} deriving (Show)

buildIndividuo :: Individuo
buildIndividuo = newIndividuo
                where
                    fitness = 10^6
                    moves = randomMoves cromossomeSize
                    newIndividuo = Individuo fitness moves

--Considerando uma população de 40 individuos
initPopulation :: [Individuo]
initPopulation = [ buildIndividuo | _ <- [1..40]]

calculateRecursive :: [Char] -> (Int, Int) -> Integer -> [(Int, Int)] -> Integer

calculateRecursive [] _ f _ = f
        
--De acordo com o feito em C++, dá pra simplificar eu acho
calculateRecursive (m:ms) (x, y) f visited = 
        let newPos = makeAMove (x, y) m
        in if isExit newPos
            then f*10^6
            else if isValidMove newPos
            then if newPos `elem` visited 
                then calculateRecursive (ms) newPos (f-500) visited
                else calculateRecursive (ms) newPos (f-200) (newPos:visited)
            else if newPos `elem` visited 
                then calculateRecursive (ms) (x, y) (f-700) visited
                else calculateRecursive (ms) (x, y) (f-400) (newPos:visited)

calculateFitnessIndividual :: Individuo -> Integer
calculateFitnessIndividual ind = calculateRecursive (moves ind) (0, 0) (fitness ind) []
                
calculateFitness :: [Individuo] -> [Integer]
calculateFitness xs = [calculateFitnessIndividual x | x <- xs]

