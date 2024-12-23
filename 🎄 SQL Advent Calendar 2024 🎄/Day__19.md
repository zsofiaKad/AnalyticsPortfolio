**DAY 19: Polar Bear Diet Analysis** 🐻‍❄️🍴  

Scientists are studying the diets of polar bears and need to find the maximum amount of food (in kilograms) consumed by each polar bear in a single meal during December 2024. The result should include the bear's name and their largest meal, sorted in descending order of the largest meal consumed.


**Table 1**: `polar_bears`  

| bear_id | bear_name | age |  
|---------|-----------|-----|  
| 1       | Snowball  | 10  |  
| 2       | Frosty    | 7   |  
| 3       | Iceberg   | 15  |  

**Table 2**: `meal_log`  

| log_id | bear_id | food_type | food_weight_kg | date       |  
|--------|---------|-----------|----------------|------------|  
| 1      | 1       | Seal      | 30             | 2024-12-01 |  
| 2      | 2       | Fish      | 15             | 2024-12-02 |  
| 3      | 1       | Fish      | 10             | 2024-12-03 |  
| 4      | 3       | Seal      | 25             | 2024-12-04 |  
| 5      | 2       | Seal      | 20             | 2024-12-05 |  
| 6      | 3       | Fish      | 18             | 2024-12-06 |  



**SQL Query**:  

```sql
WITH bear_food AS (
    SELECT 
        pb.bear_name, 
        m.food_weight_kg
    FROM 
        polar_bears AS pb
    JOIN 
        meal_log AS m 
    ON 
        pb.bear_id = m.bear_id
    WHERE 
        m.date BETWEEN '2024-12-01' AND '2024-12-31'
),
max_meals AS (
    SELECT 
        bear_name, 
        MAX(food_weight_kg) AS biggest_meal_kg
    FROM 
        bear_food
    GROUP BY 
        bear_name
)
SELECT 
    bear_name, 
    biggest_meal_kg
FROM 
    max_meals
ORDER BY 
    biggest_meal_kg DESC;
```


**Step-by-Step Explanation**:  

1. **Filter Meals for December 2024**  
   - Create a Common Table Expression (CTE) named `bear_food` to select polar bear names (`bear_name`) and their respective meal weights (`food_weight_kg`).  
   - Use `JOIN` to connect the `polar_bears` and `meal_log` tables on `bear_id`.  
   - Filter meal logs with `WHERE m.date BETWEEN '2024-12-01' AND '2024-12-31'` to include only records from December 2024.  

2. **Find the Maximum Meal for Each Bear**  
   - Create another CTE (`max_meals`) to calculate the maximum meal weight for each bear:  
     - Use `MAX(food_weight_kg)` to get the heaviest meal for each bear.  
     - Use `GROUP BY bear_name` to compute the maximum weight for each unique bear.  

3. **Sort the Results**  
   - Select `bear_name` and `biggest_meal_kg` from the `max_meals` CTE.  
   - Sort the output by `biggest_meal_kg DESC` to display the bears in order of their largest meal, starting with the heaviest.  



**Result**:  

| bear_name | biggest_meal_kg |  
|-----------|-----------------|  
| Snowball  | 30              |  
| Iceberg   | 25              |  
| Frosty    | 20              |  
