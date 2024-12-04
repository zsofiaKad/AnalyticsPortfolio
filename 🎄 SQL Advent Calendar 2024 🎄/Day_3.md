### **Day 3: Ranking Candies by Calories**  
**Question:**  
You’re trying to identify the most calorie-packed candies to avoid during your holiday binge. Write a query to rank candies based on their calorie count within each category. Include the candy name, category, calories, and rank (`rank_in_category`) within the category.  

**Table Name:** `candy_nutrition`  

| CANDY_ID | CANDY_NAME              | CALORIES | CANDY_CATEGORY |
|----------|-------------------------|----------|----------------|
| 1        | CANDY CANE              | 200      | SWEETS         |
| 2        | CHOCOLATE BAR           | 250      | CHOCOLATE      |
| 3        | GINGERBREAD COOKIE      | 150      | BAKED GOODS    |
| 4        | LOLLIPOP                | 100      | SWEETS         |
| 5        | DARK CHOCOLATE TRUFFLE  | 180      | CHOCOLATE      |
| 6        | MARSHMALLOW             | 900      | SWEETS         |
| 7        | SUGAR COOKIE            | 140      | BAKED GOODS    |

**Difficulty Level:** Hard  

**SQL Query:**  
```sql
SELECT candy_name, candy_category AS category, calories, 
       RANK() OVER (PARTITION BY candy_category ORDER BY calories DESC) AS rank_in_category
FROM candy_nutrition;
```

**Explanation:**  
1. **`SELECT candy_name, candy_category AS category, calories`**: We select the candy name, category, and calorie count to include in the output.  
2. **`RANK() OVER`**: The `RANK()` function is a window function that assigns a rank based on the specified order.  
3. **`PARTITION BY candy_category`**: Divides the dataset into groups based on the `candy_category`, so each category is ranked separately.  
4. **`ORDER BY calories DESC`**: Ranks the candies within each category by their calorie count in descending order (highest calories first).  
5. **`AS rank_in_category`**: Names the column that holds the rank for clarity.  
6. **`FROM candy_nutrition`**: Specifies the source table.  

**Result:**  
| CANDY_NAME           | CATEGORY      | CALORIES | RANK_IN_CATEGORY |
|----------------------|---------------|----------|------------------|
| GINGERBREAD COOKIE   | BAKED GOODS   | 150      | 1                |
| SUGAR COOKIE         | BAKED GOODS   | 140      | 2                |
| CHOCOLATE BAR        | CHOCOLATE     | 250      | 1                |
| DARK CHOCOLATE TRUFFLE | CHOCOLATE     | 180      | 2                |
| MARSHMALLOW          | SWEETS        | 900      | 1                |
| CANDY CANE           | SWEETS        | 200      | 2                |
| LOLLIPOP             | SWEETS        | 100      | 3                |
