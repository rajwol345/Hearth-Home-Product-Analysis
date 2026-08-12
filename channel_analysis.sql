-- Channel performance comparison: sessions, orders, conversion rate, revenue, and gross profit by acquisition channel (paid search, organic, direct)
select 
case
	when utm_source = 'gsearch' then 'google (paid)'
	when utm_source = 'bsearch' then 'bing(paid)'
	when utm_source isnull and http_referer is not null then 'organic search'
	when utm_source isnull and http_referer isnull then 'direct search'
end as channel_type,
	count(ws.website_session_id) as sessions,
	count(o.order_id) as orders,
	round(count(o.order_id) * 100.0 / count(ws.website_session_id),2) as pct,
	sum(o.price_usd) as total_revenue,
	sum(o.price_usd - o.cogs_usd) as gross_profit,
	sum(o.price_usd - o.cogs_usd) / count(o.order_id) as avg_gross_profit_per_order
from website_sessions ws 
left join orders o
	on ws.website_session_id = o.website_session_id
group by channel_type
order by sessions desc

---Channel performance trended by month: sessions, orders, conversion rate, revenue, and gross profit by acquisition channel (paid search, organic, direct)
-- Results exported to create Tableau report
select 
to_char(ws.created_at, 'YYYY-MM') as year_month,
case
	when utm_source = 'gsearch' then 'google (paid)'
	when utm_source = 'bsearch' then 'bing(paid)'
	when utm_source isnull and http_referer is not null then 'organic search'
	when utm_source isnull and http_referer isnull then 'direct search'
end as channel_type,
	count(ws.website_session_id) as sessions,
	count(o.order_id) as orders,
	round(count(o.order_id) * 100.0 / count(ws.website_session_id),2) as pct,
	sum(o.price_usd) as total_revenue,
	sum(o.price_usd - o.cogs_usd) as gross_profit,
	sum(o.price_usd - o.cogs_usd) / count(o.order_id) as avg_gross_profit_per_order
from website_sessions ws 
left join orders o
	on ws.website_session_id = o.website_session_id
group by year_month, channel_type
order by channel_type, year_month