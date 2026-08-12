-- Product page abandonment rate by product: sessions reached vs. sessions ending without continuing to Cart
with sessions_ending_at_product_page as 
(select
	website_session_id
from temp_session_pageview
where stage_group = 'product_page'
and is_last_pageview = 1)

select 
	pageview_url,
	count(tsp.website_session_id) as sessions_reached,
	count(sep.website_session_id) as sessions_abandoned,
	round(count(sep.website_session_id) * 100.0 / count(tsp.website_session_id)) as abandonment_pct
from temp_session_pageview tsp
left join sessions_ending_at_product_page sep
	on tsp.website_session_id = sep.website_session_id
where stage_group = 'product_page'
group by pageview_url
order by abandonment_pct desc