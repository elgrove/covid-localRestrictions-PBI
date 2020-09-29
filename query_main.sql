with prod as 
(select article_id, 'C19' as C19
from ecom_lab.al_c19_prod)

,

dt as
(
select
cast(year*10000+month*100+day as string) as datestr
, prod.C19
, purchase_channel
, delivery_channel
, case when tl.purchase_channel = 'ONLINE' then tl.delivery_post_code else sto.post_code end as postcode
, week_id
, art.l2_name
, art.l4_name
, count(distinct case when purchase_channel = 'POS' then basket_id else order_number end) as orders
, sum(sales_amt) as rev
, sum(item_qty) as units
from analytics.all_transaction_line tl
join analytics.lu_article art on tl.article_id = art.article_id
join analytics.lu_store sto on tl.store_id = sto.store_id
left join prod on tl.article_id = prod.article_id
where year*10000+month*100+day between
year(date_sub(current_timestamp(), 14)) * 10000 + month(date_sub(current_timestamp(), 14)) * 100  + day(date_sub(current_timestamp(), 14))
and 
year(date_sub(current_timestamp(), 1)) * 10000 + month(date_sub(current_timestamp(), 1)) * 100  + day(date_sub(current_timestamp(), 1))
and trans_line_type = 'S'
and (art.l1_id = 'FD' and purchase_channel = 'ONLINE') 
group by 1,2,3,4,5,6,7,8
)


select 
datestr
, week_id
, C19
, l2_name
, l4_name
, purchase_channel
, delivery_channel
, la.lau_name
, sum(orders) as orders
, sum(units) as units
, sum(rev) as revenue
from dt
join ecom_lab.al_postcode_la la on dt.postcode = la.pcds
group by 1,2,3,4,5,6,7,8