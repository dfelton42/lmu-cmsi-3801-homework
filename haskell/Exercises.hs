module Exercises
    ( change,
    -- put the proper exports here
    firstThenApply,
    powers,
    meaningfulLineCount,
    volume,
    surfaceArea, 
    Shape(Box,Sphere),
    BST(Empty),
    size,
    insert,
    inorder,
    contains
    ) where

import qualified Data.Map as Map
import Data.Text (pack, unpack, replace)
import Data.List(isPrefixOf, find)
import Data.Char(isSpace)

change :: Integer -> Either String (Map.Map Integer Integer)
change amount
    | amount < 0 = Left "amount cannot be negative"
    | otherwise = Right $ changeHelper [25, 10, 5, 1] amount Map.empty
        where
          changeHelper [] remaining counts = counts
          changeHelper (d:ds) remaining counts =
            changeHelper ds newRemaining newCounts
              where
                (count, newRemaining) = remaining `divMod` d
                newCounts = Map.insert d count counts

-- Write your first then apply function here
firstThenApply :: [a] -> (a -> Bool) -> (a -> b) -> Maybe b
firstThenApply xs p f = fmap f (find p xs)
  where
    find _ [] = Nothing
    find p (y:ys)
      | p y       = Just y
      | otherwise = find p ys


-- Write your infinite powers generator here
powers :: (Integral a) => a -> [a]
powers base = map (base^) [0..]

-- Write your line count function here
meaningfulLineCount :: FilePath -> IO Int
meaningfulLineCount filePath = do 
  document <- readFile filePath
  let allWiteSpace = all isSpace
      trimStart = dropWhile isSpace
      isMeaningful line = 
        not (allWiteSpace line) &&
        not ("#" `isPrefixOf` (trimStart line))
  return $ length $ filter isMeaningful $ lines document
  
-- Write your shape data type here
data Shape 
  = Sphere Double 
  | Box Double Double Double
   deriving (Eq,Show);

volume :: Shape -> Double  
volume (Sphere r) = (4 / 3) * pi * r^3 
volume (Box l w h) = l * w * h  

   -- do the same for surface area
surfaceArea :: Shape -> Double
surfaceArea (Sphere r) = 4  * pi * r^2
surfaceArea (Box l w h) = ((2*l * w)+(2*l * h)+(2*h* w))


-- Write your binary search tree algebraic type here
data BST a 
  = Empty 
  | Node a (BST a) (BST a)

size :: BST a -> Int
size Empty = 0
size (Node _ left right) = 1 + size left + size right

contains :: Ord a => a -> BST a -> Bool
contains _ Empty = False
contains value (Node nodeValue left right)
  | value == nodeValue = True
  | value < nodeValue  = contains value left
  | otherwise          = contains value right

inorder :: BST a -> [a]
inorder Empty = []
inorder (Node value left right) = inorder left ++ [value] ++ inorder right

insert :: Ord a => a -> BST a -> BST a
insert value Empty = Node value Empty Empty
insert value (Node nodeValue left right)
    | value < nodeValue = Node nodeValue (insert value left) right
    | value > nodeValue = Node nodeValue left (insert value right)
    | otherwise = Node nodeValue left right  

instance Show a => Show (BST a) where
    show Empty = "()"
    show (Node value Empty Empty) = "(" ++ show value ++ ")"  
    show (Node value left right) =
        let leftStr = show left
            rightStr = show right
        in case (leftStr, rightStr) of
            ("()", "()") -> "(" ++ show value ++ ")"
            ("()", _)    -> "(" ++ show value ++ rightStr ++ ")"
            (_, "()")    -> "(" ++ leftStr ++ show value ++ ")"
            _            -> "(" ++ leftStr ++ show value ++ rightStr ++ ")"






