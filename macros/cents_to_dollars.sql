
{#
copy and paste the logic you want inbetween the macro comments
you can add an argument/arguments in the brackets to make it more dynamic

#}


{% macro cents_to_dollars(column_name, decimal_places=2) -%}

round( 1.0* {{column_name}} /100.0, {{decimal_places}})

{%- endmacro %}