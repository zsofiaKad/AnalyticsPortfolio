### DAY 12: Ranking Snow Globes ❄️✨

**Challenge**: A collector wants to identify the top 3 snow globes with the highest number of figurines. Write a query to rank them and include their `globe_name`, `number of figurines`, and `material`.



**Table Name**: snow_globes

| globe_id | globe_name         | volume_cm3 | material |
|----------|--------------------|------------|----------|
| 1        | Winter Wonderland  | 500        | Glass    |
| 2        | Santas Workshop    | 300        | Plastic  |
| 3        | Frozen Forest      | 400        | Glass    |
| 4        | Holiday Village    | 600        | Glass    |


**Table Name**: figurines

| figurine_id | globe_id | figurine_type |
|-------------|----------|---------------|
| 1           | 1        | Snowman       |
| 2           | 1        | Tree          |
| 3           | 2        | Santa Claus   |
| 4           | 2        | Elf           |
| 5           | 2        | Gift Box      |
| 6           | 3        | Reindeer      |
| 7           | 3        | Tree          |
| 8           | 4        | Snowman       |
| 9           | 4        | Santa Claus   |
| 10          | 4        | Tree          |
| 11          | 4        | Elf           |
| 12          | 4        | Gift Box      |



**Question Level of Difficulty**: Hard


### SQL Query

```sql
WITH figurine_counts AS (
    SELECT 
        sg.globe_name, 
        sg.material, 
        COUNT(f.figurine_id) AS num_figurines
    FROM 
        snow_globes sg
    JOIN 
        figurines f 
    ON 
        sg.globe_id = f.globe_id
    GROUP BY 
        sg.globe_id, sg.globe_name, sg.material
),
ranked_globes AS (
    SELECT 
        globe_name, 
        material, 
        num_figurines, 
        RANK() OVER (ORDER BY num_figurines DESC) AS rank
    FROM 
        figurine_counts
)
SELECT 
    globe_name, 
    num_figurines, 
    material
FROM 
    ranked_globes
WHERE 
    rank <= 3;
```



### Step-by-Step Explanation:

1. **WITH figurine_counts AS (...):**
   - This common table expression (CTE) calculates the number of figurines for each snow globe by counting `figurine_id` in the `figurines` table and grouping by `globe_id`.
   - `COUNT(f.figurine_id)` counts the figurines associated with each globe. `GROUP BY sg.globe_id, sg.globe_name, sg.material` ensures the counts are aggregated per globe.

2. **JOIN figurines f ON sg.globe_id = f.globe_id:**
   - This join connects the `snow_globes` and `figurines` tables to match each figurine with its corresponding globe.

3. **WITH ranked_globes AS (...):**
   - This second CTE ranks the globes by their number of figurines in descending order using the `RANK()` window function.

4. **RANK() OVER (ORDER BY num_figurines DESC):**
   - Assigns a rank to each snow globe based on the number of figurines, with the highest-ranked globes listed first.

5. **SELECT globe_name, num_figurines, material FROM ranked_globes WHERE rank <= 3:**
   - Retrieves the top 3 ranked snow globes by filtering for ranks less than or equal to 3.



### Result

| globe_name         | num_figurines | material |
|--------------------|---------------|----------|
| Holiday Village    | 5             | Glass    |
| Santas Workshop    | 3             | Plastic  |
| Winter Wonderland  | 2             | Glass    |
| Frozen Forest      | 2             | Glass    |
