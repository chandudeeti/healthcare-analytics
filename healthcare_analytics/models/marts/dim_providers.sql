with providers as(
    select
        provider_id,
        organization_id,
        provider_name,
        provider_gender,
        provider_speciality,
        address,
        city,
        state,
        zip_code,
        utilization
    from {{ ref('stg_providers') }}
),
final as (
select
    {{ dbt_utils.generate_surrogate_key(['provider_id'])}} as provider_key,
        provider_id,
        organization_id,
        provider_name,
        provider_gender,
        provider_speciality,
        address,
        city,
        state,
        zip_code,
        utilization
from providers

)

select * from final