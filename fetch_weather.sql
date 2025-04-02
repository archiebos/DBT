{% macro fetch_weather() %}
    {% do run_query("CALL DBT_COURSE.WEATHER.DBT_FETCH_WEATHER('"+ target.schema +"');")%}
{% endmacro %}