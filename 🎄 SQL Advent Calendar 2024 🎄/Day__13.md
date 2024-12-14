### DAY 13: Balancing Santa's Sleigh 🎅🎁

**Challenge**: To ensure Santa's sleigh is properly balanced, we need to find the total weight of gifts for each recipient.


**Table Name**: gifts

| gift_id | gift_name       | recipient | weight_kg |
|---------|-----------------|-----------|-----------|
| 1       | Toy Train       | John      | 2.5       |
| 2       | Chocolate Box   | Alice     | 0.8       |
| 3       | Teddy Bear      | Sophia    | 1.2       |
| 4       | Board Game      | John      | 0.9       |



**Question Level of Difficulty**: Medium



### SQL Query

```sql
SELECT recipient, SUM(weight_kg) AS total_weight
FROM gifts
GROUP BY recipient
ORDER BY total_weight DESC;
```



### Step-by-Step Explanation:

1. **`SELECT recipient, SUM(weight_kg) AS total_weight`:**
   - Selects the `recipient` column to display each recipient's name in the output.
   - Uses `SUM(weight_kg)` to calculate the total weight of gifts for each recipient.
   - Aliases the result as `total_weight` for clarity.

2. **`FROM gifts`:**
   - Specifies the `gifts` table as the data source for the query.

3. **`GROUP BY recipient`:**
   - Groups the rows by the `recipient` column.
   - Ensures that each recipient forms a unique group, and the total weight of their gifts is calculated for that group.

4. **`ORDER BY total_weight DESC`:**
   - Sorts the results in descending order of `total_weight`.
   - Ensures recipients with the heaviest total gift weight appear first.



### Result

| recipient | total_weight |
|-----------|--------------|
| John      | 3.4          |
| Sophia    | 1.2          |
| Alice     | 0.8          |
