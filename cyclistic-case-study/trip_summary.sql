--create yearly trip data

Create Table tripdata2022(
	ride_id varchar(100),
	rideable_type varchar(100),
	started_at	timestamp,
	ended_at timestamp,
	start_station_name varchar(100),
	start_station_id varchar(100),   
	end_station_name varchar(100),
	end_station_id varchar(100),
	start_lat numeric(10,10),
	start_lng numeric(10,10),
	end_lat numeric(10,10),
	end_lng numeric(10,10),
	member_casual varchar(100))

SELECT * FROM tripdata2022

--Tried to import data. Error occurred due to data type numeric(10,10). 

ALTER Table tripdata2022
ALTER COLUMN start_lat TYPE numeric

ALTER Table tripdata2022
ALTER COLUMN start_lng TYPE numeric

ALTER Table tripdata2022
ALTER COLUMN end_lat TYPE numeric

ALTER Table tripdata2022
ALTER COLUMN end_lng TYPE numeric

--Import monthly data into a single table.


--New column for 'ride_length' and 'day_of_week'

SELECT *,ended_at - started_at AS ride_length, extract(dow from started_at) AS day_of_week FROM tripdata2022
ORDER BY ride_length desc
limit 15


-- mean of ride length: 19mins

SELECT avg(ride_length) FROM (SELECT *,ended_at - started_at AS ride_length, extract(dow from started_at) AS day_of_week FROM tripdata2022) summary

-- mean of ride length by membership type

SELECT member_casual,avg(ride_length) FROM (SELECT *,ended_at - started_at AS ride_length, extract(dow from started_at) AS day_of_week FROM tripdata2022) summary
GROUP BY member_casual

--max ride length:28 days and 17hrs 

SELECT max(ride_length) FROM (SELECT *,ended_at - started_at AS ride_length, extract(dow from started_at) AS day_of_week FROM tripdata2022) summary

-- max of ride length by membership type

SELECT member_casual,max(ride_length) FROM (SELECT *,ended_at - started_at AS ride_length, extract(dow from started_at) AS day_of_week FROM tripdata2022) summary
GROUP BY member_casual

--mode of day of week: 6 Friday

SELECT day_of_week FROM 
(SELECT day_of_week, number_of_riders, rank() over ( order by number_of_riders desc) as n_riders_rank FROM 
(SELECT extract(dow from started_at) AS day_of_week ,count(*) as number_of_riders FROM tripdata2022
GROUP BY day_of_week) AS summary) rank_table
WHERE n_riders_rank = 1


SELECT extract(dow FROM started_at) AS day_of_week, count(*) As number_of_riders FROM tripdata2022
GROUP BY day_of_week

--Number of data

SELECT count(*) FROM tripdata2022

SELECT * FROM tripdata

SELECT distinct(rideable_type) FROM tripdata2022

--Assign month name

SELECT *, TO_CHAR(started_at, 'Month') AS "Month" FROM tripdata2022
ORDER BY ride_id 

SELECT "Month",avg(ride_length) FROM 
(select *, to_char(started_at,'Month') AS "Month", ended_at - started_at AS ride_length FROM tripdata2022) tripsummary
 GROUP BY "Month"