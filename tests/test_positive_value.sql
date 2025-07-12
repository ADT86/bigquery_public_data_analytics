-- Custom test to ensure values are positive
SELECT *
FROM {{ ref(model) }}
WHERE {{ column_name }} <= 0
