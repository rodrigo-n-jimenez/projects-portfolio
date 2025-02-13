/* Sunderland’s Discipline Record (Yellow & Red Cards) */
SELECT 
    CASE 
        WHEN `HomeTeam` = "Sunderland" THEN "Home"
        ELSE "Away"
    END AS Location,
    SUM(CASE WHEN `HomeTeam` = "Sunderland" THEN `H Yellow` ELSE `A Yellow` END) AS YellowCards,
    SUM(CASE WHEN `HomeTeam` = "Sunderland" THEN `H Red` ELSE `A Red` END) AS RedCards,
    SUM(CASE WHEN `AwayTeam` = "Sunderland" THEN `A Yellow` ELSE `H Yellow` END) AS OpponentYellowCards,
    SUM(CASE WHEN `AwayTeam` = "Sunderland" THEN `A Red` ELSE `H Red` END) AS OpponentRedCards
FROM epl_schema.`england 2 csv`
WHERE `Season` = "2024/25"
GROUP BY Location;


