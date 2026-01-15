{% macro json_text(json_col, key) -%}
--extract value by key from a json column
JSON_VALUE({{ json_col }}, '$.{{ key }}')
{%- endmacro %}