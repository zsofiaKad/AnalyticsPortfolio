### Day 8: Inventory Check at Santa's Workshop 🎁  

**You are managing inventory in Santa's workshop. Which gifts are meant for "good" recipients? List the gift name and its weight.**  


**Table Name**: `gifts`  

| GIFT_ID | GIFT_NAME      | RECIPIENT_TYPE | WEIGHT_KG |  
|---------|----------------|----------------|-----------|  
| 1       | TOY TRAIN      | GOOD           | 2.5       |  
| 2       | LUMPS OF COAL  | NAUGHTY        | 1.5       |  
| 3       | TEDDY BEAR     | GOOD           | 1.2       |  
| 4       | CHOCOLATE BAR  | GOOD           | 0.3       |  
| 5       | BOARD GAME     | NAUGHTY        | 1.8       |  


### **Question Level of Difficulty**: Easy  

### **SQL Query**  
```sql
SELECT gift_name, weight_kg
FROM gifts
WHERE recipient_type = 'good';
```  


### **Step-by-Step Explanation**  

1. **`SELECT gift_name, weight_kg`:**  
   - Retrieves the `gift_name` and `weight_kg` columns from the `gifts` table for display.  
   - `gift_name`: Represents the name of the gift.  
   - `weight_kg`: Shows the weight of the gift in kilograms.  

2. **`FROM gifts`:**  
   - Specifies the source table `gifts` where the data is stored.  

3. **`WHERE recipient_type = 'good'`:**  
   - Filters the results to include only rows where the `recipient_type` is `'good'`. This ensures only gifts meant for "good" recipients are included in the result.  



### **Results**  

| GIFT_NAME     | WEIGHT_KG |  
|---------------|-----------|  
| Toy Train     | 2.5       |  
| Teddy Bear    | 1.2       |  
| Chocolate Bar | 0.3       |  
