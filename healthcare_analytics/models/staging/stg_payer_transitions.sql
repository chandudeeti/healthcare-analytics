with source as (
    select * from {{ source('raw', 'payer_transitions') }}
),
renamed as (
    select
        patient       as patient_id,
        start_year,
        end_year,
        payer         as payer_id,
        ownership
    from source
)
select * from renamed