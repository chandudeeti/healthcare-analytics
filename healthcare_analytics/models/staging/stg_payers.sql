with source as (
    select * from {{ source('raw', 'payers') }}
),
renamed as (
    select
        id                          as payer_id,
        name                        as payer_name,
        address,
        city,
        state_headquartered,
        zip                         as zip_code,
        phone,
        amount_covered,
        amount_uncovered,
        revenue,
        covered_encounters,
        uncovered_encounters,
        covered_medications,
        uncovered_medications,
        covered_procedures,
        uncovered_procedures,
        covered_immunizations,
        uncovered_immunizations,
        unique_customers,
        qols_avg,
        member_months
    from source
)
select * from renamed