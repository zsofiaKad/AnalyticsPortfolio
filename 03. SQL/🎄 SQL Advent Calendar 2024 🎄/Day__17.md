### DAY 17: Grinch's Holiday Prank Planning 🎄🎁
 
The Grinch is planning out his pranks for this holiday season. Which pranks have a difficulty level of "Advanced" or "Expert"? List the prank name and location (both in descending order).



**Table Name**: grinch_pranks

| prank_id | prank_name              | location               | difficulty |
|----------|-------------------------|------------------------|------------|
| 1        | Stealing Stockings      | Whoville              | Beginner   |
| 2        | Christmas Tree Topple   | Whoville Town Square  | Advanced   |
| 3        | Present Swap            | Cindy Lou's House     | Beginner   |
| 4        | Sleigh Sabotage         | Mount Crumpit         | Expert     |
| 5        | Chimney Block           | Mayor's Mansion       | Expert     |


**Question Level of Difficulty**: Easy



### SQL Query

```sql
SELECT prank_name, location
FROM grinch_pranks
WHERE difficulty = 'Advanced' OR difficulty = 'Expert'
ORDER BY prank_name DESC, location DESC;
```

### Step-by-Step Explanation

1. **Identify the Columns to Retrieve:**
   - Use the `SELECT` statement to specify the columns `prank_name` and `location` to include in the output.

2. **Filter the Rows Based on Difficulty:**
   - The `WHERE` clause is used to filter rows where the `difficulty` column is either `'Advanced'` or `'Expert'`.
   - The condition `difficulty = 'Advanced' OR difficulty = 'Expert'` ensures only the pranks matching these levels are included.

3. **Sort the Results:**
   - Use the `ORDER BY` clause to arrange the results in descending order:
     - First by `prank_name` (in reverse alphabetical order).
     - Then by `location` (also in reverse alphabetical order) as a secondary sorting criterion.


**Result**

| prank_name            | location              |
|-----------------------|-----------------------|
| Sleigh Sabotage       | Mount Crumpit        |
| Christmas Tree Topple | Whoville Town Square |
| Chimney Block         | Mayor's Mansion      |
