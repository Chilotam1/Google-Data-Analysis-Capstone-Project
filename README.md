# Google Data Analytics Capstone: Analyzing Company Data to Provide Actionable Marketing Strategy
My capstone project for the Google Data Analytics Professional Certificate, a Cyclistic bike share case study.
 
  By: Ajoku, Chilotam
  
  Last Updated: 8th of January, 2025 (update ongoing)

  ## Introduction
As part of the [Google Data Analytics Professional Certification](https://www.coursera.org/professional-certificates/google-data-analytics), I completed the capstone case study. In this case study, I was given a real-world data analysis scenario for the fictional bike sharing company. This study presented a practical data analysis situation involving the fictional bike-sharing company, Cyclistic. Assuming the role of a junior data analyst on the Cyclistic marketing team, my responsibility was to examine historical data from the company to address a specific business question. I adhered to Google's data analysis framework, which includes the steps of 'ask, prepare, process, analyze, share, and act' to conduct my analysis.
  ## Background
In 2016, Cyclistic introduced a highly successful bike-sharing program. Since its launch, the program has expanded to include 5,824 GPS-enabled bicycles, available at 692 stations across Chicago. Riders have the flexibility to unlock bikes from one station and return them to any other station within the network at any time.

Cyclistic's marketing strategy thus far has focused on raising general awareness and catering to diverse customer groups. A key factor contributing to the program's success has been its flexible pricing options: single-ride passes, full-day passes, and annual memberships. Customers using single-ride or full-day passes are categorized as casual riders, while those opting for annual memberships are considered Cyclistic members.

The marketing director of the company is convinced that the future success of Cyclistic relies on increasing the number of annual memberships. As a result, as junior data analysts, I have been assigned to analyze the differences in how casual riders and annual members utilize Cyclistic bikes. These insights will inform the development of a new marketing strategy aimed at converting casual riders into annual members.
  
  ## Approach/Steps
  ### 1. Ask Phase

**Business Task** - Design marketing strategies aimed at converting casual riders into annual members. In this project, I will answer the business question, “how do annual members and casual riders use Cyclistic bikes differently?” I will prepare, clean, and analyze historical trip data from the January to December 2022 to understand how annual members and casual riders use Cyclistic bike-share services.

### 2. Prepare phase
**Data Source:** [divvy-tripdata](https://divvy-tripdata.s3.amazonaws.com/index.html)
 [_Note: This dataset has been made available by Motivate International Inc. under this [license](https://divvybikes.com/data-license-agreement)_]

**Tools:**
  - Data cleaning & processing- SQL Server and Excel
  - Data visualization- Power BI

### 3. Process phase (Download all 12 months and export to excel, ckecked for duplicates or mistake, created column for days of the week and ride length)
The basis for this analysis is 2022 data and the steps for processing the data are as follow:

1. Data Combining
  
2. Data Exploration

3. Data Cleaning
   
4. Data Analysis
   

##### Data Combining: 

The 12 tables from January 2022 to December 2022 were stacked and combined into a single table called "Full_year_dataset". The table consists of 5,722,001 rows.
   
```sql
SELECT * 
INTO FULL_YEAR_DATASET
FROM (
    SELECT * FROM [dbo].[January_dataset]
    UNION ALL
    SELECT * FROM [dbo].[February_dataset]
    UNION ALL
    SELECT * FROM [dbo].[March_dataset]
    UNION ALL
    SELECT * FROM [dbo].[April_dataset]
    UNION ALL
    SELECT * FROM [dbo].[May_dataset]
    UNION ALL
    SELECT * FROM [dbo].[June dataset]
    UNION ALL
    SELECT * FROM [dbo].[July_dataset]
    UNION ALL
    SELECT * FROM [dbo].[August_dataset]
    UNION ALL
    SELECT * FROM [dbo].[September_dataset]
    UNION ALL
    SELECT * FROM [dbo].[October_dataset]
    UNION ALL
    SELECT * FROM [dbo].[November_dataset]
    UNION ALL
    SELECT * FROM [dbo].[December_dataset]
);
```
##### Data Exploration: 

The data type for the variables are

<img width="438" alt="Data_type" src="https://github.com/user-attachments/assets/f80e4247-c6f0-403d-9cb2-44662adcd235" />

After combining the 12 tables, I explored the data and flag inconsistencies for future cleaning.

First, I checked for NULL or missing values. The columns start_station_name, start_station_id, end_station_name, end_station_id, end_lat, and end_lng all had NULL values. There were 1,622,582 rows containing null values in total.

```sql
SELECT *
FROM ONE_YEAR_DATASET
WHERE end_lat IS NULL 
OR end_lng IS NULL
OR start_station_name IS NULL
OR start_station_id IS NULL
OR end_station_name IS NULL
OR end_station_id IS NULL
OR end_lat IS NULL
OR end_lng IS NULL
```
Secondly, I checked for duplicate rows using the primary key, ride_id. There were 823,488 duplicate rows

```sql
SELECT COUNT (ride_id) - COUNT(DISTINCT ride_id) AS duplicate
FROM FULL_YEAR_DATASET
```
Thirdly, I checked for invalid or unlikely ride lengths. I chose to define this as any ride that lasted less than 1 minute or more than 24 hours. To do this, I added and updated a new column to store ride length in minutes using the following syntax
```sql
ALTER TABLE FULL_YEAR_DATASET
ADD Ride_length_in_minutes INT;
UPDATE FULL_YEAR_DATASET
SET Ride_length_in_minutes = DATEDIFF(Minute, '00:00:00', ride_length);
```
Checking for invalid ride lengths using ride length in minutes column

```sql
SELECT COUNT(ride_length_in_minutes) AS shorter_than_one_minute
FROM FULL_YEAR_DATASET
WHERE ride_length_in_minutes < 1 -- 120,987 rides were less than 1 minutes
```
```sql
SELECT COUNT(ride_length_in_minutes) AS higher_than_24hrs
FROM FULL_YEAR_DATASET
WHERE ride_length_in_minutes > 1440 --- No rides were more than 24 hours
```
The query counted 120,987 invalid ride lengths in total.

Finally, I checked for invalid latitude and longitude values. There was 1 invalid start latitude values of “-73.7964782714844”.
```sql
select start_lat
from FULL_YEAR_DATASET
where start_lat > 50 OR start_lat < 35
```
```sql
select start_lng
from FULL_YEAR_DATASET
where start_lng < -90 OR start_lng > -80 
```
```sql
select end_lat
from FULL_YEAR_DATASET
where end_lat > 50 OR end_lat < 35
```
```SQL
select end_lng
from ONE_YEAR_DATASET
where end_lng < -90 OR end_lng > -80
```

##### Data Cleaning: 

Before analyzing the data, the dataset was cleaned by:

 - Removing the trips with null values.
 - Adding 3 columns: 'ride_length_in_mins', 'day_of_week' and 'month'.
 - Exclusing the rides with duration less than a minute or longer than a day.


#### 5. Analyze phase (visualize each question, using charts and write a short after it, explaining the visuals)
6. Share phase (PowerBi full visuals) then also answer the question regarding similarities and differences between casual riders and annual members.
7. Act phase (Reccomendation)
