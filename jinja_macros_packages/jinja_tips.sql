
{#
--Setting a variable

        {% set my_cool_string = 'wow! Cool!'%}
        {% set my_second_cool_string = 'wow! soooo cooool '%}
        {% set my_second_cool_number = 100%}

        {{ my_cool_string }}{{ my_second_cool_string}} I want to write jinja for {{ my_second_cool_number}} years

   these brackets is how you write a comment  


-- Now creating a list

        {% set my_animals = ['lemur', 'wolf', 'panther', 'dog']%}

        {{ my_animals[0] }}


--Making a for loop, changes the 'animal variable each time'

    {% for animal in my_animals  %}

        My favourite animal is the {{animal}}

    {% endfor %}



  

   -- Now creating an if statement

   {% set temperature = 45 %}

   {% if temperature< 65 %}
    Time for coffee

    {% else %}
    Time for a cold brew!

    {% endif %}

     

-- Now nesting the two together
-- i thought his was acomment {%- -%} Removes white space


    {%- set foods = ['carrot', 'hotdog', 'cucumber', 'bell pepper'] -%}

    {%- for food in foods -%}
        {%- if food == 'hotdog' -%}
            {%- set food_type = 'snack'-%}
        {%- else -%}
            {%- set food_type = 'vegetable'-%}
        {%- endif -%}
        
        The humble {{ food }} is my favourite {{ food_type }}

    {% endfor %}
#}

--Using a diction to call pairs

{%- set websters_dict = {
    'word': 'data',
    'speech_part': 'noun',
    'definition': 'if you know you know'
} -%}

{{ websters_dict['word']}}({{ websters_dict['speech_part']}}: defined as "{{ websters_dict['definition']}}")











