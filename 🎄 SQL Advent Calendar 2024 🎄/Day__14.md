### DAY 14: Ski Resorts with Significant Snowfall ❄️⛷️

**Challenge**: Identify ski resorts that experienced snowfall greater than 50 inches.


**Table Name**: snowfall

| resort_name      | location      | snowfall_inches |
|-------------------|---------------|-----------------|
| Snowy Peaks      | Colorado      | 60              |
| Winter Wonderland | Utah         | 45              |
| Frozen Slopes    | Alaska        | 75              |



**Question Level of Difficulty**: Easy


### SQL Query

```sql
SELECT resort_name, location, snowfall_inches
FROM snowfall
WHERE snowfall_inches > 50;
```

### Step-by-Step Explanation:

1. **`SELECT resort_name, location, snowfall_inches`:**
   - Specifies the columns to include in the output:
     - `resort_name`: The name of the ski resort.
     - `location`: The location of the ski resort.
     - `snowfall_inches`: The amount of snowfall recorded.

2. **`FROM snowfall`:**
   - Indicates the `snowfall` table as the data source for the query.

3. **`WHERE snowfall_inches > 50`:**
   - Filters the rows to include only those ski resorts where the `snowfall_inches` value is greater than 50.



### Result

| resort_name   | location  | snowfall_inches |
|---------------|-----------|-----------------|
| Snowy Peaks   | Colorado  | 60              |
| Frozen Slopes | Alaska    | 75              |
