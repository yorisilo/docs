
-- 偶数に対してだけ半分にする関数

-- data Maybe a = Nothing | Just a
half x = if even x
         then Just (x `div` 2)
         else Nothing
