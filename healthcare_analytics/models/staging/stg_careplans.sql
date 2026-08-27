with source as (
    select * from {{ source('raw', 'careplans') }}
),
renamed as(
select
    id                      as careplan_id,
    "START"                 as careplan_start,
    "STOP"                  as careplan_stop,
    patient                 as patient_id,
    encounter               as encounter_id,
    code                    as careplan_code,
    description             as careplan_description,
    reasoncode              as reason_code,
    reasondescription       as reason_description
from source
)

select * from renamed