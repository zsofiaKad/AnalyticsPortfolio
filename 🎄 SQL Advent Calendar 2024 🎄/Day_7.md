### Day 7: Winter Market Revenue Analysis 🎄💰  

**The owner of a winter market wants to know which vendors have generated the highest revenue overall. For each vendor, calculate the total revenue for all their items and return a list of the top 2 vendors by total revenue. Include the `vendor_name` and `total_revenue` in your results.**  



**Table Name 1**: `vendors`  

| VENDOR_ID | VENDOR_NAME    | MARKET_LOCATION    |  
|-----------|----------------|--------------------|  
| 1         | COZY CRAFTS    | DOWNTOWN SQUARE    |  
| 2         | SWEET TREATS   | CENTRAL PARK       |  
| 3         | WINTER WARMERS | DOWNTOWN SQUARE    |  

**Table Name 2**: `sales`  

| SALE_ID | VENDOR_ID | ITEM_NAME          | QUANTITY_SOLD | PRICE_PER_UNIT |  
|---------|-----------|--------------------|---------------|----------------|  
| 1       | 1         | KNITTED SCARF     | 15            | 25             |  
| 2       | 2         | HOT CHOCOLATE     | 50            | 3.5            |  
| 3       | 3         | WOOL HAT          | 20            | 18             |  
| 4       | 1         | HANDMADE ORNAMENT | 10            | 15             |  
| 5       | 2         | GINGERBREAD COOKIE| 30            | 5              |  



### **Question Level of Difficulty**: Medium  



### **SQL Query**  
```sql
WITH revenue AS (
    SELECT v.vendor_id, v.vendor_name, SUM(s.quantity_sold * s.price_per_unit) AS total_revenue
    FROM vendors AS v
    JOIN sales AS s ON v.vendor_id = s.vendor_id
    GROUP BY v.vendor_id, v.vendor_name
)
SELECT vendor_name, total_revenue
FROM revenue
ORDER BY total_revenue DESC
LIMIT 2;
```  



### **Step-by-Step Explanation**  

1. **`WITH revenue AS`:**  
   - Creates a Common Table Expression (CTE) named `revenue` to calculate the total revenue for each vendor. This simplifies the query by organizing calculations into a reusable temporary table.  

2. **`SELECT v.vendor_id, v.vendor_name, SUM(s.quantity_sold * s.price_per_unit) AS total_revenue`:**  
   - Retrieves the `vendor_id` and `vendor_name` from the `vendors` table.  
   - Calculates total revenue by multiplying `quantity_sold` by `price_per_unit` for each sale and summing the results. This value is aliased as `total_revenue`.  

3. **`FROM vendors AS v JOIN sales AS s ON v.vendor_id = s.vendor_id`:**  
   - Performs an inner join between the `vendors` table and the `sales` table on `vendor_id`, combining vendor information with their sales data.  

4. **`GROUP BY v.vendor_id, v.vendor_name`:**  
   - Groups the data by `vendor_id` and `vendor_name` to calculate `total_revenue` for each vendor.  

5. **`SELECT vendor_name, total_revenue`:**  
   - In the outer query, retrieves the `vendor_name` and `total_revenue` for display.  

6. **`ORDER BY total_revenue DESC`:**  
   - Sorts the vendors in descending order of `total_revenue` to prioritize the highest earners.  

7. **`LIMIT 2`:**  
   - Restricts the results to the top 2 vendors with the highest total revenue.  


### **Results**  

| VENDOR_NAME    | TOTAL_REVENUE |  
|----------------|---------------|  
| COZY CRAFTS    | 525           |  
| WINTER WARMERS | 360           |  
