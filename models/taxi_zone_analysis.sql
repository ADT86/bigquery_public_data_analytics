{{ config(materialized='view') }}

-- NYC Taxi Zone Analysis
-- This model analyzes pickup patterns by location
SELECT 
    pickup_location_id,
    'Zone_' || CAST(pickup_location_id AS STRING) as zone_name,
    COUNT(*) as daily_trips,
    ROUND(AVG(fare_amount), 2) as avg_fare,
    ROUND(AVG(trip_distance), 2) as avg_distance
FROM 
    `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2018`
WHERE 
    pickup_datetime >= '2018-01-01'
    AND pickup_datetime < '2018-01-02'  -- Single day for demo
    AND pickup_location_id IS NOT NULL
    AND fare_amount > 0
    AND trip_distance > 0
GROUP BY 
    pickup_location_id
HAVING 
    COUNT(*) >= 10  -- Only zones with at least 10 trips
ORDER BY 
    daily_trips DESC
LIMIT 20
