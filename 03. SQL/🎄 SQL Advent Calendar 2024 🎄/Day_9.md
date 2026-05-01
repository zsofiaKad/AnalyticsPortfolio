### Day 9: Festive Feast Menu Query 🎄🍽️

**A community is hosting a series of festive feasts, and they want to ensure a balanced menu. Write a query to identify the top 3 most calorie-dense dishes (calories per gram) served for each event. Include the dish name, event name, and the calculated calorie density in your results.**



**Table Name**: `events`  

| event_id | event_name                |  
|----------|---------------------------|  
| 1        | Christmas Eve Dinner       |  
| 2        | New Years Feast            |  
| 3        | Winter Solstice Potluck    |  



**Table Name**: `menu`  

| dish_id | dish_name           | event_id | calories | weight_g |  
|---------|---------------------|----------|----------|----------|  
| 1       | Roast Turkey         | 1        | 3500     | 5000     |  
| 2       | Chocolate Yule Log   | 1        | 2200     | 1000     |  
| 3       | Cheese Fondue        | 2        | 1500     | 800      |  
| 4       | Holiday Fruitcake    | 3        | 4000     | 1200     |  
| 5       | Honey Glazed Ham     | 2        | 2800     | 3500     |  



### **Question Level of Difficulty**: Hard  



### **SQL Query**  
```sql
WITH calorie_density AS (
    SELECT 
        m.dish_name, 
        e.event_name, 
        (m.calories / m.weight_g) AS calorie_density
    FROM 
        menu m
    JOIN 
        events e
    ON 
        m.event_id = e.event_id
),
ranked_dishes AS (
    SELECT 
        dish_name, 
        event_name, 
        calorie_density, 
        RANK() OVER (PARTITION BY event_name ORDER BY calorie_density DESC) AS rank_in_event
    FROM 
        calorie_density
)
SELECT 
    dish_name, 
    event_name, 
    calorie_density
FROM 
    ranked_dishes
WHERE 
    rank_in_event <= 3;
```  



### **Step-by-Step Explanation**

#### **`WITH calorie_density AS (...)`:**  
- **Purpose**: This Common Table Expression (CTE) calculates the calorie density (calories per gram) for each dish in the menu.  
- **`SELECT m.dish_name, e.event_name, (m.calories / m.weight_g) AS calorie_density`:**  
  - **`m.dish_name`**: The name of the dish from the `menu` table.  
  - **`e.event_name`**: The name of the event from the `events` table.  
  - **`(m.calories / m.weight_g) AS calorie_density`**: The calculated calorie density for each dish, determined by dividing the total calories of the dish by its weight in grams. This gives a measure of calories per gram.  
- **`FROM menu m JOIN events e ON m.event_id = e.event_id`:**  
  - **JOIN operation**: Joins the `menu` table (`m`) with the `events` table (`e`) on the `event_id` field to associate each dish with its respective event.  

#### **`ranked_dishes AS (...)`:**  
- **Purpose**: This CTE ranks the dishes based on their calorie density within each event, so we can select the top 3 highest-calorie dishes per event.  
- **`SELECT dish_name, event_name, calorie_density, RANK() OVER (PARTITION BY event_name ORDER BY calorie_density DESC) AS rank_in_event`:**  
  - **`RANK() OVER (PARTITION BY event_name ORDER BY calorie_density DESC)`**:  
    - **`RANK()`**: This function assigns a rank to each dish based on its calorie density, with the highest calorie density receiving rank 1.  
    - **`PARTITION BY event_name`**: The ranking is done separately for each event, so each event will have its own ranking of dishes based on their calorie density.  
    - **`ORDER BY calorie_density DESC`**: Dishes are sorted in descending order of their calorie density (highest first).  
    - **`AS rank_in_event`**: The rank assigned to each dish within its respective event.  

#### **Final `SELECT` Statement**  
- **`SELECT dish_name, event_name, calorie_density`**: Retrieves the top 3 most calorie-dense dishes for each event.  
- **`WHERE rank_in_event <= 3`**: Filters the results to include only the top 3 dishes, based on calorie density, for each event.



### **Results**  

| dish_name          | event_name            | calorie_density |
|--------------------|-----------------------|-----------------|
| Chocolate Yule Log | Christmas Eve Dinner  | 2               |
| Roast Turkey       | Christmas Eve Dinner  | 0               |
| Cheese Fondue      | New Years Feast       | 1               |
| Honey Glazed Ham   | New Years Feast       | 0               |
| Holiday Fruitcake  | Winter Solstice Potluck | 3             |
