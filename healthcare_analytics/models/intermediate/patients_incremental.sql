{{
  config(
    materialized = 'incremental',
    unique_key = 'id',
    incremental_startegy='merge'
    )
}}

with source as (
    {% if is_incremental() %}
      select * from {{ source('raw', 'patients_batch2') }}
    {% else %}
      select * from {{ source('raw', 'patients') }}
    {% endif %}
)

select * from source