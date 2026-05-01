### Day 6: Tracking Polar Bear Migrations ❄️🐻‍❄️  

**Scientists are tracking polar bears across the Arctic to monitor their migration patterns and caloric intake. Write a query to find the top 3 polar bears that have traveled the longest total distance in December 2024. Include their `bear_id`, `bear_name`, and `total_distance_traveled` in the results.**  



**Table Name 1**: `polar_bears`  

| BEAR_ID | BEAR_NAME | AGE |  
|---------|-----------|-----|  
| 1       | SNOWBALL  | 10  |  
| 2       | FROSTY    | 7   |  
| 3       | ICEBERG   | 15  |  
| 4       | CHILLY    | 5   |  

**Table Name 2**: `tracking`  

| TRACKING_ID | BEAR_ID | DISTANCE_KM | DATE       |  
|-------------|---------|-------------|------------|  
| 1           | 1       | 25          | 2024-12-01 |  
| 2           | 2       | 40          | 2024-12-02 |  
| 3           | 1       | 30          | 2024-12-03 |  
| 4           | 3       | 50          | 2024-12-04 |  
| 5           | 2       | 35          | 2024-12-05 |  
| 6           | 4       | 20          | 2024-12-06 |  
| 7           | 3       | 55          | 2024-12-07 |  
| 8           | 1       | 45          | 2024-12-08 |  



### **Question Level of Difficulty**: Hard  



### **SQL Query**  
```sql
WITH distance_summary AS (
    SELECT bear_id, SUM(distance_km) AS total_distance_traveled
    FROM tracking
    WHERE date >= '2024-12-01' AND date <= '2024-12-31'
    GROUP BY bear_id
)
SELECT pb.bear_id, pb.bear_name, ds.total_distance_traveled
FROM distance_summary ds
JOIN polar_bears pb ON ds.bear_id = pb.bear_id
ORDER BY ds.total_distance_traveled DESC
LIMIT 3;
```  


### **Step-by-Step Explanation**  

1. **`WITH distance_summary AS`:**  
   - Creates a Common Table Expression (CTE) named `distance_summary` to simplify the query structure. This temporary result will store the total distance traveled by each bear in December 2024.  

2. **`SELECT bear_id, SUM(distance_km) AS total_distance_traveled`:**  
   - Retrieves the `bear_id` for each bear and calculates the total distance traveled using `SUM(distance_km)`.  
   - The alias `total_distance_traveled` renames the result for clarity.  

3. **`FROM tracking`:**  
   - Specifies the `tracking` table as the data source. This table contains tracking data, including individual distances and dates.  

4. **`WHERE date >= '2024-12-01' AND date <= '2024-12-31'`:**  
   - Filters the rows to include only those within December 2024, ensuring calculations are limited to the specified time period.  

5. **`GROUP BY bear_id`:**  
   - Groups the data by `bear_id` so that the `SUM(distance_km)` is calculated for each bear individually.  

6. **`SELECT pb.bear_id, pb.bear_name, ds.total_distance_traveled`:**  
   - Retrieves the `bear_id` and `bear_name` from the `polar_bears` table and combines this with the total distance from the CTE.  

7. **`FROM distance_summary ds JOIN polar_bears pb ON ds.bear_id = pb.bear_id`:**  
   - Joins the CTE `distance_summary` with the `polar_bears` table on `bear_id`, ensuring that the total distance is linked to each bear's details.  

8. **`ORDER BY ds.total_distance_traveled DESC`:**  
   - Sorts the results in descending order of `total_distance_traveled`, placing the bears with the longest migrations at the top of the list.  

9. **`LIMIT 3`:**  
   - Restricts the output to the top 3 rows, ensuring only the three bears with the longest total distances are included.  


### **Result**  
| BEAR_ID | BEAR_NAME | TOTAL_DISTANCE_TRAVELED |  
|---------|-----------|--------------------------|  
| 3       | ICEBERG   | 105                      |  
| 1       | SNOWBALL  | 100                      |  
| 2       | FROSTY    | 75                       |  
