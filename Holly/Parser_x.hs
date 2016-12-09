module Parser_x where

import Data.List.Split
import Data.List

--Takes the result of the http download and produces a list of raw earthquake data strings
getEarthquakes :: Either String String -> [String]
getEarthquakes (Left _) = ["Parsing error"]
getEarthquakes (Right x) = init $ tail (splitOn "\"type\":\"Feature\"" x)

--Takes a raw earthquake string and returns a property value
getProperty :: String -> String -> String
getProperty a b = head $ splitOn ",\"" $ last $ splitOn property b
    where property = "\"" ++ a ++ "\":"

--Takes a raw earthquake string and returns a list of floats showing coordinates
getCoordinates :: String -> [Double]
getCoordinates x = map read $ splitOn "," (init.init.tail $ getProperty "coordinates" x)

--Checks if want date or magnitude
dateOrMag :: String -> IO (String)
dateOrMag line
    | (line == "1") = do (return "date")
    | (line == "2") = do (return "time")
    | otherwise = do
        putStrLn "Error, please enter again"
        newline <- getLine
        dateOrMag newline