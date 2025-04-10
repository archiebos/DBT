
{#
--Setting a variable

    {% set my_cool_string = 'wow! Cool!'%}
    {% set my_second_cool_string = 'wow! soooo cooool '%}
    {% set my_second_cool_number = 100%}

    {{ my_cool_string }}{{ my_second_cool_string}} I want to write jinja for {{ my_second_cool_number}} years

   these brackets is how you write a comment #} 

    -- Now creating a list

   {% set my_animals = ['lemur', 'wolf', 'panther', 'dog']%}

   {{my_animals[0]}}
   {{my_animals[1]}}
   {{my_animals[2]}}
   {{my_animals[3]}}