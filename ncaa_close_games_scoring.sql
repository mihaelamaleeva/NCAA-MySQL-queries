# There are some limitations of BigQuery, as you can't use DML, views and other functionalities.

# What are the average points per game?
SELECT AVG(points)
FROM (SELECT game_id, SUM(points_scored) AS points
        FROM `bigquery-public-data.ncaa_basketball.mbb_pbp_sr` 
        WHERE game_id is NOT NULL
        GROUP BY game_id
        ORDER BY game_id);



# Creating a query with game scores.
SELECT game_id,
       MAX(points) AS winner_points,
       MIN(points) AS loser_points,
       (MAX(points) - MIN(points)) AS points_difference
FROM (SELECT game_id, SUM(points_scored) AS points
        FROM `bigquery-public-data.ncaa_basketball.mbb_pbp_sr` 
        WHERE game_id is NOT NULL 
        GROUP BY game_id,team_id
        ORDER BY game_id)
GROUP BY game_id;

# Do close games (with point difference below or equal to  5 points) 
# result in lower scoring in the last five minutes?

SELECT AVG(points) AS average_points_last_5_min_all_game
FROM (SELECT game_id, SUM(points_scored) AS points
        FROM `bigquery-public-data.ncaa_basketball.mbb_pbp_sr` 
        WHERE game_id is NOT NULL AND elapsed_time_sec >= 2100
        GROUP BY game_id
        ORDER BY game_id);


SELECT AVG(points) AS average_points_last_5_min_close_game
 FROM (SELECT game_id, SUM(points_scored) AS points
        FROM `bigquery-public-data.ncaa_basketball.mbb_pbp_sr` 
        WHERE game_id is NOT NULL AND elapsed_time_sec >= 2100 
        GROUP BY game_id,team_id
        ORDER BY game_id)
WHERE game_id IN (SELECT game_id,
                  FROM (SELECT game_id, SUM(points_scored) AS points
                            FROM `bigquery-public-data.ncaa_basketball.mbb_pbp_sr` 
                            WHERE game_id is NOT NULL 
                            GROUP BY game_id,team_id
                            ORDER BY game_id)
                  GROUP BY game_id
                  HAVING  MAX(points)-MIN(points) <= 5.0);

# We can see that close games result in twice lower scoring points.




