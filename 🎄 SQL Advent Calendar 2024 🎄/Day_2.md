### **Day 2: Gifts Weighing More Than 1kg**  
**Question:**  
Santa wants to know which gifts weigh more than 1 kg. Can you list them?  

**Table Name:** `gifts`  

| GIFT_NAME         | RECIPIENT | WEIGHT_KG |
|-------------------|-----------|-----------|
| TOY TRAIN         | JOHN      | 2.5       |
| CHOCOLATE BOX     | ALICE     | 0.8       |
| TEDDY BEAR        | SOPHIA    | 1.2       |
| BOARD GAME        | LIAM      | 0.9       |

**Difficulty Level:** Easy  

**SQL Query:**  
```sql
SELECT gift_name
FROM gifts
WHERE weight_kg > 1;
```

**Explanation:**  
1. **`SELECT gift_name`**: We only need the names of the gifts, so we select the `gift_name` column.  
2. **`FROM gifts`**: Specifies the table from which we are retrieving the data.  
3. **`WHERE weight_kg > 1`**: Filters the rows where the `weight_kg` column is greater than 1 kg, ensuring only gifts heavier than 1 kg are included.  

**Result:**  
| GIFT_NAME    |
|--------------|
| TOY TRAIN    |
| TEDDY BEAR   |
