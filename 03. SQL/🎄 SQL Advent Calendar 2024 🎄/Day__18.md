**DAY 18: Ranking Top Activities for a "Summer Christmas" Party 🌞🎄**  

A travel agency is promoting activities for a "Summer Christmas" party. They want to identify the top 2 activities based on the average rating. Write a query to rank the activities by average rating.



**Table 1**: `activities`  

| activity_id | activity_name     |  
|-------------|-------------------|  
| 1           | Surfing Lessons   |  
| 2           | Jet Skiing        |  
| 3           | Sunset Yoga       |  

**Table 2**: `activity_ratings`  

| rating_id | activity_id | rating |  
|-----------|-------------|--------|  
| 1         | 1           | 4.7    |  
| 2         | 1           | 4.8    |  
| 3         | 1           | 4.9    |  
| 4         | 2           | 4.6    |  
| 5         | 2           | 4.7    |  
| 6         | 2           | 4.8    |  
| 7         | 2           | 4.9    |  
| 8         | 3           | 4.8    |  
| 9         | 3           | 4.7    |  
| 10        | 3           | 4.9    |  
| 11        | 3           | 4.8    |  
| 12        | 3           | 4.9    |  


**SQL Query**:  

```sql
WITH activity_avg_rating AS (
    SELECT 
        a.activity_name, 
        AVG(ar.rating) AS avg_rating
    FROM 
        activities AS a
    JOIN 
        activity_ratings AS ar
    ON 
        a.activity_id = ar.activity_id
    GROUP BY 
        a.activity_name
),
ranked_activities AS (
    SELECT 
        activity_name, 
        avg_rating,
        RANK() OVER (ORDER BY avg_rating DESC) AS rank
    FROM 
        activity_avg_rating
)
SELECT 
    activity_name, 
    avg_rating
FROM 
    ranked_activities
WHERE 
    rank <= 2
ORDER BY 
    avg_rating DESC;
```


**Step-by-Step Explanation**:  

1. **Calculate Average Ratings**  
   - Use a CTE (`activity_avg_rating`) to compute the average rating (`AVG`) for each activity based on its ratings.  
   - Join `activities` with `activity_ratings` to associate each rating with its respective activity.  

2. **Rank the Activities**  
   - Create another CTE (`ranked_activities`) to rank activities by their average rating in descending order using `RANK() OVER`.  

3. **Filter Top 2 Activities**  
   - Use `WHERE rank <= 2` to keep only the top 2 activities based on the calculated rankings.  

4. **Sort Results**  
   - Use `ORDER BY avg_rating DESC` to display the top activities, starting with the highest-rated one.  


**Result**:  

| activity_name    | avg_rating |  
|------------------|------------|  
| Sunset Yoga      | 4.82       |  
| Surfing Lessons  | 4.8        |  

