-- Billing page A/B test: overlap-window conversion comparison, using raw pageview_url to distinguish billing verions

select
    pageview_url as billing_version,
    count(t.website_session_id) as sessions,
    count(o.order_id) as orders,
    round(count(o.order_id) * 100.0 / count(t.website_session_id),2) as conversion_pct
from temp_session_pageview t
left join orders o
    on t.website_session_id = o.website_session_id
where date(t.created_at) between '2012-09-10' and '2013-01-05'
  and pageview_url in ('/billing', '/billing-2')
group by pageview_url

-- A/B Test pt 2: Trended over time
-- Results exported to create Tableau report

select
    to_char(t.created_at, 'YYYY-MM') as month_year,
    pageview_url as billing_version,
    count(t.website_session_id) as sessions,
    count(o.order_id) as orders,
    round(count(o.order_id) * 100.0 / (count(t.website_session_id)),2) as conversion_pct
from temp_session_pageview t
left join orders o
    on t.website_session_id = o.website_session_id
where pageview_url in ('/billing', '/billing-2')
group by month_year, billing_version
order by month_year, billing_version