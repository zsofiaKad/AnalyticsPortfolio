**DAY 20: Market Gift Hunt** 🎁✨  
 
We are looking for cheap gifts at the market. Which vendors are selling items priced below $10? List the unique (i.e. remove duplicates) vendor names.



**Table 1**: `vendors`  

| vendor_id | vendor_name    | market_location    |  
|-----------|----------------|--------------------|  
| 1         | Cozy Crafts    | Downtown Square   |  
| 2         | Sweet Treats   | Central Park      |  
| 3         | Winter Warmers | Downtown Square   |  

**Table 2**: `item_prices`  

| item_id | vendor_id | item_name           | price_usd |  
|---------|-----------|---------------------|-----------|  
| 1       | 1         | Knitted Scarf       | 25        |  
| 2       | 2         | Hot Chocolate       | 5         |  
| 3       | 2         | Gingerbread Cookie  | 3.5       |  
| 4       | 3         | Wool Hat            | 18        |  
| 5       | 3         | Santa Pin           | 2         |  


**SQL Query**:  

```sql
SELECT DISTINCT(v.vendor_name)
FROM vendors AS v
JOIN item_prices AS p 
ON v.vendor_id = p.vendor_id
WHERE p.price_usd < 10;
```


**Step-by-Step Explanation**:  

1. **Select Unique Vendor Names**  
   - Use `SELECT DISTINCT(v.vendor_name)` to ensure that each vendor's name appears only once in the result, even if they have multiple items priced below $10.  

2. **Alias the Vendors Table**  
   - Assign an alias `v` to the `vendors` table for shorter and clearer query references.  

3. **Join the Tables**  
   - Use the `JOIN` clause to combine data from `vendors` (aliased as `v`) and `item_prices` (aliased as `p`) by matching the `vendor_id` column in both tables.  

4. **Filter Items Priced Below $10**  
   - Apply the condition `WHERE p.price_usd < 10` to include only rows where the item's price is less than $10.  


**Result**:  

| vendor_name     |  
|-----------------|  
| Sweet Treats    |  
| Winter Warmers  |  
