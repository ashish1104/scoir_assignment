with game_agg as (
 
SELECT gameId,
	Max(awayTeamName) as awayTeamName,
	Max(homeTeamName) as homeTeamName,
	Max(startTime) as startTime,
	Max(durationMinutes) as durationMinutes,
	Max(dayNight) as dayNight,
	Max(seasonId) as seasonId,
	Max(homeFinalRuns) as homeFinalRuns,
	Max(awayFinalRuns) as awayFinalRuns
FROM 
	`bigquery-public-data.baseball.games_wide` a
group by 1
)
 
,game_agg_ranked as (
select *,rank() over (partition by homeTeamName order by durationMinutes desc) as game_duration_rank
from 
	game_agg
)


select *
from game_agg_ranked 
where game_duration_rank = 2