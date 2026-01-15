{% macro parse_money(col) -%}
--remove any charcter that is not 0-9, ., or -.
--r'' tells SQL: “Do not process backslashes”
SAFE_CAST(REGEXP_REPLACE(TRIM(CAST({{ col }} AS STRING)), r'[^0-9.\-]', '') AS
NUMERIC)
{%- endmacro %}