import Data.List

solve1 :: [Int] -> Int
solve1 = ((*) <$> length . filter (== 1) <*> succ . length . filter (== 3))
        . (($) <$> zipWith subtract <*> tail)

solve2 :: [Int] -> Int
solve2 = head . go
    where
        go [] = []
        go (n:ns) =
            let cs = go ns
            in  (:cs) $ max 1 $ sum $ zipWith const cs $ takeWhile (<= n+3) ns

main :: IO ()
main = do
    input <- (0:) . sort . map read . lines <$> readFile "input"
    print . solve1 $ input
    print . solve2 $ input
