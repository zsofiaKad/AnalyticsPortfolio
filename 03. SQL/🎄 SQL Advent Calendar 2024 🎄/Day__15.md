### DAY 15: Top Parents by Number of Children 👨‍👩‍👧‍👦

A family reunion is being planned, and the organizer wants to identify the three family members with the most children. Write a query to calculate the total number of children for each parent and rank them. Include the parent’s name and their total number of children in the result.

**Table Name**: family_members

| member_id | name     | age |
|-----------|----------|-----|
| 1         | Alice    | 30  |
| 2         | Bob      | 58  |
| 3         | Charlie  | 33  |
| 4         | Diana    | 55  |
| 5         | Eve      | 5   |
| 6         | Frank    | 60  |
| 7         | Grace    | 32  |
| 8         | Hannah   | 8   |
| 9         | Ian      | 12  |
| 10        | Jack     | 3   |

**Table Name**: parent_child_relationships

| parent_id | child_id |
|-----------|----------|
| 2         | 1        |
| 3         | 5        |
| 4         | 1        |
| 6         | 7        |
| 6         | 8        |
| 7         | 9        |
| 7         | 10       |
| 4         | 8        |


**Question Level of Difficulty**: Hard


### SQL Query

```sql
WITH family_reunion AS (
    SELECT
        name, COUNT(child_id) AS num_children
    FROM family_members AS fm
    JOIN parent_child_relationships AS p
    ON fm.member_id = p.parent_id
    GROUP BY fm.name, fm.member_id
),
ranking AS (
    SELECT
        name, num_children,
        RANK() OVER (ORDER BY num_children DESC) AS rank
    FROM family_reunion
)
SELECT name, num_children
FROM ranking
WHERE rank <= 3
ORDER BY num_children DESC;
```

### Step-by-Step Explanation

1. **Calculate the total number of children for each parent (family_reunion CTE):**
   - **Join Tables:** The `family_members` table is joined with `parent_child_relationships` on `fm.member_id = p.parent_id`, connecting parents with their children.
   - **Count Children:** `COUNT(child_id)` calculates the total number of children for each parent, aliased as `num_children`.
   - **Group by Parent:** Grouping is done by `fm.name, fm.member_id` to ensure unique results for each parent.

2. **Rank parents by the number of children (ranking CTE):**
   - **Assign Rank:** Use `RANK() OVER (ORDER BY num_children DESC)` to rank parents based on their number of children, sorted in descending order.
   - **Handle Ties:** Parents with the same `num_children` share the same rank.

3. **Filter to keep only the top 3 ranked parents:**
   - The use of `WHERE rank <= 3` ensures all parents tied at rank 3 are included, making the query more comprehensive than a simple LIMIT.

4. **Sort the final results:**
   - Order the output by `num_children DESC` to list parents with the most children first.

**Result**

| name  | num_children |
|-------|--------------|
| Diana | 2            |
| Frank | 2            |
| Grace | 2            |


