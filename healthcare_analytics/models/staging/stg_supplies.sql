with source as (
    select * from {{ source('raw', 'supplies') }}
),
renamed as (
    select
        "DATE"        as supply_date,
        patient       as patient_id,
        encounter     as encounter_id,
        code          as supply_code,
        description   as supply_description,
        quantity
    from source
)
select * from renamed