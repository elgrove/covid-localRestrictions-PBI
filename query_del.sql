WITH dt AS
  (SELECT YEAR,
          MONTH,
          DAY,
          delivery_post_code,
          delivery_channel,
          sum(sales_amt) rev,
          sum(item_qty) units,
          count(DISTINCT order_number) orders
   FROM analytics.order_transaction_line
   WHERE YEAR = 2020
     AND trans_line_type = 'S'
     AND delivery_channel IN ('DirectShip',
                              'InStore')
   GROUP BY 1,
            2,
            3,
            4,
            5)
SELECT YEAR,
       MONTH,
       DAY,
       dt.delivery_channel,
       la.lau_name,
       sum(rev) rev,
       sum(units) units,
       sum(orders) orders
FROM dt
INNER JOIN ecom_lab.al_postcode_la la ON dt.delivery_post_code = la.pcds
GROUP BY 1,
         2,
         3,
         4,
         5
ORDER BY 1 ASC