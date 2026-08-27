with observations as (

    select
        encounter_id,
        patient_id,
        observation_description,
        observation_value
    from {{ ref('stg_observations') }}

),

encounter_vitals as (

    select
        encounter_id,
        patient_id,

        max(
            case
                when observation_description = 'Oxygen saturation in Arterial blood'
                then try_cast(observation_value as float)
            end
        ) as oxygen_saturation_pct,

        max(
            case
                when observation_description = 'Body temperature'
                then try_cast(observation_value as float)
            end
        ) as body_temperature,

        max(
            case
                when observation_description = 'Heart rate'
                then try_cast(observation_value as float)
            end
        ) as heart_rate,

        max(
            case
                when observation_description = 'Respiratory rate'
                then try_cast(observation_value as float)
            end
        ) as respiratory_rate,

        max(
            case
                when observation_description = 'Systolic Blood Pressure'
                then try_cast(observation_value as float)
            end
        ) as blood_pressure_systolic,

        max(
            case
                when observation_description = 'Diastolic Blood Pressure'
                then try_cast(observation_value as float)
            end
        ) as blood_pressure_diastolic

    from observations

    group by
        encounter_id,
        patient_id

)

select *
from encounter_vitals