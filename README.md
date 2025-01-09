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
  ### 1. ASK PHASE

**Business Task** - Design marketing strategies aimed at converting casual riders into annual members. In this project, I will answer the business question, “how do annual members and casual riders use Cyclistic bikes differently?” I will prepare, clean, and analyze historical trip data from the January to December 2022 to understand how annual members and casual riders use Cyclistic bike-share services.

### 2. PREPARE PHASE
**Data Source:** [divvy-tripdata](https://divvy-tripdata.s3.amazonaws.com/index.html)
 [_Note: This dataset has been made available by Motivate International Inc. under this [license](https://divvybikes.com/data-license-agreement)_]

**Tools:**
  - Data cleaning & processing- SQL Server and Excel
  - Data visualization- Power BI

### 3. PROCESS PHASE
The basis for this analysis is 2022 data and the steps for processing the data are as follow:

1. [Data Combining](#data-combining)
  
2. [Data Exploration](#data-exploration)

3. [Data Cleaning](#data-cleaning)  

#### Data Combining: 

> The 12 tables from January 2022 to December 2022 were stacked and combined into a single table called "Full_year_dataset". The table consists of 5,722,001 rows.
   
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
 #### Data Exploration: 

 - I did an initial exploration of the dataset on Excel worksheet, and created columns for ride length, days of the week and Month. 

> To calculate the length of each ride, I subtracted the started_at from the ended_at column and formatted as HH:MM:SS using Format > Cells > Time > 373055.
> To create a column called day_of_week, and calculate the day of the week that each ride, I used the WEEKDAY command (for example, =WEEKDAY(C2,1)) in each dataset, and formatted as general noting that 1 = Sunday and 7 = Saturday.
> To create a column called Month, and calculate the month that each ride took place, I used the TEXT command ( for example, =TEXT(A2, "mmmm"))


- The data type for the variables are

<img width="438" alt="Data_type" src="https://github.com/user-attachments/assets/f80e4247-c6f0-403d-9cb2-44662adcd235" />

After combining the 12 tables, I explored the data and flag inconsistencies for future cleaning.

- First, I checked for NULL or missing values. The columns start_station_name, start_station_id, end_station_name, end_station_id, end_lat, and end_lng all had NULL values. There were 1,622,582 rows containing null values in total.

```sql
SELECT *
FROM FULL_YEAR_DATASET
WHERE end_lat IS NULL 
OR end_lng IS NULL
OR start_station_name IS NULL
OR start_station_id IS NULL
OR end_station_name IS NULL
OR end_station_id IS NULL;
```
- Secondly, I checked for duplicate rows using the primary key, ride_id. There were 823,488 duplicate rows

```sql
SELECT COUNT (ride_id) - COUNT(DISTINCT ride_id) AS duplicate
FROM FULL_YEAR_DATASET
```
- Thirdly, I checked for invalid or unlikely ride lengths. I chose to define this as any ride that lasted less than 1 minute or more than 24 hours. To do this, I added and updated a new column to store ride length in minutes using the following syntax
```sql
ALTER TABLE FULL_YEAR_DATASET
ADD Ride_length_in_minutes INT;
UPDATE FULL_YEAR_DATASET
SET Ride_length_in_minutes = DATEDIFF(Minute, '00:00:00', ride_length);
```
- Checking for invalid ride lengths using ride length in minutes column
  
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
```
- Finally, I checked for invalid latitude and longitude values. There was 1 invalid start latitude values of “-73.7964782714844”.
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
from FULL_YEAR_DATASET
where end_lng < -90 OR end_lng > -80
```

#### Data Cleaning: 

Before analyzing the data, the dataset was cleaned by:

 - Removing the trips with null values. A total of 1,622,582 rows were affected
 - I dropped columns irrelevant for my analysis:
 - I removed duplicate rows
 - I removed invalid ride lengths with duration less than a minute or longer than a day.
 - I removed invalid latitudinal row
 - Changed days of the week column from numbers to text
  
### 4. ANALYZE PHASE

The goal of the analysis phase is to explore trends in the data and answer the business question “How do annual members and casual riders use Cyclistic bikes differently?” For the first part of my analysis, I used SQL to aggregate data into the summary statistics below; 

> 1 Total number of rides
>
> 2 Types of Bike
>
> 3 Average ride duration by member type
>
> 4 Average ride duration per month and day of the week by member type
>
> 5 Number of rides per month and day of the week by member type 

Then took the cleaned data PowerBi for analysis and the figures plotted are displayed in the following:

### - Total number of rides in 2022
The figure below shows the total number of rides carried out by Cyclistic members and casual riders in 2022.

![Total Number of rides](https://github.com/user-attachments/assets/fa317def-e537-4720-98b6-975f25aaa31f)

![Total ride](https://github.com/user-attachments/assets/276b9e59-3150-4959-bfe4-f23897abd76c)
- The total number of rides from January 2022 to December 2022 is **5,532,775**
- **Cyclistic members** recorded a **greater bicycle activity** than casual riders. The total rides for Cyclistic members are 3,266,968 while 2,265,807 trips for casual riders. 
- **Cyclistic members** accounted for about **59%** of total rides whereas casual riders made up **41%** of total rides in 2022. 
<br>

### - Types of Bike
The types of bicycles used for the trips are displayed as follow:

![Types of Bike](https://github.com/user-attachments/assets/26703a03-83e7-44ea-af45-3fb902611a53)
- There are **three types of bicycles**: <ins>*classic, electric and docked bikes*</ins>.
- Cyclistic members shows a higher preference for **electric bikes**.
- Cyclistic members shows a higher preference for **classic bikes**
- Docked bicycles are mostly used by casual riders. 
<br>

### - Average Ride Duration
The average ride length is plotted against the type of users (member vs. casual):

![Average ride](https://github.com/user-attachments/assets/b516deb2-1bf3-4f14-b699-4b672cf31fb5)
- **Cyclistic members** has an average ride length for about **12.17 minutes** whereas **casual riders** have an average ride length of **24.71 minutes**. Hence, the ride duration of Cyclistic members is lesser than casual riders.
<br>

### - Average Ride Duration By Month

![Average ride length by Month](https://github.com/user-attachments/assets/caa57a4b-1165-4eac-879a-9add1b5fd35f)
- The monthly average ride duration for **Cyclistic members** is the **highest** in **June** (13.43 minutes).
- For **casual riders**, the **highest** mean trip duration is in **May** (25.24 minutes).
<br>

### - Average Ride Duration by Day of the Week

![Average ride by day of the week](https://github.com/user-attachments/assets/465dbf79-39ff-4daf-98b8-eeeb2896be9d)
- Generally, bike rides are **most frequented** during weekends **Saturdays and Sundays**.
- **Cyclistic members** cycled the **longest on Sunday** with an average ride length of 13.61 minutes and the ***lowest on Tuesday** with an average ride length of 11.55 minutes.
- On the other hand, **casual riders cycled the longest on Sunday** with a mean trip duration of 24.94 minutes and the **lowest on Wednesday** with an average ride length of 18.71 minutes.
<br>

### - Number of Rides by Month
![Number of rides by Month](https://github.com/user-attachments/assets/4631f055-c1c5-4967-9858-0e8fa1bdd2cf)
- Both Cyclistic members and casual riders have the **lowest activity**, 83,598 rides and 18,048 rides respectively in **January 2022**.
- **Cyclistic members** have the **highest activity** (417,119 rides) in **August 2022**.
- **Casual riders** have the **greatest activity** (395,824 rides) in **July 2022**.
<br>

### - Number of Rides by Day of the week
![Number of rides by Days of the week](https://github.com/user-attachments/assets/e8cf06b1-22fc-40b4-bd0e-e344867cbe6b)
- **Cyclistic members** have the **highest activity** (519,984 rides) on **Thursdays** while the **lowest activity** (377,494 rides) on **Mondays**.
- **Casual riders** have the **highest activity** (461,673 rides) on **Saturdays** while the **least activity** (257,318 rides) on **Tuesdays**.
<br>

### 6. Share phase (PowerBi full visuals) then also answer the question regarding similarities and differences between casual riders and annual members.
<img width="752" alt="Bike share visualization" src="https://github.com/user-attachments/assets/4efe4190-50eb-4d02-8447-0d078cba3345" />

The similiarities and differences between Cyclistic members and casual riders were drawn from the above analysis. Thus:

**Differences:**

1. Ride Volume by Membership Type:
Cyclistic members account for a larger proportion of total rides (59%) compared to casual riders (41%).

3. Bike Type Preference:
Cyclistic members favor electric bikes (1,583,654 rides), followed by classic bikes (1,683,314 rides).
Casual riders, on the other hand, use classic bikes less frequently (876,127 rides) than electric bikes (1,216,337 rides).

5. Average Ride Length:
Casual riders take significantly longer rides (21.74 minutes on average) compared to Cyclistic members (12.17 minutes on average).
This trend holds across all months and days of the week, with casual riders consistently logging higher average ride durations.

7. Ride Patterns by Day of the Week:
Casual riders show increased activity during weekends (Saturday and Sunday).
Cyclistic members, however, maintain a consistent number of rides across all weekdays, indicating more regular use for commuting or daily activities.

9. Seasonal Patterns:
Casual riders show a sharp increase in rides during summer months (e.g., June, July, and August), suggesting they are more influenced by seasonal and recreational factors.
Cyclistic members also peak during these months but show steadier ride patterns throughout the year.

**Similarities:**

1. Preference for Electric Bikes:
Both groups show a strong preference for electric bikes over classic bikes.
2. Usage Peaks in Summer:
Both casual riders and Cyclistic members increase their usage during the summer months, reflecting the impact of favorable weather on bike usage.
3. Day-Specific Trends:
Both groups experience increased activity on weekends, although the rise is more pronounced for casual riders.


### 7. ACT PHASE 

To effectively convert casual riders into Cyclistic members, the marketing strategies should address the behavioral patterns of casual riders while highlighting the value proposition of becoming a member. Based on the analysis above, here are some recommendations:

1. Promote Membership Benefits for Longer Rides:
Casual riders take significantly longer rides. Highlight the cost-effectiveness of membership plans for long-duration trips by emphasizing savings and unlimited ride benefits.

2. Seasonal Discounts and Promotions:
Casual riders are highly active during summer months. Launch seasonal membership promotions in spring and early summer to capture this audience and offer trial memberships for summer.

3. Weekend-Focused Membership Perks:
Casual riders are more active on weekends. Develop weekend-specific membership options with exclusive benefits tailored for leisure riders.

4. Incentivize First-Time Memberships:
To lower the barrier to entry, offer special incentives for first-time memberships, such as discounted rates, bonus ride credits, or exclusive perks.

5. Highlight Convenience for Frequent Users:
Educate casual riders about the convenience and utility of membership for routine activities like commuting or running errands.

6. Gamify Membership Engagement:
Implement a rewards system for members, where points can be earned through frequent rides and redeemed for discounts or exclusive benefits. Introduce seasonal challenges to engage users.

7. Targeted Digital Marketing and CommunicationL:
Use location-based ads near bike stations or recreational areas to promote memberships. Send personalized emails or app notifications to casual riders offering exclusive membership discounts after their rides.

8. Offer Flexible Membership Options:
Provide monthly or pay-as-you-go membership options to reduce commitment concerns. Include incentives for upgrading to annual plans.

9. Promote Environmental and Wellness Benefits:
Appeal to eco-conscious casual riders by emphasizing the sustainability of bike-sharing and the fitness benefits of regular cycling as a member.

10. Partner with Local Businesses and Events:
Collaborate with local attractions, cafes, or events to offer exclusive member perks and organize community bike events to engage casual riders and promote memberships.

### **CONCLUSION**

These strategies leverage casual riders' behavior (longer rides, weekend focus, summer activity) and address their potential barriers to becoming members (cost, flexibility, and commitment). Combining seasonal promotions, personalized communication, and tailored membership plans can create a seamless conversion pipeline for casual riders.
