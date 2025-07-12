{{ config(materialized='view') }}

-- NYC Taxi Trip Summary using BigQuery public dataset
-- This model aggregates taxi trip data by date
SELECT 
    DATE(pickup_datetime) as pickup_date,
    COUNT(*) as total_trips,
    ROUND(AVG(trip_distance), 2) as avg_trip_distance,
    ROUND(AVG(fare_amount), 2) as avg_fare_amount,
    ROUND(AVG(total_amount), 2) as avg_total_amount
FROM 
    `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2018`
WHERE 
    pickup_datetime >= '2018-01-01'
    AND pickup_datetime < '2018-02-01'  -- Limit to January 2018 for performance
    AND fare_amount > 0
    AND trip_distance > 0
GROUP BY 
    DATE(pickup_datetime)
ORDER BY 
    pickup_date
