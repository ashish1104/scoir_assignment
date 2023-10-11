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
group by gameId
)
 
, team_duration as (
 
  	select homeTeamName
		,avg(durationMinutes) as averageHomeTeamDurationMinutes
  	from game_agg
  	group by homeTeamName
 
)
 
,game_agg_v2 as (
 
select game_agg.*
	,averageHomeTeamDurationMinutes
	,TIMESTAMP_ADD(startTime, INTERVAL durationMinutes MINUTE) as endTime
	, case 	when homeFinalRuns > awayFinalRuns then game_agg.homeTeamName
      		when awayFinalRuns > homeFinalRuns then game_agg.awayTeamName
      		else NULL end as winningTeam
from 
	game_agg
left join team_duration
	on game_agg.homeTeamName = team_duration.homeTeamName

)


select *
from game_agg_v2 
