### DAY 11: Preparing Holiday Gifts 🎁

You are preparing holiday gifts for your family. Who in the `family_members` table are celebrating their birthdays in December 2024? List their name and birthday.


**Table Name**: family_members

| member_id | name    | relationship | birthday   |
|-----------|---------|--------------|------------|
| 1         | Dawn    | Sister       | 2024-12-24 |
| 2         | Bob     | Father       | 2024-05-20 |
| 3         | Charlie | Brother      | 2024-12-25 |
| 4         | Diana   | Mother       | 2024-03-15 |


**Question Level of Difficulty**: Easy



### SQL Query

```sql
SELECT 
    name, 
    birthday
FROM 
    family_members
WHERE 
    MONTH(birthday) = 12
    AND YEAR(birthday) = 2024;
```

**In SQL Lite, it would be**:

```sql
SELECT name, birthday
FROM family_members
WHERE
STRFTIME('%m', birthday) = '12'
AND STRFTIME('%Y', birthday) = '2024'; 
```


### Step-by-Step Explanation:

1. **SELECT name, birthday**:
   - We are selecting the `name` and `birthday` columns to show the names and birthdates of family members who have birthdays in December.

2. **FROM family_members**:
   - We are querying the `family_members` table, which contains information about each family member's name, relationship, and birthday.

3. **WHERE MONTH(birthday) = 12**:
   - The `MONTH(birthday)` function extracts the month part of the `birthday` column. We check if the month is 12 (December).

4. **AND YEAR(birthday) = 2024**:
   - The `YEAR(birthday)` function extracts the year part of the `birthday` column. We check if the year is 2024.



### Result

| name    | birthday   |
|---------|------------|
| Dawn    | 2024-12-24 |
| Charlie | 2024-12-25 |
