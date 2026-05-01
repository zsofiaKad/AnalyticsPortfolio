**DAY 22: Identifying Guests Without Gifts 🎁**

We are hosting a gift party and need to ensure every guest receives a gift. Using the `guests` and `guest_gifts` tables, write a query to identify the guest(s) who have not been assigned a gift (i.e. they are not listed in the `guest_gifts` table). 

**Table Name: guests**

| guest_id | guest_name      |
|----------|-----------------|
| 1        | Cindy Lou       |
| 2        | The Grinch      |
| 3        | Max the Dog     |
| 4        | Mayor May Who   |

**Table Name: guest_gifts**

| gift_id | guest_id | gift_name    |
|---------|----------|--------------|
| 1       | 1        | Toy Train    |
| 2       | 1        | Plush Bear   |
| 3       | 2        | Bag of Coal  |
| 4       | 2        | Sleigh Bell  |
| 5       | 3        | Dog Treats   |

**Question level of difficulty:** Medium 


**QUERY:**

```sql
SELECT g.guest_name
FROM guests AS g
LEFT JOIN guest_gifts AS gg
ON g.guest_id = gg.guest_id
WHERE gg.gift_id IS NULL;
```



**STEP-BY-STEP EXPLANATION:**

1. **Select guest names from the guests table:**
   - We want to identify guests who have not been assigned a gift, so we start by selecting data from the `guests` table, which contains a list of all guests.

2. **Perform a LEFT JOIN with the guest_gifts table:**
   - The `LEFT JOIN` ensures that all records from the `guests` table are included, even if there is no corresponding record in the `guest_gifts` table (meaning the guest hasn't received a gift).
   - The `ON g.guest_id = gg.guest_id` condition links each guest to their assigned gift in the `guest_gifts` table.

3. **Filter guests who have not received a gift:**
   - The `WHERE` clause checks for rows where the `gift_id` in the `guest_gifts` table is `NULL`, indicating that no gift has been assigned to the guest.



**RESULT:**

| guest_name    |
|---------------|
| Mayor May Who |

