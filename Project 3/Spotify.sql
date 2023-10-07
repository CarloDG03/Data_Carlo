select * from PortfolioProject.. Spotify

-- Count of number of songs release per given year

Select released_year, count(released_year) as Release
from portfolioproject.. spotify
group by released_year
order by release desc

-- How many of the same artsists are in the data

Select top 20
[artist(s)_name], count([artist(s)_name]) as Num_of_songs
from PortfolioProject.. Spotify
group by [artist(s)_name]
order by Num_of_songs desc


-- Number of songs in comparison to their streams
select top 60
		[artist(s)_name],
		count([artist(s)_name]) as Num_of_Top_Songs,
		sum(streams) as Total_Streams


from PortfolioProject..Spotify

	
	group by [artist(s)_name]
	order by Total_Streams desc

-- What are the months in which the most streamed songs are released?


SELECT
    released_month,
    COUNT(*) AS song_count
FROM
    PortfolioProject..Spotify  
GROUP BY
    released_month
ORDER BY
    song_count desc

-- Does danceability have a higher impact on streams?
-- What are the songs that are in the people’s playlist?
SELECT
	track_name,
    in_spotify_playlists,
	[danceability_%],
	 FORMAT(streams, 'N0') AS formatted_streams
FROM
    PortfolioProject..Spotify  
order by  streams desc  -- interchangeable for in_spotify_playlists.

