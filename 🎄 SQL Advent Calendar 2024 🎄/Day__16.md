### DAY 16: Candy Store Revenue Analysis 🍬

As the owner of a candy store, you want to understand which of your products are selling best. Write a query to calculate the total revenue generated from each candy category.


**Table Name**: candy_sales

| sale_id | candy_name               | quantity_sold | price_per_unit | category   |
|---------|--------------------------|---------------|----------------|------------|
| 1       | Candy Cane               | 20            | 1.5            | Sweets     |
| 2       | Chocolate Bar            | 10            | 2.0            | Chocolate  |
| 3       | Lollipop                 | 5             | 0.75           | Sweets     |
| 4       | Dark Chocolate Truffle   | 8             | 2.5            | Chocolate  |
| 5       | Gummy Bears              | 15            | 1.2            | Sweets     |
| 6       | Chocolate Fudge          | 12            | 3.0            | Chocolate  |


**Question Level of Difficulty**: Medium


### SQL Query

```sql
SELECT category, SUM(quantity_sold * price_per_unit) AS total_revenue
FROM candy_sales
GROUP BY category
ORDER BY total_revenue DESC;
```


### Step-by-Step Explanation

1. **Calculate revenue for each sale:**
   - Revenue for each sale is calculated by multiplying `quantity_sold` by `price_per_unit`. This determines the total revenue generated for each candy item.

2. **Group sales by category:**
   - Use `GROUP BY category` to aggregate all sales by the `category` column. This ensures the query calculates totals for each unique candy category (e.g., Sweets, Chocolate).

3. **Aggregate total revenue for each category:**
   - Apply `SUM(quantity_sold * price_per_unit)` to compute the total revenue for each candy category.

4. **Sort categories by revenue:**
   - Use `ORDER BY total_revenue DESC` to sort the results in descending order, showcasing the top-performing categories first.


**Result**

| category   | total_revenue |
|------------|---------------|
| Chocolate  | 76            |
| Sweets     | 51.75         |

