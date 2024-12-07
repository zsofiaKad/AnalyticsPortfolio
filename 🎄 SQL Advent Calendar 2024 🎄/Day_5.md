### Day 5: Christmas in the Southern Hemisphere 🎅🏖️

**Challenge**: This year, we're celebrating Christmas in the Southern Hemisphere! Which beaches are expected to have temperatures above 30°C on Christmas Day?


**Table Name**: `beach_temperature_predictions`

| BEACH_NAME      | COUNTRY          | EXPECTED_TEMPERATURE_C | DATE       |
|------------------|------------------|-------------------------|------------|
| BONDI BEACH     | AUSTRALIA        | 32                      | 2024-12-24 |
| COPACABANA BEACH| BRAZIL           | 28                      | 2024-12-24 |
| CLIFTON BEACH   | SOUTH AFRICA     | 31                      | 2024-12-25 |
| BRIGHTON BEACH  | NEW ZEALAND      | 25                      | 2024-12-25 |


### **Question Level of Difficulty**: Easy


### **SQL Query**
```sql
SELECT beach_name, country
FROM beach_temperature_predictions
WHERE expected_temperature_c > 30 AND date = '2024-12-25';
```


### **Step-by-Step Explanation**
1. **`SELECT beach_name, country`:**
   - Retrieves the beach name and its country for the results.
2. **`FROM beach_temperature_predictions`:**
   - Specifies the table containing the predictions for beach temperatures.
3. **`WHERE expected_temperature_c > 30`:**
   - Filters for beaches where the expected temperature exceeds 30°C.
4. **`AND date = '2024-12-25'`:**
   - Ensures only predictions for Christmas Day (2024-12-25) are included.


### **Result**
| BEACH_NAME      | COUNTRY        |
|------------------|----------------|
| CLIFTON BEACH   | SOUTH AFRICA   |
