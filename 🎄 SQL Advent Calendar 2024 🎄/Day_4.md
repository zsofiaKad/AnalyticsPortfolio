### **Day 4: Finding Regions with Heavy Snowfall**  
**Question:**  
You’re planning your next ski vacation and want to find the best regions with heavy snowfall. Using the tables `ski_resorts` and `snowfall`, find the average snowfall for each region and sort the regions in descending order of average snowfall. Return the columns `region` and `average_snowfall`.  

**Table Name 1:** `ski_resorts`  

| RESORT_ID | RESORT_NAME         | REGION            |
|-----------|---------------------|-------------------|
| 1         | SNOWY PEAKS         | ROCKY MOUNTAINS   |
| 2         | WINTER WONDERLAND   | WASATCH RANGE     |
| 3         | FROZEN SLOPES       | ALASKA RANGE      |
| 4         | POWDER PARADISE     | ROCKY MOUNTAINS   |

**Table Name 2:** `snowfall`  

| RESORT_ID | SNOWFALL_INCHES |
|-----------|-----------------|
| 1         | 60              |
| 2         | 45              |
| 3         | 75              |
| 4         | 55              |

**Difficulty Level:** Medium  

**SQL Query:**  
```sql
SELECT sr.region, AVG(s.snowfall_inches) AS average_snowfall
FROM ski_resorts AS sr 
JOIN snowfall AS s ON sr.resort_id = s.resort_id
GROUP BY sr.region 
ORDER BY average_snowfall DESC;
```

**Explanation:**  
1. **`SELECT sr.region, AVG(s.snowfall_inches) AS average_snowfall`**:  
   - Selects the `region` column from the `ski_resorts` table.  
   - Calculates the average snowfall for each region using the `AVG()` aggregate function.  
   - Labels the result as `average_snowfall` for clarity.  
2. **`FROM ski_resorts AS sr`**:  
   - Specifies the `ski_resorts` table as the main dataset.  
   - Uses the alias `sr` for brevity.  
3. **`JOIN snowfall AS s ON sr.resort_id = s.resort_id`**:  
   - Combines the `snowfall` table with the `ski_resorts` table based on the `resort_id` column.  
   - Ensures each region is paired with its snowfall data.  
4. **`GROUP BY sr.region`**:  
   - Groups the data by `region` so the average snowfall is calculated for each group.  
5. **`ORDER BY average_snowfall DESC`**:  
   - Sorts the results in descending order of `average_snowfall`, prioritizing regions with the heaviest snowfall.  

**Result:**  

| REGION            | AVERAGE_SNOWFALL |
|-------------------|------------------|
| ALASKA RANGE      | 75.0             |
| ROCKY MOUNTAINS   | 57.5             |
| WASATCH RANGE     | 45.0             |
