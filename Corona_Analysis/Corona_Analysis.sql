use project1;

-- Write a code to check NULL values
SELECT 
    SUM(IF(country IS NULL, 1, 0)) AS country_null_count,
    SUM(IF(Province IS NULL, 1, 0)) AS province_null_count,
    SUM(IF(latitude IS NULL, 1, 0)) AS latitude_null_count,
    SUM(IF(longitude IS NULL, 1, 0)) AS longitude_null_count,
    SUM(IF(date_of IS NULL, 1, 0)) AS date_of_null_count,
    SUM(IF(recovered IS NULL, 1, 0)) AS recovered_null_count,
    SUM(IF(Deaths IS NULL, 1, 0)) AS deaths_null_count,
    SUM(IF(confirmed IS NULL, 1, 0)) AS confirmed_null_count
FROM corona;

-- If NULL values are present, update them with zeros for all columns. 
UPDATE corona SET country = COALESCE(country, '0') WHERE country IS NULL;
UPDATE corona SET Province = COALESCE(Province, '0') WHERE Province IS NULL;
UPDATE corona SET latitude = COALESCE(latitude, 0) WHERE latitude IS NULL;
UPDATE corona SET longitude = COALESCE(longitude, 0) WHERE longitude IS NULL;
UPDATE corona SET date_of = COALESCE(date_of, '0') WHERE date_of IS NULL;
UPDATE corona SET recovered = COALESCE(recovered, 0) WHERE recovered IS NULL;
UPDATE corona SET Deaths = COALESCE(Deaths, 0) WHERE Deaths IS NULL;
UPDATE corona SET confirmed = COALESCE(confirmed, 0) WHERE confirmed IS NULL;

--  check total number of rows
SELECT COUNT(*) AS total_rows FROM corona;

--  Check what is start_date and end_date
SELECT 
    MIN(date_of) AS start_date,
    MAX(date_of) AS end_date
FROM corona;

--  Number of month present in dataset
SELECT DATE_FORMAT(date_of, '%Y-%m') AS month,COUNT(*) AS month_count
FROM corona
GROUP BY month
ORDER BY month;

-- monthly average for confirmed, deaths, recovered
SELECT DATE_FORMAT(date_of, '%Y-%m') AS month,AVG(confirmed) AS avg_confirmed,AVG(deaths) AS avg_deaths,
AVG(recovered) AS avg_recovered
FROM corona
GROUP BY month
ORDER BY month;

-- most frequent value for confirmed, deaths, recovered each month 
SELECT  month,
    (
        SELECT confirmed FROM corona c2 WHERE DATE_FORMAT(c2.date_of, '%Y-%m') = month
        GROUP BY confirmed ORDER BY COUNT(*) DESC LIMIT 1
    ) AS most_frequent_confirmed,
    (
        SELECT deaths FROM corona c2 WHERE DATE_FORMAT(c2.date_of, '%Y-%m') = month 
        GROUP BY deaths ORDER BY COUNT(*) DESC LIMIT 1
    ) AS most_frequent_deaths,
    (
        SELECT recovered FROM corona c2 WHERE DATE_FORMAT(c2.date_of, '%Y-%m') = month
        GROUP BY recovered ORDER BY COUNT(*) DESC LIMIT 1
    ) AS most_frequent_recovered
FROM (
    SELECT DISTINCT DATE_FORMAT(date_of, '%Y-%m') AS month FROM corona
) AS months
ORDER BY month;

-- minimum values for confirmed, deaths, recovered per year
SELECT YEAR(date_of) AS year,Min(confirmed) AS min_confirmed,Min(deaths) AS min_deaths,
Min(recovered) AS min_recovered
FROM corona
GROUP BY YEAR(date_of)
ORDER BY YEAR(date_of);

-- Find maximum values of confirmed, deaths, recovered per year
SELECT YEAR(date_of) AS year,Max(confirmed) AS max_confirmed,Max(deaths) AS max_deaths,
Max(recovered) AS max_recovered
FROM corona
GROUP BY YEAR(date_of)
ORDER BY YEAR(date_of);

-- The total number of case of confirmed, deaths, recovered each month
SELECT DATE_FORMAT(date_of, '%Y-%m') AS month,SUM(confirmed) AS total_confirmed,SUM(deaths) AS total_deaths,
SUM(recovered) AS total_recovered
FROM corona
GROUP BY DATE_FORMAT(date_of, '%Y-%m')
ORDER BY month;


--  calculating corona virus spread with respect to confirmed case
--      ( total confirmed cases, their average, variance & STDEV )
SELECT 
     SUM(confirmed)  AS total_confirmed_cases,
     AVG(confirmed) AS average_confirmed_cases,
    VARIANCE(confirmed)  AS variance_confirmed_cases,
     STDDEV(confirmed)  AS stddev_confirmed_cases
from corona;


-- Calculating visus spread with respect to death case per month
-- ( total confirmed cases, their average, variance & STDEV )
SELECT 
    DATE_FORMAT(date_of, '%Y-%m') AS month,ROUND(SUM(deaths), 2) AS total_death_cases,ROUND(AVG(deaths), 2) AS average_death_cases,
    ROUND(VARIANCE(deaths), 2) AS variance_death_cases,ROUND(STDDEV(deaths), 2) AS stddev_death_cases
FROM corona
GROUP BY DATE_FORMAT(date_of, '%Y-%m')
ORDER BY month;


-- Calculating corona virus spread  with respect to recovered case
-- (total confirmed cases, their average, variance & STDEV )
SELECT 
    DATE_FORMAT(date_of, '%Y-%m') AS month,ROUND(SUM(recovered), 2) AS total_recovered_cases,
    ROUND(AVG(recovered), 2) AS average_recovered_cases,ROUND(VARIANCE(recovered), 2) AS variance_recovered_cases,
    ROUND(STDDEV(recovered), 2) AS stddev_recovered_cases
FROM corona
GROUP BY DATE_FORMAT(date_of, '%Y-%m')
ORDER BY month;


-- Country having highest number of the Confirmed case
SELECT country,Sum(confirmed) AS highest_confirmed_cases
FROM corona
GROUP BY country
ORDER BY highest_confirmed_cases DESC
LIMIT 1;

-- Find Country having lowest number of the death case
SELECT country,SUM(deaths) AS total_death_cases
FROM corona
GROUP BY country
ORDER BY total_death_cases
LIMIT 4;

-- Find top 5 countries having highest recovered case
SELECT country,SUM(recovered) AS total_recovered_cases
FROM corona
GROUP BY country
ORDER BY total_recovered_cases DESC
LIMIT 5;











