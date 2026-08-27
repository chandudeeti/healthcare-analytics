with conditions as (

    select
        patient_id,
        condition_description
    from {{ ref('stg_conditions') }}

),

patient_chronic_conditions as (

    select
        patient_id,

        count(
            distinct case
                when condition_description in (
                    'Hypertension',
                    'Diabetes',
                    'Prediabetes',
                    'Coronary Heart Disease',
                    'Chronic congestive heart failure (disorder)',
                    'Osteoporosis (disorder)',
                    'Hyperlipidemia',
                    'Body mass index 30+ - obesity (finding)',
                    'Chronic sinusitis (disorder)',
                    'Chronic pain'
                )
                then condition_description
            end
        ) as chronic_condition_count,

        max(
            case
                when condition_description = 'Hypertension'
                then 1
                else 0
            end
        ) = 1 as has_hypertension,

        max(
            case
                when condition_description = 'Diabetes'
                then 1
                else 0
            end
        ) = 1 as has_diabetes,

        max(
            case
                when condition_description = 'Prediabetes'
                then 1
                else 0
            end
        ) = 1 as has_prediabetes,

        max(
            case
                when condition_description = 'Coronary Heart Disease'
                then 1
                else 0
            end
        ) = 1 as has_coronary_heart_disease,

        max(
            case
                when condition_description = 'Chronic congestive heart failure (disorder)'
                then 1
                else 0
            end
        ) = 1 as has_chf,

        max(
            case
                when condition_description = 'Osteoporosis (disorder)'
                then 1
                else 0
            end
        ) = 1 as has_osteoporosis,

        max(
            case
                when condition_description = 'Hyperlipidemia'
                then 1
                else 0
            end
        ) = 1 as has_hyperlipidemia,

        max(
            case
                when condition_description = 'Body mass index 30+ - obesity (finding)'
                then 1
                else 0
            end
        ) = 1 as has_obesity,

        max(
            case
                when condition_description = 'Chronic sinusitis (disorder)'
                then 1
                else 0
            end
        ) = 1 as has_chronic_sinusitis,

        max(
            case
                when condition_description = 'Chronic pain'
                then 1
                else 0
            end
        ) = 1 as has_chronic_pain

    from conditions

    group by patient_id

),

final as (

    select
        patient_id,
        chronic_condition_count,
        has_hypertension,
        has_diabetes,
        has_prediabetes,
        has_coronary_heart_disease,
        has_chf,
        has_osteoporosis,
        has_hyperlipidemia,
        has_obesity,
        has_chronic_sinusitis,
        has_chronic_pain,

        chronic_condition_count >= 2 as is_high_risk

    from patient_chronic_conditions

)

select *
from final