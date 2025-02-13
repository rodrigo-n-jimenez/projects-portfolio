/* These queries look at the 2024/25 data for the English second division of football and extract 
different insights focusing on Sunderland FC and on their performance during this season */

/* Sunderland’s home and away record */
SELECT 
    HomeOrAway,
    COUNT(*) AS GamesPlayed,
    SUM(GoalsScored) AS TotalGoalsScored,
    SUM(GoalsConceded) AS TotalGoalsConceded,
    SUM(CASE WHEN MatchResult = 'Win' THEN 1 ELSE 0 END) AS Wins,
    SUM(CASE WHEN MatchResult = 'Draw' THEN 1 ELSE 0 END) AS Draws,
    SUM(CASE WHEN MatchResult = 'Loss' THEN 1 ELSE 0 END) AS Losses
FROM (
    -- Subquery: Get only Sunderland’s matches in the 2024/25 season
    SELECT *,
        CASE 
            WHEN `HomeTeam` = 'Sunderland' THEN 'Home'
            ELSE 'Away'
        END AS HomeOrAway,
        CASE 
            WHEN `HomeTeam` = 'Sunderland' THEN `FTH Goals`
            ELSE `FTA Goals`
        END AS GoalsScored,
        CASE 
            WHEN `HomeTeam` = 'Sunderland' THEN `FTA Goals`
            ELSE `FTH Goals`
        END AS GoalsConceded,
        CASE 
            WHEN (`HomeTeam` = 'Sunderland' AND `FT Result` = 'H') 
              OR (`AwayTeam` = 'Sunderland' AND `FT Result` = 'A') THEN 'Win'
            WHEN `FT Result` = 'D' THEN 'Draw'
            ELSE 'Loss'
        END AS MatchResult
    FROM epl_schema.`england 2 csv`
    WHERE `Season` = "2024/25"
    AND (`HomeTeam` = "Sunderland" OR `AwayTeam` = "Sunderland")
) AS SunderlandMatches
GROUP BY HomeOrAway;



/* Sunderland’s most frequent opponents */
SELECT 
    Opponent,
    COUNT(*) AS MatchesPlayed
FROM (
    -- Subquery: Get only Sunderland’s matches in the 2024/25 season
    SELECT *,
        CASE 
            WHEN `HomeTeam` = 'Sunderland' THEN `AwayTeam`
            ELSE `HomeTeam`
        END AS Opponent
    FROM epl_schema.`england 2 csv`
    WHERE `Season` = "2024/25"
    AND (`HomeTeam` = "Sunderland" OR `AwayTeam` = "Sunderland")
) AS SunderlandMatches
GROUP BY Opponent
ORDER BY MatchesPlayed DESC;



/* Best & Worst Matches Based on Goal Difference */
SELECT 
    `ï»¿Date` AS MatchDate,
    `HomeTeam`, 
    `AwayTeam`, 
    GoalsScored, 
    GoalsConceded,
    (GoalsScored - GoalsConceded) AS GoalDifference
FROM (
    -- Subquery: Get only Sunderland’s matches in the 2024/25 season
    SELECT *,
        CASE 
            WHEN `HomeTeam` = 'Sunderland' THEN `FTH Goals`
            ELSE `FTA Goals`
        END AS GoalsScored,
        CASE 
            WHEN `HomeTeam` = 'Sunderland' THEN `FTA Goals`
            ELSE `FTH Goals`
        END AS GoalsConceded
    FROM epl_schema.`england 2 csv`
    WHERE `Season` = "2024/25"
    AND (`HomeTeam` = "Sunderland" OR `AwayTeam` = "Sunderland")
) AS SunderlandMatches
ORDER BY GoalDifference DESC;


/* Best & Worst Matches Based on Goal Difference */
SELECT 
    HomeOrAway,
    SUM(Home_Yellow) AS SunderlandYellowCards,
    SUM(Away_Yellow) AS OpponentYellowCards
FROM (
    -- Subquery: Get only Sunderland’s matches in the 2024/25 season
    SELECT *,
        CASE 
            WHEN `HomeTeam` = 'Sunderland' THEN 'Home'
            ELSE 'Away'
        END AS HomeOrAway,
        CASE 
            WHEN `HomeTeam` = 'Sunderland' THEN `H Yellow`
            ELSE NULL 
        END AS Home_Yellow,
        CASE 
            WHEN `AwayTeam` = 'Sunderland' THEN `A Yellow`
            ELSE NULL 
        END AS Away_Yellow
    FROM epl_schema.`england 2 csv`
    WHERE `Season` = "2024/25"
    AND (`HomeTeam` = "Sunderland" OR `AwayTeam` = "Sunderland")
) AS SunderlandMatches
GROUP BY HomeOrAway;


