#Table with all the teams in PAC12 conference of first division 
SELECT id,name,turner_name,conf_alias
FROM `bigquery-public-data.ncaa_basketball.mbb_teams` 
WHERE conf_alias = 'PAC12';

# How many games were played between the pac12 teams in the season of 2015?
SELECT DISTINCT game_id
FROM `bigquery-public-data.ncaa_basketball.mbb_teams_games_sr` AS tg
JOIN `bigquery-public-data.ncaa_basketball.mbb_teams` AS t
ON t.id = tg.team_id 
WHERE tg.conf_alias = 'PAC12' AND tg.opp_conf_alias = 'PAC12'AND season = 2015;

# What is the average attendance of games?

SELECT SUM((attendance))/ COUNT(game_id)/2 AS average_attendance_total
FROM `bigquery-public-data.ncaa_basketball.mbb_teams_games_sr`
WHERE game_id IN(SELECT DISTINCT game_id
                FROM `bigquery-public-data.ncaa_basketball.mbb_teams_games_sr` AS tg
                JOIN `bigquery-public-data.ncaa_basketball.mbb_teams` AS t
                ON t.id = tg.team_id 
                WHERE tg.conf_alias = 'PAC12' AND tg.opp_conf_alias = 'PAC12'AND season = 2015);

# Which are the three most popular teams(with highest attendence)?

SELECT SUM((attendance))/ COUNT(game_id)/2 AS average_attendance_by_team,name
FROM `bigquery-public-data.ncaa_basketball.mbb_teams_games_sr`
WHERE game_id IN(SELECT DISTINCT game_id
                FROM `bigquery-public-data.ncaa_basketball.mbb_teams_games_sr` AS tg
                JOIN `bigquery-public-data.ncaa_basketball.mbb_teams` AS t
                ON t.id = tg.team_id 
                WHERE tg.conf_alias = 'PAC12' AND tg.opp_conf_alias = 'PAC12'AND season = 2015)
GROUP BY name
ORDER BY average_attendance_by_team DESC
LIMIT 3;

SELECT SUM((attendance))/ COUNT(game_id)/2 AS average_attendance_by_team,name,season
FROM `bigquery-public-data.ncaa_basketball.mbb_teams_games_sr`
WHERE game_id IN(SELECT DISTINCT game_id
                FROM `bigquery-public-data.ncaa_basketball.mbb_teams_games_sr` AS tg
                JOIN `bigquery-public-data.ncaa_basketball.mbb_teams` AS t
                ON t.id = tg.team_id 
                WHERE tg.conf_alias = 'PAC12' AND tg.opp_conf_alias = 'PAC12')
GROUP BY name,season
ORDER BY average_attendance_by_team DESC
LIMIT 5;

# Wildcats are the team with stongest fanbase from 2013-2017. From 2015-2017 they had most attended games overall. What place they were these seasons?
SELECT name,season,season_rank
FROM(SELECT name,season,rank() OVER(partition by season ORDER BY COUNT(win) DESC) AS season_rank
      FROM `bigquery-public-data.ncaa_basketball.mbb_teams_games_sr`
      WHERE game_id IN(SELECT DISTINCT game_id
                        FROM `bigquery-public-data.ncaa_basketball.mbb_teams_games_sr` AS tg
                        JOIN `bigquery-public-data.ncaa_basketball.mbb_teams` AS t
                        ON t.id = tg.team_id 
                        WHERE tg.conf_alias = 'PAC12' AND tg.opp_conf_alias = 'PAC12')
            AND win IS TRUE AND season IN (2015,2016,2017) 
       GROUP BY name,season
       ORDER BY season, season_rank)
WHERE name = 'Wildcats';

# Wildcats were dominating the PAC12 conference these years.


