create database zepto_inventory;
use zepto_inventory;

-- Total number of products?

select count(*) from zepto_v2;


-- Average price per category?

select category, avg(discountedsellingprice) as avg_selling_price
from zepto_v2
group by category
order by avg_selling_price desc;

-- Top 10 most expensive products?

select name, mrp
from zepto_v2
order by mrp desc
limit 10;

-- Products with highest discount?

SELECT name, mrp, discountedsellingprice,
(mrp - discountedsellingprice) AS discount_amount
FROM zepto_v2
ORDER BY discount_amount DESC
LIMIT 10;

-- Which category has highest average discount?

SELECT 
    category,
    ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto_v2
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 1;

-- Which category contributes most products?

select category, count(*) as total_product 
from zepto_v2
group by category
order by total_product desc
limit 1;

-- data cleaning
-- product with price = 0

select * from zepto_v2
where mrp = 0 or discountedSellingPrice = 0;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM zepto_v2
WHERE mrp = 0;

-- convert paise to rupees
update zepto_v2 
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

-- Price distribution (low / medium / high)

select category,
case 
    when discountedsellingprice < 100 then 'low'
    when discountedsellingprice between 100 and 500 then 'medium' 
    else 'high'
    end as price_category, 
    count(*) as total_product 
from zepto_v2
group by category, price_category
order by category, price_category desc;

-- Out-of-stock vs in-stock percentage
select category, 
    case 
         when availableQuantity = 1 then 'IN_stock'
         else 'Out_Of_Stock'
         end as stock_status , 
         count(*) as  total_product 
from zepto_v2
group by category, stock_status
order by category desc;

-- Top discounted brands/products

select category, name, mrp, discountedSellingPrice,
round(discountedSellingPrice,2) as discount_percent
from zepto_v2
where mrp >0
order by discount_percent desc
limit 10