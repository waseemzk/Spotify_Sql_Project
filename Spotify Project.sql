-- SQL SPOTIFY PROJECT

DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-- Check The Data 

SELECT * FROM SPOTIFY;

SELECT COUNT(*) FROM SPOTIFY;

SELECT COUNT(DISTINCT ARTIST) FROM SPOTIFY;

SELECT COUNT(DISTINCT album) FROM SPOTIFY;

SELECT DISTINCT album_type FROM SPOTIFY;

SELECT DISTINCT CHANNEL FROM SPOTIFY;

SELECT DISTINCT MOST_PLAYED_ON FROM SPOTIFY;

--------------------------------------------------------------------------------
-- We Notice There Are A Songs With Zero Duration So We Must Handle This Problem
--------------------------------------------------------------------------------

SELECT min(duration_min) FROM SPOTIFY;

SELECT * FROM SPOTIFY WHERE DURATION_MIN = 0;

DELETE FROM SPOTIFY WHERE DURATION_MIN = 0;

--------------------------
-- SOLVE BUSINESS PROBLEMS
--------------------------

-- 1.Retrieve the names of all tracks that have more than 1 billion streams.

SELECT * FROM SPOTIFY;

SELECT TRACK FROM SPOTIFY WHERE STREAM > 1000000000;
----------------------------------------------------

-- 2.List all albums along with their respective artists.

SELECT * FROM SPOTIFY;

SELECT ARTIST, ALBUM FROM SPOTIFY GROUP BY 1,2 ORDER BY 1;
----------------------------------------------------

-- 3.Get the total number of comments for tracks where licensed = TRUE.

SELECT * FROM SPOTIFY;

SELECT SUM(COMMENTS) FROM SPOTIFY WHERE LICENSED = TRUE; 
----------------------------------------------------

-- 4.Find all tracks that belong to the album type single.

SELECT * FROM SPOTIFY;

SELECT TRACK, ALBUM_TYPE FROM SPOTIFY WHERE ALBUM_TYPE = 'single' GROUP BY 1,2 ORDER BY 1 ASC;
----------------------------------------------------

-- 5.Count the total number of tracks by each artist.

SELECT * FROM SPOTIFY;

SELECT ARTIST, COUNT(TRACK) FROM SPOTIFY GROUP BY 1 ;
----------------------------------------------------

-- 6.Calculate the average danceability of tracks in each album.

SELECT * FROM SPOTIFY;

SELECT ALBUM, AVG(DANCEABILITY) FROM SPOTIFY GROUP BY 1;
----------------------------------------------------

-- 7.Find the top 5 tracks with the highest energy values.

SELECT * FROM SPOTIFY;

SELECT TRACK, AVG(ENERGY) FROM SPOTIFY GROUP BY 1 ORDER BY 2 DESC LIMIT 5; 
----------------------------------------------------

-- 8.List all tracks along with their views and likes where official_video = TRUE.

SELECT * FROM SPOTIFY;

SELECT TRACK, sum(views), sum(likes) FROM SPOTIFY WHERE official_video = 'true' GROUP BY 1 ORDER BY 2 DESC LIMIT 5;
----------------------------------------------------

-- 9.For each album, calculate the total views of all associated tracks.

SELECT * FROM SPOTIFY;

SELECT ALBUM,TRACK, SUM(VIEWS) FROM SPOTIFY GROUP BY 1,2 ORDER BY 3 DESC;
----------------------------------------------------

-- 10.Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * FROM

(

SELECT TRACK,
	   COALESCE(SUM(CASE WHEN MOST_PLAYED_ON = 'Youtube' THEN STREAM END),0) AS STREAMED_ON_YOUTUBE,
       COALESCE(SUM(CASE WHEN MOST_PLAYED_ON = 'Spotify' THEN STREAM END),0) AS STREAMED_ON_SPOTIFY
       FROM SPOTIFY GROUP BY 1
	   
) AS S1

WHERE STREAMED_ON_SPOTIFY > STREAMED_ON_YOUTUBE
      AND STREAMED_ON_YOUTUBE <> 0
----------------------------------------------------

-- 11.Find the top 3 most-viewed tracks for each artist using window functions.

SELECT * FROM SPOTIFY;

WITH RANK_CTE AS 
(
SELECT ARTIST, TRACK, SUM(VIEWS), DENSE_RANK() OVER(PARTITION BY ARTIST ORDER BY SUM(VIEWS) DESC ) AS RANK FROM SPOTIFY GROUP BY 1,2 ORDER BY 1,3 DESC
)
SELECT * FROM RANK_CTE WHERE RANK <= 3
----------------------------------------------------

-- 12.Write a query to find tracks where the liveness score is above the average.

SELECT * FROM SPOTIFY;

SELECT TRACK, LIVENESS FROM SPOTIFY WHERE LIVENESS > (SELECT AVG(LIVENESS) FROM SPOTIFY);
----------------------------------------------------

-- 13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

SELECT * FROM SPOTIFY;

WITH CTE_ENERGY AS

(
SELECT 
       ALBUM,
	   MAX(ENERGY_LIVENESS) AS MAX_ENERGY,
	   MIN(ENERGY_LIVENESS) AS MIN_ENERGY
	   FROM SPOTIFY GROUP BY 1
) 
	
SELECT ALBUM, (MAX_ENERGY - MIN_ENERGY) AS DIFFER FROM CTE_ENERGY ;
----------------------------------------------------

---------------
----THE END---- (;
---------------








































