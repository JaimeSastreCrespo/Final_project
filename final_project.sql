CREATE DATABASE IF NOT EXISTS final_project;

USE final_project;

SELECT *
FROM my_year_stream;


ALTER TABLE my_current_library
ADD PRIMARY KEY (MyUnknownColumn);




-- 1
-- To show the song and artist I played most during the year, how many times and how much time

SELECT count(artistName) as Max_artist, UniqueID, count(day), sum(duration_ms)
FROM my_year_stream
GROUP BY UniqueID
ORDER BY count(artistName) DESC ;

-- 2
-- THE SONGS I PLAYED LESS THAN 2 SECS AND THEY ARE NOT IN MY CURRENT LIBRARY, MAYBE WE SHOULD REVIEW IF WE WANT TO KEEP THEM
-- IN OUR PLAYLIST (IF THEY ARE) OR IMPROVE THE MACHINE LEARNING RECOMMENDATION OF SPOTIFY TO AVOID THIS KIND OF MUSIC


SELECT count(artistName) as Counter,  mys.UniqueID
FROM my_year_stream mys
LEFT JOIN my_current_library mcl
ON mys.artistName = mcl.artist
WHERE duration_ms < 2 and mys.artistName NOT IN (SELECT artist FROM my_current_library) 
GROUP BY mys.UniqueID
ORDER BY count(artistName) ASC
;


-- 3
-- When did I listen more songs during the week last year? Display the day and the artist.

SELECT count(artistName), weekday
FROM  my_year_stream
GROUP BY weekday
ORDER BY count(artistName) DESC
LIMIT 3;


-- 4
-- Show if there's any song (and with some level of popularity) that I did not listen in the last year but 
-- it is in my historic spotify that records my top 100 from each of the following years: 2018, 2019, 2020, 
-- 2021 and 2022 (150 songs of this last year)


SELECT DISTINCT mhs.artist,  mhs.track_name, popularity
FROM my_historic_spotify mhs
LEFT JOIN my_year_stream mys
on  mhs.track_name = mys.trackName
WHERE mhs.track_name NOT IN (SELECT trackName FROM my_year_stream) 
AND popularity > 40;


-- 5
-- How Was I in terms of matching popularity? 
SELECT track_name, artist , tempo , popularity, year_playlist
FROM my_historic_spotify
WHERE popularity > 75
;

Error Code: 1140. In aggregated query without GROUP BY, expression 
#1 of SELECT list contains nonaggregated column 'final_project.my_historic_spotify.track_name'; 
this is incompatible with sql_mode=only_full_group_by



