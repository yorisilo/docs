module MyLib
  ( someFunc,
    positive,
  )
where

someFunc :: IO ()
someFunc = putStrLn "someFunc"

fact :: Int -> Int
fact 0 = 1
fact n = n * (fact $ n - 1)

fib :: Int -> Int
fib n
  | n == 0 || n == 1 = 1
  | otherwise = fib (n - 1) + fib (n - 2)

-- acc ver
fib' :: Int -> Int -> Int -> Int
fib' n x y
  | n == 0 = 1
  | n == 1 = x
  | otherwise = fib' (n -1) (x + y) x

-- cps ver
fib'' :: Int -> (Int -> Int) -> Int
fib'' 0 cont = cont 1
fib'' 1 cont = cont 1
fib'' n cont = fib'' (n -1) (\x -> fib'' (n -2) (\y -> cont (x + y)))

positive :: [Int] -> [Int] -> [Int]
positive [] acc = acc
positive (x : xs) acc
  | x > 0 = positive xs (acc ++ [x])
  | otherwise = positive xs acc

positive' :: [Int] -> ([Int] -> [Int]) -> [Int]
positive' [] cont = cont []
positive' (x : xs) cont
  | x > 0 = positive' xs (\acc -> cont (x : acc))
  | otherwise = positive' xs cont
