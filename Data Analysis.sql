---Total number of customers---
SELECT COUNT(ride_id) as Number_of_customers
FROM FULL_YEAR_DATASET

--- Number of Casual riders verses the number of member riders
Select Member_casual, Count(*) as Number_of_riders
From FULL_YEAR_DATASET
Group by member_casual;

---Average ride duration by member type-----
Select member_casual, AVG(ride_length_in_minutes) as Average_ride_duration_in_minutes
From FULL_YEAR_DATASET
Group by member_casual

--Average ride duration per month by member type--
Select Month, member_casual, AVG(ride_length_in_minutes) as average_ride_time
From FULL_YEAR_DATASET
Group by member_casual, month
Order by month, member_casual;

---Average ride time per days of the week by member type---
Select day_of_week, member_casual, AVG(ride_length_in_minutes) as average_ride_time
From FULL_YEAR_DATASET
Group by member_casual, day_of_week
Order by day_of_week, member_casual;

---Number of rides per days of the week by member type---
Select day_of_week, member_casual, COUNT(*) as Number_of_rides
From FULL_YEAR_DATASET
Group by member_casual, day_of_week
Order by day_of_week, member_casual;

--Number of rides per month by member type---
Select month, member_casual, COUNT(*) as Number_of_rides
From FULL_YEAR_DATASET
Group by member_casual, month
Order by month, member_casual;

--Number of rideable type by member_casual--
SELECT member_casual, rideable_type, COUNT(*) AS Number_of_rides
FROM FULL_YEAR_DATASET
GROUP BY rideable_type, member_casual
ORDER BY member_casual;


