{% macro test_positive_value(model, column_name) %}
    SELECT COUNT(*)
    FROM {{ model }}
    WHERE {{ column_name }} <= 0
{% endmacro %}
