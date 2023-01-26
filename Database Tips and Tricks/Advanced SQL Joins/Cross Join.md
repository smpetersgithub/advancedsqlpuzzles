## CROSS JOINS

A CROSS JOIN creates all permutations (i.e., a cartesian product) or combinations of the two joining tables.  It will produce a result set which is the number of rows in the first table multiplied by the number of rows in the second table.

It is important to be mindful of the number of rows in each table, because a cross join will return the product of the number of rows of both tables. If one table has 100 rows and the other has 1000 rows, a cross join will return 100,000 rows. Therefore, cross join can cause performance issues if used on large tables.

Note, you can also use recursion to generate permutation sets.  The benefit of using recusion is when you have an unknown number of elements that you need to create permuations on, which you may not know at runtime.  With CROSS JOINS you need to manually create each join.

### Permutations vs Combinations

Permutations and combinations are both ways of arranging a set of items, but they differ in how the items are arranged.

Permutations are a way of arranging a set of items in a specific order. For example, if you have the set of items {A, B, C}, there are 3! (3 factorial) or 6 possible permutations: ABC, ACB, BAC, BCA, CAB, CBA.

Combinations, on the other hand, are a way of selecting a subset of items from a set, without regard to the order. For example, if you have the set of items {A, B, C}, there are 3 C 2 (read as "3 choose 2") or 3 possible combinations: AB, AC, BC.

In summary, permutations are arrangements of items in a specific order, while combinations are selections of items without regard to the order.

---

Here is a simplest form of the CROSS JOIN that creates all permutations between two datasets.

```sql
SELECT  a.ID,
        a.Fruit,
        b.ID,
        b.Fruit
FROM    ##TableA a CROSS JOIN
        ##TableB b;
```

| ID | Fruit  | ID | Fruit  |
|----|--------|----|--------|
|  1 | Apple  |  1 | Apple  |
|  2 | Peach  |  1 | Apple  |
|  3 | Mango  |  1 | Apple  |
|  4 | <NULL> |  1 | Apple  |
|  1 | Apple  |  2 | Peach  |
|  2 | Peach  |  2 | Peach  |
|  3 | Mango  |  2 | Peach  |
|  4 | <NULL> |  2 | Peach  |
|  1 | Apple  |  3 | Kiwi   |
|  2 | Peach  |  3 | Kiwi   |
|  3 | Mango  |  3 | Kiwi   |
|  4 | <NULL> |  3 | Kiwi   |
|  1 | Apple  |  4 | <NULL> |
|  2 | Peach  |  4 | <NULL> |
|  3 | Mango  |  4 | <NULL> |
|  4 | <NULL> |  4 | <NULL> |

---

You can simulate an INNER JOIN using a CROSS JOIN by placing the join logic in the WHERE clause using an equi-join
  
```sql
SELECT  a.ID,
        a.Fruit,
        b.ID,
        b.Fruit
FROM    ##TableA a CROSS JOIN
        ##TableB b
WHERE   a.Fruit = b.Fruit;
```
  
| ID | Fruit | ID | Fruit |
|----|-------|----|-------|
|  1 | Apple |  1 | Apple |
|  2 | Peach |  2 | Peach |  
 
---
  
In order to simulate a LEFT OUTER JOIN using a CROSS JOIN, you will need to incorporate SET operators (UNION) and an anti-join (NOT EXISTS).  

```sql
SELECT  a.ID,
        a.Fruit,
        b.ID,
        b.Fruit
FROM    ##TableA a CROSS JOIN 
        ##TableB b
WHERE   a.Fruit = b.Fruit
UNION
SELECT  a.ID,
        a.Fruit,
        NULL,
        NULL
FROM    ##TableA a
WHERE   NOT EXISTS (SELECT 1 FROM ##TableB b where a.Fruit = b.Fruit);
```

| ID | Fruit  |   ID   | Fruit  |
|----|--------|--------|--------|
|  1 | Apple  | 1      | Apple  |
|  2 | Peach  | 2      | Peach  |
|  3 | Mango  | <NULL> | <NULL> |
|  4 | <NULL> | <NULL> | <NULL> |

---  
  
The following produces all combinations (not permuations).
  
Given all fruits in both Table A and Table B, here is a result set of all fruit combinations.  Because of the theta-join in the WHERE clause, the fruits are listed in alphabetical order left to right, as Apple and Peach are the same as Peach and Apple.  Note that NULL markers are not included in the result set, as NULL markers are not equal to each other nor are they equal to each other, they are unknown.
  
```sql
WITH cte_DistinctFruits as
(
SELECT Fruit FROM ##TableA
UNION
SELECT Fruit FROM ##TableB
)
SELECT
        a.Fruit,
        b.Fruit
FROM    cte_DistinctFruits a CROSS JOIN
        cte_DistinctFruits b
WHERE   a.Fruit < b.Fruit
```                          

| Fruit | Fruit |
|-------|-------|
| Apple | Kiwi  |
| Apple | Mango |
| Apple | Peach |
| Kiwi  | Mango |
| Kiwi  | Peach |
| Mango | Peach |

          
                          
---
If you need to find reciprocals on a result set and presever NULL markers, you can use the following CASE statement.
                         
```sql
SELECT  DISTINCT
        (CASE WHEN a.Fruit < b.Fruit THEN a.Fruit else b.Fruit END) AS Fruit,
        (CASE WHEN a.Fruit < b.Fruit THEN b.Fruit else a.Fruit END) AS Fruit
FROM    ##TableA a CROSS JOIN
        ##TableB b
WHERE   a.Fruit <> b.Fruit OR a.Fruit IS NULL OR b.Fruit IS NULL;
```

| Fruit  | Fruit  |
|--------|--------|
| <NULL> | <NULL> |
| <NULL> | Apple  |
| <NULL> | Mango  |
| <NULL> | Peach  |
| Apple  | <NULL> |
| Apple  | Kiwi   |
| Apple  | Mango  |
| Apple  | Peach  |
| Kiwi   | <NULL> |
| Kiwi   | Mango  |
| Kiwi   | Peach  |
| Mango  | Peach  |
| Peach  | <NULL> |

---                                   
    
Up next semi and anti-joins.
  
Happy coding!