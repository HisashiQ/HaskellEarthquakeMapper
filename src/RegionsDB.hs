module RegionsDB where

import Database.HDBC
import Database.HDBC.Sqlite3
import DB
import Types

createRegionsTable :: IO ()
createRegionsTable = do
	conn <- dbConnect
	tables <- getTables conn
	if not (elem "regions" tables) then do
		run conn "CREATE TABLE regions (region VARCHAR(20), latFrom DECIMAL, latTo DECIMAL, longFrom DECIMAL, longTo DECIMAL)" []
		commit conn
		putStrLn "Regions Database initialised!"
	else
		return ()

createRegions :: [Region]
createRegions = map makeRegion [nAmerica,sAmerica,africa,europe,asia,australasia]
    where
        nAmerica = ["N. America","15","90","-180","-30"]
        sAmerica = ["S. America","-90","15","-180","-30"]
        africa =  ["Africa","-90","40","-30","50"]
        europe = ["Europe","40","90","-30","50"]
        asia = ["Asia","-10","90","50","180"]
        australasia = ["Australasia","-90","-10","50","180"]

insertRegion :: Region -> IO ()
insertRegion region = do
	conn <- dbConnect
	let query = "INSERT INTO regions VALUES (?,?,?,?,?)"
	let record = [ toSql.name $ region
	             , toSql.latFrom $ region
	             , toSql.latTo $ region
	             , toSql.longFrom $ region
	             , toSql.longTo $ region
	             ]
	run conn query record
	commit conn
	disconnect conn