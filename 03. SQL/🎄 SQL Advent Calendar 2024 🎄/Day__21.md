**DAY 21: Calculating Gift Weight for Santa’s Sleigh** 🎅🎁

Santa needs to optimize his sleigh for Christmas deliveries. Write a query to calculate the total weight of gifts for each recipient type (good or naughty) and determine what percentage of the total weight is allocated to each type. Include the recipient_type, total_weight, and weight_percentage in the result.

**Table Name: gifts**

| gift_id | gift_name      | recipient_type | weight_kg |
|---------|----------------|----------------|-----------|
| 1       | Toy Train      | good           | 2.5       |
| 2       | Lumps of Coal  | naughty        | 1.5       |
| 3       | Teddy Bear     | good           | 1.2       |
| 4       | Chocolate Bar  | good           | 0.3       |
| 5       | Board Game     | naughty        | 1.8       |

**Question level of difficulty:** Hard



**QUERY:**

```sql
WITH total_weights AS (
    SELECT recipient_type, 
    SUM(weight_kg) AS total_weight
    FROM gifts
    GROUP BY recipient_type
),
grand_total AS (
    SELECT SUM(total_weight) AS grand_total_weight
    FROM total_weights
)
SELECT 
    tw.recipient_type, 
    tw.total_weight,
    ROUND((tw.total_weight / gt.grand_total_weight) * 100, 2) AS weight_percentage
FROM total_weights AS tw
CROSS JOIN grand_total AS gt;
```


**EXPLANATION (STEP-BY-STEP):**

1. **Calculate total weight for each recipient type:**
   - The `SUM(weight_kg)` aggregates the weight of gifts for each `recipient_type` (good or naughty).
   - The `GROUP BY recipient_type` ensures we calculate this sum separately for each recipient type.
   - This result is stored in the `total_weights` Common Table Expression (CTE).

2. **Calculate the grand total weight:**
   - The `SUM(total_weight)` aggregates the total weight from all recipient types.
   - This provides the overall total weight of all gifts, stored in the `grand_total` CTE.

3. **Combine total weights and grand total:**
   - The `CROSS JOIN` combines every row from `total_weights` with the single-row result from `grand_total`.
   - This allows us to calculate the percentage for each recipient type:  
     `weight_percentage = (total weight for type / grand total weight) * 100`
   - The `ROUND(..., 2)` ensures the percentage is displayed with two decimal places.

4. **Output columns:**
   - `recipient_type`: Indicates whether the recipient type is "good" or "naughty."
   - `total_weight`: Total weight of gifts for each recipient type.
   - `weight_percentage`: The proportion of the total weight allocated to each type, expressed as a percentage.



**RESULT:**

| recipient_type | total_weight | weight_percentage |
|----------------|--------------|-------------------|
| good           | 4            | 54.79             |
| naughty        | 3.3          | 45.21             |

