### 🎅 **DAY 24: Santa's Running Total of Gift Deliveries** 🎅

Santa is tracking how many presents he delivers each night leading up to Christmas. He wants a running total to see how many gifts have been delivered so far on any given night. Using the `deliveries` table, calculate the cumulative sum of gifts delivered, ordered by the delivery date.



#### **Table name: `deliveries`**

| delivery_date | gifts_delivered |
|---------------|-----------------|
| 2024-12-20    | 120             |
| 2024-12-21    | 150             |
| 2024-12-22    | 200             |
| 2024-12-23    | 300             |
| 2024-12-24    | 500             |



### **Question Level of Difficulty:** Hard


### **QUERY**
```sql
SELECT 
    delivery_date, 
    gifts_delivered, 
    SUM(gifts_delivered) OVER (ORDER BY delivery_date) AS cumulative_gifts
FROM 
    deliveries;
```


### **STEP-BY-STEP EXPLANATION** 

1. **SELECT delivery_date, gifts_delivered:**
   - Start by selecting the `delivery_date` and `gifts_delivered` columns to show the date and the number of gifts delivered on each date.

2. **SUM(gifts_delivered) OVER (ORDER BY delivery_date):**
   - The `SUM()` function calculates the cumulative total of gifts delivered.
   - The `OVER (ORDER BY delivery_date)` clause ensures that the gifts are summed in the correct chronological order, based on the `delivery_date`.

3. **Alias (AS cumulative_gifts):**
   - Rename the calculated cumulative sum to `cumulative_gifts` for better readability.


### **RESULT**

| delivery_date | gifts_delivered | cumulative_gifts |
|---------------|-----------------|------------------|
| 2024-12-20    | 120             | 120              |
| 2024-12-21    | 150             | 270              |
| 2024-12-22    | 200             | 470              |
| 2024-12-23    | 300             | 770              |
| 2024-12-24    | 500             | 1270             |

