### 🎄 **DAY 23: The Grinch's Weight Log Analysis** 🎄

The Grinch tracked his weight every day in December to analyze how it changed daily. Write a query to return the weight change (in pounds) for each day, calculated as the difference from the previous day's weight.


#### **Table name: `grinch_weight_log`**

| log_id | day_of_month | weight |
|--------|--------------|--------|
| 1      | 1            | 250    |
| 2      | 2            | 248    |
| 3      | 3            | 249    |
| 4      | 4            | 247    |
| 5      | 5            | 246    |
| 6      | 6            | 248    |


### **Question Level of Difficulty:** Medium


### **QUERY**
```sql
SELECT 
    g1.day_of_month AS day,
    g1.weight AS current_weight,
    g1.weight - g2.weight AS weight_change
FROM 
    grinch_weight_log AS g1
LEFT JOIN 
    grinch_weight_log AS g2
ON 
    g1.day_of_month = g2.day_of_month + 1
ORDER BY 
    g1.day_of_month;
```



### **STEP-BY-STEP EXPLANATION** 📚

1. **Select the current day's log (g1):**
   - The `grinch_weight_log` table is referenced as `g1` to represent the current day's weight (`g1.weight`).

2. **Join with the previous day's log (g2):**
   - Perform a `LEFT JOIN` on the same table, `grinch_weight_log`, but reference it as `g2` to represent the previous day's log.
   - The `ON` condition links each row in `g1` with the row in `g2` where the `day_of_month` is exactly one day earlier, aligning the current day with the previous day.

3. **Calculate the weight change:**
   - Subtract the previous day's weight (`g2.weight`) from the current day's weight (`g1.weight`) to compute the daily weight change.

4. **Order the results by day:**
   - Use `ORDER BY g1.day_of_month` to ensure the output is sorted in ascending order of `day_of_month`.

5. **Handle the first day:**
   - Since the first day does not have a prior day to compare with, the `LEFT JOIN` ensures that `g2.weight` is `NULL`, and the weight change for day 1 will also be `NULL`.



### **RESULT**

| day | current_weight | weight_change |
|-----|----------------|---------------|
| 1   | 250            | NULL          |
| 2   | 248            | -2            |
| 3   | 249            | 1             |
| 4   | 247            | -2            |
| 5   | 246            | -1            |
| 6   | 248            | 2             |

