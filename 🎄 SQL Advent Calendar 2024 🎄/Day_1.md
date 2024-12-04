### **Day 1: Multiple Activities**  
**Question:**  
A ski resort company wants to know which customers rented ski equipment for more than one type of activity (e.g., skiing and snowboarding). List the customer names and the number of distinct activities they rented equipment for.  

**Table Name:** `rentals`  

| RENTAL_ID | CUSTOMER_NAME | ACTIVITY       | RENTAL_DATE  |
|-----------|---------------|----------------|--------------|
| 1         | EMILY         | SKIING         | 2024-01-01   |
| 2         | MICHAEL       | SNOWBOARDING   | 2024-01-02   |
| 3         | EMILY         | SNOWBOARDING   | 2024-01-03   |
| 4         | SARAH         | SKIING         | 2024-01-01   |
| 5         | MICHAEL       | SKIING         | 2024-01-02   |
| 6         | MICHAEL       | SNOWTUBING     | 2024-01-02   |

**Difficulty Level:** Medium  

**SQL Query:**  
```sql
SELECT customer_name, COUNT(DISTINCT activity) AS activity_type
FROM rentals 
GROUP BY customer_name
HAVING COUNT(DISTINCT activity) > 1;
```

**Explanation:**  
1. **`COUNT(DISTINCT activity)`**: Counts unique activities for each customer.  
2. **`GROUP BY customer_name`**: Groups data by customer to calculate metrics individually.  
3. **`HAVING` clause**: Filters to include only customers with more than one unique activity.  

**Result:**  
| CUSTOMER_NAME | ACTIVITY_TYPE |
|---------------|---------------|
| EMILY         | 2             |
| MICHAEL       | 3             |
