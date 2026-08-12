--Cross-Field Consistency
	 
-- 1. Does orders.items_purchased match the count of order_items.order_item_id per order?

select
	o.order_id,
	o.items_purchased,
	count(oi.order_item_id) as actual_item_count
from orders o
left join order_items oi
	on o.order_id = oi.order_id
group by o.order_id , o.items_purchased
having o.items_purchased !=count(oi.order_item_id)

-- 2. Does orders.price_usd match the sum of order_items.price_usd for that order?

select
	o.order_id,
	o.price_usd  as orders_price,
	sum(oi.price_usd) as order_items_price
from orders o
left join order_items oi
	on o.order_id = oi.order_id
group by o.order_id , o.price_usd 
having o.price_usd != sum(oi.price_usd)

-- 3. Does the orders.cogs match the sum of order_items.cogs for that order

select
	o.order_id,
	o.cogs_usd as orders_cogs,
	sum(oi.cogs_usd) as order_items_cogs
from orders o
left join order_items oi
	on o.order_id = oi.order_id
group by o.order_id , o.cogs_usd
having o.cogs_usd != sum(oi.cogs_usd)

-- 4. Does every order have exactly one order_item flagged as the primary item?

select 
	o.order_id,
	sum(oi.is_primary_item) as primary_item_count
from orders o
left join order_items oi 
	on o.order_id = oi.order_id 
group by o.order_id
having sum(oi.is_primary_item) != 1

-- 5. Does order_items.product_id (for the primary item) match orders.primary_product_id?

select 
	o.order_id,
	o.primary_product_id,
	oi.product_id
from orders o
left join order_items oi 
	on o.order_id = oi.order_id 
where oi.is_primary_item = 1
and o.primary_product_id != oi.product_id 

-- 6. Does order_item_refunds.order_id match the order_id of the order_item it references (order_items.order_id)?
select *
from order_item_refunds oir 
left join order_items oi 
	on oir.order_item_id = oi.order_item_id 
where oir.order_id != oi.order_id 

--===================

-- Value / Logic Checks

-- 1. Does any refund amount exceed the price of the item being refunded?
select *
from order_item_refunds oir
left join order_items oi
	on oir.order_item_id = oi.order_item_id
where oir.refund_amount_usd > oi.price_usd

-- 2. Are there any negative values in price_usd, cogs_usd, or refund_amount_usd?
select 
	o.price_usd,
	o.cogs_usd,
	oi.price_usd,
	oi.cogs_usd,
	oir.refund_amount_usd 
from orders o
left join order_items oi
	on o.order_id = oi.order_id 
left join order_item_refunds oir 
	on oi.order_item_id = oir.order_item_id
where 
	o.price_usd < 0
	or o.cogs_usd < 0
	or oi.price_usd < 0
	or oi.cogs_usd < 0
	or oir.refund_amount_usd <0 

-- 3. Does a website session always precede the order timestamp?
select
	o.order_id,
	o.created_at as time_of_order,
	ws.created_at as time_of_website_session
from orders o
left join website_sessions ws 
	on o.website_session_id = ws.website_session_id 
where ws.created_at > o.created_at 

-- 4. Does an order always precede the return timestamp?
select
	o.order_id,
	oir.created_at as time_of_refund,
	o.created_at as time_of_order
from order_item_refunds oir 
left join orders o
	on oir.order_id = o.order_id 
where oir.created_at < o.created_at 