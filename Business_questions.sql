USE magist;

# 1 How many orders are there in the dataset? The orders table contains a row for each order, so this should be easy to find out!

SELECT 
    count(*) as total_orders
FROM
    Orders;

# 2 Are orders actually delivered?

SELECT 
    COUNT(*), order_status
FROM
    orders
GROUP BY order_status;

# 3 Is Magist having user growth?

SELECT YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_,
    COUNT(customer_id)
FROM
    orders
GROUP BY year_ , month_
ORDER BY year_ , month_ ;

# 4- How many products are there on the products table? 

SELECT 
    COUNT(DISTINCT product_id)
FROM
    products;

# 5- Which are the categories with the most products?

SELECT     product_category_name, COUNT(DISTINCT product_id)
FROM    products 
group by product_category_name 
order by COUNT( DISTINCT product_id) DESC;

# 6- How many of those products were present in actual transactions? 

SELECT 
    COUNT(DISTINCT product_id)
FROM
    order_items;


# 7. What’s the price for the most expensive and cheapest products?
    

SELECT 
    MIN(price), MAX(price)
FROM
    order_items;
    
    # 8. What are the highest and lowest payment values? 
    
SELECT 
    order_id,
    SUM(payment_value) AS Total_payments
FROM
    order_payments
GROUP BY order_id
ORDER BY Total_payments DESC;


----------------# 3. Answer business questions-----------------------------------------------------------------------------------------------------------------------------


/*****
# 3.1. In relation to the products:
*****/

# ------- How many products of these tech categories have been sold (within the time window of the database snapshot)? What percentage does that represent from the overall number of products sold?

    
SELECT DISTINCT
    t.product_category_name_english AS productcategory,
    COUNT(p.product_id) AS productcount
FROM
    products p
        JOIN
    product_category_name_translation t ON p.product_category_name = t.product_category_name
  GROUP BY t.product_category_name_english
  ORDER BY productcount DESC;
    
    #-- What percentage does that represent from the overall number of products sold? 
    #--- Total products
    
SELECT   COUNT(product_id) 
    AS total_products
    FROM  order_items as oi;
    #-- output 112650
    
SELECT DISTINCT
    t.product_category_name_english, COUNT(p.product_id) as product_count
FROM
    products p
        JOIN
    product_category_name_translation t ON p.product_category_name = t.product_category_name
    WHERE t.product_category_name_english IN ('audio', 'books_technical', 'computers', 'computers_accessories',
    'consoles_games','electronics','home_appliances','home_appliances_2','pc_gamer','signaling_and_security','tablets_printing_image','telephony')
    GROUP BY t.product_category_name_english
    order by product_count ASC;
    
     

# ------------- seller to orders

SELECT   COUNT(distinct order_id) 
    AS total_sells
    FROM  order_items as oi;
    #-- output 98666
    
# -------- " Percentatge sold tech"


SELECT 
    t.product_category_name_english AS productcategory,
    ROUND((COUNT(oi.order_id) / 98666) * 100, 2) AS percentagesoldcount
FROM
    order_items oi
        JOIN
    products p ON oi.product_id = p.product_id
        JOIN 
    product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE
    t.product_category_name_english IN ('audio', 'books_technical',
        'computers',
        'computers_accessories',
        'consoles_games',
        'electronics',
        'home_appliances',
        'home_appliances_2',
        'pc_gamer',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony')
GROUP BY t.product_category_name_english
ORDER BY percentagesoldcount DESC;


SELECT 
    SUM(percentage_sold_count_tech) AS total_percentage_sold_count_tech
FROM (
    SELECT 
        ROUND((COUNT(oi.order_id) / 98666.0) * 100, 2) AS percentage_sold_count_tech
    FROM
        order_items oi
        JOIN products p ON oi.product_id = p.product_id
        JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
    WHERE
        t.product_category_name_english IN ('audio', 'books_technical',
            'computers', 'computers_accessories', 'consoles_games', 
            'electronics', 'home_appliances', 'home_appliances_2',
            'pc_gamer', 'signaling_and_security', 'tablets_printing_image', 'telephony')
    GROUP BY t.product_category_name_english
) AS percentages;



SELECT DISTINCT
    t.product_category_name_english,
    ROUND((COUNT(p.product_id) / 112650.0) * 100,
            2) AS percentage_product_count
FROM
    products p
        JOIN
    product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE
    t.product_category_name_english IN ('audio' , 'books_technical',
        'computers',
        'computers_accessories',
        'consoles_games',
        'electronics',
        'home_appliances',
        'home_appliances_2',
        'pc_gamer',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony')
GROUP BY t.product_category_name_english
ORDER BY percentage_product_count ASC;
    
        
    SELECT
    SUM(percentage_product_count) AS total_percentage_product
FROM 
    (SELECT 
        t.product_category_name_english,
        ROUND((COUNT(p.product_id) / 112650.0) * 100, 2) AS percentage_product_count
    FROM
        products p
        JOIN
        product_category_name_translation t ON p.product_category_name = t.product_category_name
    WHERE
        t.product_category_name_english IN ('audio', 'books_technical',
            'computers',
            'computers_accessories',
            'consoles_games',
            'electronics',
            'home_appliances',
            'home_appliances_2',
            'pc_gamer',
            'signaling_and_security',
            'tablets_printing_image',
            'telephony');
					
	SELECT
    SUM(percentage_product_count) AS total_percentage_product
FROM 
    (SELECT 
        t.product_category_name_english,
        ROUND((COUNT(p.product_id) / 112650.0) * 100, 2) AS percentage_product_count
    FROM
        products p
        JOIN
        product_category_name_translation t ON p.product_category_name = t.product_category_name
    WHERE
        t.product_category_name_english IN ('audio', 'books_technical',
            'computers',
            'computers_accessories',
            'consoles_games',
            'electronics',
            'home_appliances',
            'home_appliances_2',
            'pc_gamer',
            'signaling_and_security',
            'tablets_printing_image',
            'telephony')
    GROUP BY t.product_category_name_english
    ) AS percentages;

   
  
#----------- by product sold:

SELECT DISTINCT
    AVG(price) AS average_price, t.product_category_name_english
FROM
    products p
        JOIN
    product_category_name_translation t ON p.product_category_name = t.product_category_name
        JOIN
    order_items AS oi ON p.product_id = oi.product_id
WHERE
    t.product_category_name_english IN ('audio' , 'books_technical',
        'computers',
        'computers_accessories',
        'consoles_games',
        'electronics',
        'home_appliances',
        'home_appliances_2',
        'pc_gamer',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony')
GROUP BY t.product_category_name_english
ORDER BY average_price ASC;


SELECT DISTINCT
    AVG(price) AS averageprice,
    t.product_category_name_english AS productcategory
FROM
    products p
        JOIN
    product_category_name_translation t ON p.product_category_name = t.product_category_name
        JOIN
    order_items AS oi ON p.product_id = oi.product_id
WHERE
    t.product_category_name_english IN ('audio' , 'books_technical',
        'computers',
        'computers_accessories',
        'consoles_games',
        'electronics',
        'home_appliances',
        'home_appliances_2',
        'pc_gamer',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony')
GROUP BY t.product_category_name_english
ORDER BY averageprice ASC;


    #------------------------------------------------------------------------------
    
 
SELECT 
    COUNT(p.product_id) AS Number_of_Products,
    ROUND(COUNT(p.product_id) * 100.0 / t.total_products, 2) AS Percentage_From_Total,
    product_category_name_english
FROM
    products p
        JOIN
    product_category_name_translation USING (product_category_name)
        JOIN
    (SELECT COUNT(*) AS total_products FROM products) t
GROUP BY product_category_name, product_category_name_english, t.total_products
ORDER BY Number_of_Products DESC;


# Total products
SELECT 
  COUNT(product_id) AS total_products
FROM
  order_items;
  
 # What’s the average price of the products being sold? 
 
SELECT 
  AVG(price) AS average_price
FROM
  order_items;
  # output is '120.65373902991884'
  
# If i want to have it by categories? 

SELECT 
    AVG(price) AS average_price,
    COUNT(p.product_id),
    p.product_category_name
FROM
    products AS p
        LEFT JOIN
    order_items AS oi ON p.product_id = oi.product_id
WHERE
    p.product_category_name IN ('audio' , 'livros_interesse_geral',
        'informatica_acessorios',
        'consoles_games',
        'eletronicos',
        'eletrodomesticos',
        'eletrodomesticos_2',
        'pc_gamer',
        'sinalizacao_e_seguranca',
        'tablets_impressao_imagem',
        'telefonia',
        'pcs',
        'relogios_presentes')
GROUP BY p.product_category_name 
Order by COUNT(p.product_id) DESC;

# Are expensive tech products popular? *Pyrianka
### TIP: CASE when function

SELECT 
    COUNT(oi.product_id) as product,
    CASE
        WHEN price > 1000 THEN 'Expensive'
        WHEN price > 100 THEN 'Mid-range'
        ELSE 'Cheap'
    END AS 'pricerange'
FROM
    order_items oi
        LEFT JOIN
    products p ON p.product_id = oi.product_id
        LEFT JOIN
    product_category_name_translation pt USING (product_category_name)
WHERE
    pt.product_category_name_english IN ('audio' , 'books_technical',
        'computers',
        'computers_accessories',
        'consoles_games',
        'electronics',
        'home_appliances',
        'home_appliances_2',
        'pc_gamer',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony')
GROUP BY pricerange
ORDER BY 1 DESC;

/*****
# 3.2. In relation to the sellers:
*****/
 
 # How many months of data are included in the magist database? 25 month
 #### TIP.  The TIMESTAMPDIFF function in SQL is used to calculate the difference between two dates or timestamps in various units such as seconds, minutes, hours, days, weeks, months, or years. 

SELECT 
    TIMESTAMPDIFF(MONTH,
        MIN(order_purchase_timestamp),
        MAX(order_purchase_timestamp))
FROM
    orders;
    
    SELECT 
    DATEDIFF(MONTH,
        MIN(order_purchase_timestamp),
        MAX(order_purchase_timestamp))
FROM
    orders;
    
# How many sellers are there?     
 
SELECT 
    COUNT(DISTINCT seller_id)
FROM
    magist.sellers;   

# How many Tech sellers are there? What percentage of overall sellers are Tech sellers? 594

SELECT 
    COUNT(DISTINCT i.seller_id) AS 'Tech Sellers'
FROM
    order_items i
        JOIN
    products p USING (product_id)
        JOIN
    product_category_name_translation c USING (product_category_name)
WHERE
    c.product_category_name_english IN ('audio' , 'books_technical',
        'computers',
        'computers_accessories',
        'consoles_games',
        'electronics',
        'home_appliances',
        'home_appliances_2',
        'pc_gamer',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony');

-- 2.3 What percentage of overall sellers are Tech sellers? -- 

SELECT 
    ROUND(100 * (SELECT 
                    COUNT(DISTINCT i.seller_id) AS 'Tech Sellers'
                FROM
                    order_items i
                        JOIN
                    products p USING (product_id)
                        JOIN
                    product_category_name_translation c USING (product_category_name)
                WHERE
                    c.product_category_name_english IN ('audio' , 'books_technical',
                        'computers',
                        'computers_accessories',
                        'consoles_games',
                        'electronics',
                        'home_appliances',
                        'home_appliances_2',
                        'pc_gamer',
                        'signaling_and_security',
                        'tablets_printing_image',
                        'telephony')) / COUNT(DISTINCT s.seller_id),
            2) AS '% Tech Sellers'
FROM
    sellers s;
    
    ## or by 
   SELECT (454 / 3095) * 100;
	-- 14.67%

-- What is the total amount earned by all sellers? -- 
#--  we use price from order_items and not payment_value from order_payments as an order may contain tech and non tech product. With payment_value we can't distinguish between items in an order

SELECT 
    SUM(oi.price) AS total
FROM
    order_items oi
        LEFT JOIN
    orders o USING (order_id)
WHERE
    o.order_status NOT IN ('unavailable' , 'canceled');

-- What is the total amount earned by all Tech sellers? 

SELECT 
    ROUND(SUM(i.price), 2) AS 'Total Sales by Tech Sellers'
FROM
    order_items i
        LEFT JOIN
    orders o USING (order_id)
        LEFT JOIN
    products p USING (product_id)
        LEFT JOIN
    product_category_name_translation c USING (product_category_name)
WHERE
    o.order_status = 'delivered'
        AND c.product_category_name_english IN ('audio' , 'books_technical',
        'computers',
        'computers_accessories',
        'consoles_games',
        'electronics',
        'home_appliances',
        'home_appliances_2',
        'pc_gamer',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony');
/*****
In relation to the delivery time:
*****/
## - What’s the average time between the order being placed and the product being delivered?

SELECT AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp))
FROM orders;

## -- How many orders are delivered on time vs orders delivered with a delay?
    
SELECT 
    CASE 
        WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 0 THEN 'Delayed' 
        ELSE 'On time'
    END AS delivery_status, 
COUNT(DISTINCT order_id) AS orders_count
FROM orders 
WHERE order_status = 'delivered'
AND order_estimated_delivery_date IS NOT NULL
AND order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;

##-- Is there any pattern for delayed orders, e.g. big products being delayed more often?

SELECT
    CASE 
        WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) >= 100 THEN "> 100 day Delay"
        WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) >= 7 AND DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) < 100 THEN "1 week to 100 day delay"
        WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 3 AND DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) < 7 THEN "4-7 day delay"
        WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) >= 1  AND DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) <= 3 THEN "1-3 day delay"
        WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 0  AND DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) < 1 THEN "less than 1 day delay"
        WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) <= 0 THEN 'On time' 
    END AS "delay_range", 
    AVG(product_weight_g) AS weight_avg,
    MAX(product_weight_g) AS max_weight,
    MIN(product_weight_g) AS min_weight,
    SUM(product_weight_g) AS sum_weight,
    COUNT(DISTINCT a.order_id) AS orders_count
FROM orders a
LEFT JOIN order_items b
    USING (order_id)
LEFT JOIN products c
    USING (product_id)
WHERE order_estimated_delivery_date IS NOT NULL
AND order_delivered_customer_date IS NOT NULL
AND order_status = 'delivered'
GROUP BY delay_range;