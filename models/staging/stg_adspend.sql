
{{ config(schema="staging", materialized = 'incremental', unique_id = 'unique_id', tags=["staging"]) }}

with raw_adspend as (
    select * from {{ ref('raw_ad_spend_batch1') }}
    union all
    select * from {{ ref('raw_ad_spend_batch2') }}
),

channel_mapping as (
    select * from {{ ref('raw_seed_channel_map') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['date','channel','campaign_id']) }} as unique_id,
    date,
    trim(channel) as channel,
    channel_mapping.canonical_channel,
    channel_mapping.paid_flag,
    trim(campaign_id) as campaign_id,
    sum(impressions) as impressions,
    sum(clicks) as clicks,
    sum({{ parse_money('cost_text') }}) as cost_usd
from raw_adspend
left join channel_mapping
    on trim(raw_adspend.channel) = trim(channel_mapping.raw_channel)
group by all
{% if is_incremental() %}
where date > (select max(date) from {{ this }})
{% endif %}