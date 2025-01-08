--- Removing the trips with null values. A total of 1,622,582 rows were affected
--- I dropped columns irrelevant for my analysis
--- I removed duplicate rows
--- I removed invalid ride lengths with duration less than a minute or longer than a day
--- I removed invalid latitudinal row
--- Changed days of the week column from numbers to text:

DELETE FROM ONE_YEAR_DATASET
WHERE end_lat IS NULL 
OR end_lng IS NULL
OR start_station_name IS NULL
OR start_station_id IS NULL
OR end_station_name IS NULL
OR end_station_id IS NULL--- 1622582 rows affected

ALTER TABLE FULL_YEAR_DATASET
DROP COLUMN start_station_name, start_station_id, end_station_name, end_station_id

WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY ride_id ORDER BY ride_id) AS row_num
    FROM ONE_YEAR_DATASET
)
DELETE FROM FULL_YEAR_DATASET
WHERE ride_id IN (
    SELECT ride_id
    FROM CTE
    WHERE row_num > 1
);

DELETE FROM FULL_YEAR_DATASET
WHERE ride_length < '00:01:00' OR
ride_length > '23:59:39:999'

DELETE FROM FULL_YEAR_DATASET
WHERE start_lng < -90 OR start_lng > -80

UPDATE FULL_YEAR_DATASET
SET day_of_week =
     CASE 
        WHEN day_of_week = 1 THEN 'Sunday'
        WHEN day_of_week = 2 THEN 'Monday'
        WHEN day_of_week = 3 THEN 'Tuesday'
        WHEN day_of_week = 4 THEN 'Wednesday'
        WHEN day_of_week = 5 THEN 'Thursday'
        WHEN day_of_week = 6 THEN 'Friday'
        WHEN day_of_week = 7 THEN 'Saturday'
     END;
     ```
