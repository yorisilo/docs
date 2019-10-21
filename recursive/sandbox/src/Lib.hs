module Lib
  ( someFunc
  , positive
  ) where

someFunc :: IO ()
someFunc = putStrLn "someFunc"

positive :: [Int] -> [Int] -> [Int]
positive [] acc = acc
positive (x:xs) acc
  | x > 0     = positive xs (acc ++ [x])
  | otherwise = positive xs acc


fib :: Int -> Int
fib n
  | n == 0 || n == 1 = 1
  | otherwise        = fib (n-1) + fib (n-2)

-- acc ver
fib' :: Int -> Int -> Int -> Int
fib' n x acc
  | n == 0 = 1
  | x == 1 = acc
  | otherwise = fib' (n-1) acc (x + acc)


-- cps ver
fib'' :: Int -> (Int -> Int) -> Int
fib'' 0 cont = cont 1
fib'' 1 cont = cont 1
-- fib'' n cont =
