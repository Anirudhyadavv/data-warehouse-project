# Business Insights from the Data Warehouse

After building the data warehouse and running analytical queries on the Gold layer, I explored the reporting views to understand customer behavior, product performance, and sales trends.

The following insights summarize what I observed from the dataset.

-------------------------------------------------------------------------------

## Project Scope

This analysis explores customer behavior, product performance, and sales trends using the AdventureWorks dataset.

The insights were generated using SQL queries built on top of the **Gold layer of the data warehouse**, including aggregated reporting views for customers, products, and sales performance.

------------------------------------------------------------------------------

## Key Insights Summary

| Area | Insight | Impact |
|-----|-----|-----|
| Customer Behavior | 63% of customers placed only one order | Indicates opportunity to improve customer retention |
| Product Performance | Premium bike models generate over $1M in sales | Bikes are the primary revenue drivers |
| Product Mix | Accessories appear in thousands of orders | Accessories support cross-selling |
| Sales Growth | Monthly revenue grew from ~$44K (2010) to ~$2.8M (2013) | Business experienced rapid growth |
| Product Expansion | Active products increased from ~30 to 130+ | Catalog expansion contributed to revenue growth |

------------------------------------------------------------------------------

# 1. Customer Purchasing Behavior

### Majority of customers purchase only once
Out of **18,482 customers**, **11,617 customers (≈63%) placed only one order**.

This indicates that most customers interact with the business only once, suggesting a potential opportunity to improve **customer retention strategies** such as loyalty programs or targeted marketing campaigns.

------------------------------------------------------------------------------

### Repeat customers represent a smaller portion of the customer base
Only **6,865 customers (≈37%) made more than one purchase**.

Among them, fewer than **100 customers placed more than five orders**, indicating that a very small group of loyal customers drives repeat business.

------------------------------------------------------------------------------

### Customer base is concentrated in older age groups
Customer demographic analysis shows that the majority of customers fall into the **40–50+ age range**, while significantly fewer customers belong to younger segments.

This suggests the company's products may appeal more to mature customers with higher purchasing power.

------------------------------------------------------------------------------

# 2. Product Performance

### Premium bikes generate the majority of revenue
Several premium bike models generate extremely high revenue.

For example:
- **Mountain-200 Black-46 generated $1,373,454 in total sales**
- **Road-150 Red-48 generated over $1.2M in sales**

These high-end bike models appear to be the primary revenue drivers for the business.

------------------------------------------------------------------------------

### Accessories drive high order volume but lower revenue
Products such as **water bottles, tire tubes, and gloves appear in thousands of orders**.

For example:
- **Water Bottle – 30 oz appeared in over 4,200 orders**
- **Mountain Tire Tube appeared in over 3,000 orders**

However, their total revenue contribution remains relatively small due to their low unit price.

------------------------------------------------------------------------------

# 3. Sales Trends

### Sales increased significantly between 2011 and 2013
Sales trend analysis shows strong growth over the observed period.

Monthly sales increased from **approximately $44K in late 2010** to **over $2.8M by the end of 2013**.

This suggests rapid business expansion during this time period.

------------------------------------------------------------------------------

### Product catalog expansion supported growth
The number of active products sold increased from around **30 products in 2011** to **over 130 products by 2013**.

This indicates that product expansion likely played a role in driving sales growth.



-----------------------------------------------------------------------------


# Final Summary

The analysis of the AdventureWorks sales dataset reveals several key patterns in customer behavior, product performance, and sales trends.

From the customer perspective, the business attracts a large number of first-time buyers. Approximately **63% of customers placed only a single order**, while only **37% returned to make additional purchases**. This indicates strong customer acquisition but highlights an opportunity to improve **customer retention and repeat purchasing behavior**.

From a product perspective, **high-value bike models generate the majority of total revenue**. Several premium bike models individually generated **over $1M in total sales**, making them the primary revenue drivers for the business. In contrast, accessories such as helmets, bottles, and tire tubes appear in **thousands of orders**, but contribute less revenue due to their lower prices. These products likely serve as **complementary purchases alongside major bike orders**.

Sales trend analysis also shows **significant growth between 2011 and 2013**, where monthly sales increased from approximately **$44K to over $2.8M**. During the same period, the number of products sold expanded from around **30 products to more than 130 products**, suggesting that **product catalog expansion played a role in driving revenue growth**.

Overall, the business appears to rely on **high-value bike sales for revenue generation**, while accessories contribute to **order volume and cross-selling opportunities**. At the same time, the large share of one-time buyers highlights an opportunity to implement strategies that improve **customer retention and long-term customer value**.


-----------------------------------------------------------------------------

*Insights generated from SQL analysis performed on the Gold layer of the data warehouse.*
