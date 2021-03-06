import Data.Char
import qualified Data.Set as Set
import Text.ParserCombinators.ReadP

parse :: String -> [(String, [(Int, String)])]
parse = fst . head . readP_to_S all_lines
    where
        colour = many1 $ satisfy (`notElem` ",.")
        bags = colour <* string " bag" <* optional (char 's')
        numberedBags = (,) <$> (read <$> many1 (satisfy isDigit))
            <*> (char ' ' *> bags)
        line = (,) <$> (bags <* string " contain ") <*>
            (([] <$ string "no other bags")
            +++ sepBy1 numberedBags (string ", ")) <* char '.' <* skipSpaces
        all_lines = many line <* eof

solve1 :: [(String, [(a, String)])] -> Int
solve1 input = pred $ Set.size $ expand $ Set.singleton "shiny gold"
    where
        input' = map (\(x, y) -> (x, Set.fromList $ map snd y)) $ input
        expand set =
            let set' = Set.union set $ Set.fromList $ map fst $
                    filter (not . Set.disjoint set . snd) input'
            in  (if set' == set then id else expand) set'

solve2 :: [(String, [(Int, String)])] -> Int
solve2 input = go "shiny gold"
    where
        go s = sum $ map (\(n, s) -> n * (1 + go s)) $ concatMap snd $
                filter ((== s) . fst) input

main :: IO ()
main = do
    input <- parse <$> readFile "input"
    print . solve1 $ input
    print . solve2 $ input
