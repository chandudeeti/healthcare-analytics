with covid_hospitalizations as (
select
    encounter_id,
    patient_id,
    covid_status,
    encounter_start,
    encounter_stop,
    length_of_stay_days,
    used_ventilator,
    died_during_encounter,
    total_claim_cost,
    payer_coverage,
    --patient_responsibility,
from {{ ref('int_covid_hospitalizations') }}
),
patients as (
    select
        patient_id,
        patient_key
    from {{ ref('dim_patients') }}
),
joined as (
select
    c.encounter_id,
    p.patient_key,
   -- c.patient_id,
    c.covid_status,
    c.encounter_start,
    c.encounter_stop,
    c.length_of_stay_days,
    c.used_ventilator,
    c.died_during_encounter,
    c.total_claim_cost,
    c.payer_coverage
from covid_hospitalizations c
left join patients p on c.patient_id = p.patient_id
)

select * from joined