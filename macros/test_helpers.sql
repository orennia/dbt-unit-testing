{% macro extract_columns(query) %}
  {% if execute %}
    {% set results = run_query(query) %}
    {%- for column in results.columns -%}
      {{ dbt_unit_testing.quote_column_name(column.name) }}
    {%- if not loop.last -%}
      ,
    {%- endif -%}
    {% endfor %}
  {%- endif -%}
{% endmacro %}

{% macro extract_columns_list(query) %}
  {% set results = run_query(query) %}
  {% if execute %}
    {% do return(results.columns | map(attribute='name') | map('lower') | list) %}
  {% else %}
    {% do return([]) %}
  {% endif %}
{% endmacro %}

{% macro extract_columns_difference_as_nulls(columns, query2) %}
  {% set cl2 = dbt_unit_testing.extract_columns_list(query2) %}
  {% set columns = columns | list | reject('in', cl2) %}
  {%- for column in columns -%}
    null as {{column}},
  {%- endfor -%}
{% endmacro %}

{% macro sql_encode(s) %}
  {%- do return (s.replace('"', '$$$$$$$$$$').replace('\n', '##########')) %}
{% endmacro %}

{% macro sql_decode(s) %}
  {%- do return (s.replace('$$$$$$$$$$', '"').replace('##########', '\n')) -%}
{% endmacro %}

{% macro debug(value) %}
  {% do log (value, info=true) %}
{% endmacro %}

{% macro sql_except() -%}
    {{ return(adapter.dispatch('sql_except','dbt_unit_testing')()) }}
{%- endmacro %}

{% macro default__sql_except() -%}
    EXCEPT
{%- endmacro %}

{% macro bigquery__sql_except() %}
    EXCEPT DISTINCT
{% endmacro %}
