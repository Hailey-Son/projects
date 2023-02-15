CREATE TABLE daily_activities(
Id numeric,
ActivityDate timestamp,
TotalSteps numeric,
TotalDistance numeric,
TrackerDistance numeric,
LoggedActivitiesDistance numeric,
VeryActiveDistance numeric,
ModeratelyActiveDistance numeric,
LightActiveDistance numeric,
SedentaryActiveDistance numeric,
VeryActiveMinutes numeric,
FairlyActiveMinutes numeric,
LightlyActiveMinutes numeric,
SedentaryMinutes numeric,
Calories numeric)
 
--Total Distance and calories burned by id
SELECT id, count(*) AS number_of_records, sum(TotalDistance) as total_distance, sum(calories) as total_calories From daily_activities
GROUP by id

--Average distance and calories burned by id
SELECT id, count(*) AS number_of_records, round(avg(TotalDistance),2) as average_distance, round(avg(calories),2) as average_calories From daily_activities
GROUP by id

--max and min daily total distance and calories burned

SELECT max(totaldistance) as max_distance, min(totaldistance) as min_distance, max(calories) as max_calories, min(calories) as min_calories FROM daily_activities


--Top 3 users who burned calories most
SELECT id, total_calories FROM (SELECT id, total_calories, RANK() OVER(ORDER BY total_calories DESC) 
   								AS calories_rank FROM (SELECT id, sum(calories) AS total_Calories FROM daily_activities 
													  GROUP BY id)AS summary_by_total) AS summary
WHERE  calories_rank <=3;

--Bottom 3 users who burned calories  least

SELECT id, total_calories FROM (SELECT id, total_calories, RANK() OVER(ORDER BY total_calories asc) AS calories_rank 
								FROM (SELECT id, sum(calories) as total_calories FROM daily_activities 
									 GROUP BY id) AS summary_by_cals) AS summary
WHERE  calories_rank <= 3


--Top 3 users who went the fartest distance

SELECT id, total_distance FROM (SELECT id, total_distance, RANK() OVER(ORDER BY total_distance DESC) 
   								AS distance_rank FROM (SELECT id, sum(totaldistance) AS total_distance FROM daily_activities 
													  GROUP BY id)AS summary_by_total) AS summary
WHERE  distance_rank <=3;



--Bottom 3 users who's total distance is lowest

SELECT id, total_distance FROM (SELECT id, total_distance, RANK() OVER(ORDER BY total_distance asc) 
   								AS distance_rank FROM (SELECT id, sum(totaldistance) AS total_distance FROM daily_activities 
													  GROUP BY id)AS summary_by_total) AS summary
WHERE  distance_rank <=3;


--intensity proportion in distance 


SELECT id,activitydate, round(SedentaryActiveDistance/NULLIF(TotalDistance,0) *100,2) as sedentary_distance_percentage,
round(LightActiveDistance/NULLIF(TotalDistance,0) *100,2) as light_active_distance_percentage,
round(ModeratelyActiveDistance/NULLIF(TotalDistance,0) *100,2) as moderately_active_distance_percentage,
round(VeryActiveDistance/NULLIF(TotalDistance,0) *100,2) as very_active_distance_percentage
FROM daily_activities

--AVG proportion

SELECT id, round(avg(sedentary_distance_percentage),2), 
round(avg(light_active_distance_percentage),2), round(avg(moderately_active_distance_percentage),2), round(avg(very_active_distance_percentage),2)
FROM (SELECT id,activitydate, round(SedentaryActiveDistance/NULLIF(TotalDistance,0) *100,2) as sedentary_distance_percentage,
round(LightActiveDistance/NULLIF(TotalDistance,0) *100,2) as light_active_distance_percentage,
round(ModeratelyActiveDistance/NULLIF(TotalDistance,0) *100,2) as moderately_active_distance_percentage,
round(VeryActiveDistance/NULLIF(TotalDistance,0) *100,2) as very_active_distance_percentage
FROM daily_activities) AS intensity_proportion
GROUP BY id



--average intensity proportion for top users in terms of total distance

SELECT id, round(avg(sedentary_distance_percentage),2) AS average_sedentary, 
round(avg(light_active_distance_percentage),2) AS average_light_active, round(avg(moderately_active_distance_percentage),2) AS average_moderately_active,
round(avg(very_active_distance_percentage),2)AS average_very_active
FROM (SELECT id,activitydate, round(SedentaryActiveDistance/NULLIF(TotalDistance,0) *100,2) as sedentary_distance_percentage,
round(LightActiveDistance/NULLIF(TotalDistance,0) *100,2) as light_active_distance_percentage,
round(ModeratelyActiveDistance/NULLIF(TotalDistance,0) *100,2) as moderately_active_distance_percentage,
round(VeryActiveDistance/NULLIF(TotalDistance,0) *100,2) as very_active_distance_percentage
FROM daily_activities) AS intensity_proportion
GROUP BY id
HAVING id in
(SELECT id FROM (SELECT id, total_distance, RANK() OVER(ORDER BY total_distance DESC) 
   								AS distance_rank FROM (SELECT id, sum(totaldistance) AS total_distance FROM daily_activities 												  GROUP BY id)AS summary_by_total) AS summary
WHERE  distance_rank <=3);


--Create a table for weight log info

CREATE TABLE weight_log(
Id numeric,
Date timestamp,
WeightKg numeric,
WeightPounds numeric,
Fat numeric,
BMI numeric,
IsManualReport boolean,
LogId numeric)

