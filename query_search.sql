select 
cast(year*10000+month*100+day as string) as datestr
, la.lau_name
, case
when
locate('|', crw.post_prop2) = 4
and locate('|', crw.post_prop2, 5) = 15
then strright(crw.post_prop2, length(crw.post_prop2)-16)
when 
locate('|', crw.post_prop2) = 4
and locate('|', crw.post_prop2, 5) = 0
then strright(crw.post_prop2, length(crw.post_prop2)-5)
else crw.post_prop2
end as search_term
, count(distinct concat(post_visid_high, post_visid_low, cast(visit_num as string), cast(visit_start_time_gmt as string))) as visits
from clickstream_raw_prod.clk_raw crw
join ecom_lab.al_postcode_la la on upper(crw.geo_zip) = la.pcds
where geo_country = 'gbr'
and post_prop2 is not null
and post_prop2 != 'null'
and post_evar36 not in ('isa', 'isa-assist', 'csr')
and year*10000+month*100+day = year(date_sub(current_timestamp(), 8)) * 10000 + month(date_sub(current_timestamp(), 8)) * 100  + day(date_sub(current_timestamp(), 8))
or 
year*10000+month*100+day = year(date_sub(current_timestamp(), 1)) * 10000 + month(date_sub(current_timestamp(), 1)) * 100  + day(date_sub(current_timestamp(), 1))

group by 1,2,3