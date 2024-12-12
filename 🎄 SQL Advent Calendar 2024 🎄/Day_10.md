### DAY 10: Tracking Friends' New Year's Resolution Progress 🎯

**Challenge**: You are tracking your friends' New Year’s resolution progress. Write a query to calculate the following for each friend: number of resolutions they made, number of resolutions they completed, and success percentage (% of resolutions completed) and a success category based on the success percentage:
- **Green**: If success percentage is greater than 75%.
- **Yellow**: If success percentage is between 50% and 75% (inclusive).
- **Red**: If success percentage is less than 50%.

**Table Name**: resolutions

| resolution_id | friend_name | resolution         | is_completed |
|---------------|-------------|--------------------|--------------|
| 1             | Alice       | Exercise daily     | 1            |
| 2             | Alice       | Read 20 books      | 0            |
| 3             | Bob         | Save money         | 0            |
| 4             | Bob         | Eat healthier      | 1            |
| 5             | Charlie     | Travel more        | 1            |
| 6             | Charlie     | Learn a new skill  | 1            |
| 7             | Diana       | Volunteer monthly  | 1            |
| 8             | Diana       | Drink more water   | 0            |
| 9             | Diana       | Sleep 8 hours      | 1            |

**Question Level of Difficulty**: Medium


### SQL Query

```sql
SELECT friend_name, COUNT(resolution_id) AS total_resolution,
SUM(CASE
 WHEN is_completed = 1 THEN 1 ELSE 0 END) AS resolution_completed,
ROUND(SUM(CASE
 WHEN is_completed = 1 THEN 1 ELSE 0 END) * 100 / COUNT(resolution_id), 2) AS success_percentage,
CASE
 WHEN SUM(CASE WHEN is_completed = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(resolution_id) > 75 THEN 'Green'
 WHEN SUM(CASE WHEN is_completed = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(resolution_id) BETWEEN 50 AND 75 THEN 'Yellow'
 ELSE 'Red'
 END AS success_category
FROM resolutions
GROUP BY friend_name;
```



### Step-by-Step Explanation

1. **SELECT friend_name**:
   - We want to group the results by `friend_name` to calculate the information for each individual.
  
2. **COUNT(resolution_id) AS total_resolution**:
   - The `COUNT(resolution_id)` counts the total number of resolutions each friend has made.

3. **SUM(CASE WHEN is_completed = 1 THEN 1 ELSE 0 END) AS resolution_completed**:
   - The `SUM(CASE...)` counts the number of completed resolutions. The `CASE` statement checks whether the `is_completed` column is 1 (completed). If so, it returns 1; otherwise, it returns 0. The sum of these values gives the total number of completed resolutions.

4. **ROUND(SUM(...) * 100 / COUNT(...), 2) AS success_percentage**:
   - The success percentage is calculated by dividing the number of completed resolutions by the total number of resolutions and multiplying by 100 to get the percentage. We use `ROUND(..., 2)` to round the success percentage to two decimal places.

5. **CASE WHEN ... THEN ... ELSE ... END AS success_category**:
   - The `CASE` statement assigns a success category based on the success percentage:
     - **Green**: If the success percentage is greater than 75%.
     - **Yellow**: If the success percentage is between 50% and 75% (inclusive).
     - **Red**: If the success percentage is less than 50%.

6. **FROM resolutions**:
   - We’re selecting data from the `resolutions` table.

7. **GROUP BY friend_name**:
   - We group the results by `friend_name` to calculate the values for each individual.



### Result

| friend_name | total_resolution | resolution_completed | success_percentage | success_category |
|-------------|------------------|----------------------|--------------------|------------------|
| Alice       | 2                | 1                    | 50                 | Yellow           |
| Bob         | 2                | 1                    | 50                 | Yellow           |
| Charlie     | 2                | 2                    | 100                | Green            |
| Diana       | 3                | 2                    | 66                 | Yellow           |
