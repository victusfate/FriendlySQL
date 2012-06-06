# Friendly SQL
----

## Rafael's Words of Wisdom on SQL

On Fri, Jun 01, 2012 at 08:22:21PM -0400, Mark Essel wrote:
> one part of my new startup job is being responsible for any problems that crop up. And our user data is all in a MySQL database, without any easy front end (ORM).
>
> Where do I begin?
>
> How did this happen?

SQL is nothing complicated. MySQL docs are great and you can search its manual for elements of its syntax: http://dev.mysql.com/doc/refman/5.0/en

You probably already know the basics, don't you? SELECT, DELETE and UPDATE are the basic things. BTW, if you're into the theory, look up relational algebra. I rather talk SQL than relational algebra, though.

When I learn a new language I usually need to "feel" the language. For me, the feel of SQL is that everything is tables. The basic operation is SELECT and it creates tables and reads from tables.

When you do "SELECT id, name FROM people" you are creating a new table which has two columns: id and name. You can use that anywhere a table is expected:
```sql
       SELECT t.id from (SELECT id, name FROM people) as t
````
There are joins. It joins two tables together. Think of cartesian product, you can't go wrong. inner join, outer join, natural join are all ways of filtering the cartesian product. The cartesian product is very simple. You have to sets:

       A = {a,b,c}
       B = {x,y,z}

The cartesian product will be all tuples.

       (a,x), (a,y), (a,z), (b,x), (b,y), (b,z), (c,x), (c,y), (c,z)

Now think that sets are tables and values are rows. Because that's what they are. A table is a set of rows.

Indexes provide efficient way to find a specific element in the set (otherwise you'd need to iterate over all of it). Database indexes are usually implemented as trees. So prefix matching is efficient as well. So name LIKE 'doug%' is fast. name LIKE '%doug' is slow.

This article has a good explanation with examples of the different kinds of joins: http://en.wikipedia.org/wiki/Join_(SQL). Don't worry too much about it, though.  Usually something like this:
```sql
       SELECT * FROM employee JOIN department ON employee.DepartmentID = department.DepartmentID;
```
is all you'll ever need. And you can even have that employee.DepartmentID = department.DepartmentID on your WHERE clause. So
```sql
       SELECT * FROM employee JOIN department WHERE employee.DepartmentID = department.DepartmentID;
```
is just as good. I can't think of a situation where the different forms are semanticwise and/or efficiencewise different,

When you do a select you can also filter by something, so you create a smaller table (with less rows):
```sql
       SELECT id FROM people WHERE first_name='joe'
```
That will create a table which has only one column and one row. All the rows will have people whose first name is joe.

In that case you transformed people's table in a table with only one column and fewer rows. You can add new columns with select:
```sql
       SELECT id, 1 as x FROM people
```
will create a table with ids and a column called x, which probably didn't exist in people.

Creating new rows using select is not possible. At least I can't think of a way of doing so right now. Except for something like "SELECT 1", no FROM. That works on MySQL and creates a new row. On oracle it would be "SELECT 1 FROM dual". Each DBMS has its way. You could also create a table with 10 rows and write SELECT invented_column1, invented_column2 FROM ten_row_table and manufacture 10 rows that way. However, that's not really the point of SQL. It's there so you can easily create queries to find your data.

That's my crash course on SQL. A lot of things missing, but hopefully it gives a feel. Now you can pay me in stocks from your startup :P

----

## Enobrev's Smooth Intro to SQL


That's a good introduction to SQL, and likely far better explained than any attempt I could make with twice as many words.

A minor addition, for applicability, is that I almost ALWAYS use "LEFT OUTER JOIN", and Cameo ONLY has them.  The difference generally seems small, but important.  I'm hoping that while I illustrate that fact, you also get to see how joins work.

From the Wikipedia link by your friend: "An outer join does not require each record in the two joined tables to have a matching record."

This, to me, is an important point.  Whenever I'm running a query, I just about always want ALL the matching rows from the main table, regardless of whether there are matching rows in the joined table.  The point of almost all my queries are the data in the main table.  The secondaries are ancillary and if I want to limit the results accordingly, I can do so explicitly.

Let's take 2 tables: users and cities

users: user_id, username, city_id
cities: city_id, city_name

and a couple records:

city_id, city_name
1, Chicago
2, New York

user_id, username, city_id
1, Messel, 2
2, Lauren, 1
3, Enobrev, NULL

Let's try that with a normal join:

```sql
SELECT
    users.username,
    cities.city_name
FROM
    users JOIN cities ON users.city_id = cities.city_id
```    

    Messel, New York
    Lauren, Chicago

As you can see, this excludes the 3rd row, because it doesn't have a city id.  Now, with an outer join:

```sql
SELECT
    users.username,
    cities.city_name
FROM
    users LEFT OUTER JOIN cities ON users.city_id = cities.city_id
```    

    Messel, New York
    Lauren, Chicago
    Enobrev, NULL

I can't think of many instances where I wouldn't want to list the 3rd user just because they don't have a city set in the database.  If that were the case, I would explicitly say so like so:

```sql
SELECT
    users.username,
    cities.city_name
FROM
    users LEFT OUTER JOIN cities ON users.city_id = cities.city_id
WHERE 
    users.city_id IS NOT NULL
```    

    Messel, New York
    Lauren, Chicago

Doing this the former way (INNER JOIN) reminds me of the "bug" you found in TJ Hollowaychuk's code.  It turned out the order of operations worked in his favor.  But I would still call it a bug, or at the VERY least sloppy code.  I prefer the more explicit route.  Sure, using [INNER] JOIN can be considered explicit, provided you know SQL well (just as Order of Ops are obvious to some), but when debugging code, I prefer the long form.  And besides, the long form allows other ways to be explicit:

```sql
SELECT
    users.username,
    cities.city_name
FROM
    users LEFT OUTER JOIN cities ON users.city_id = cities.city_id
WHERE users.city_id IS NOT NULL
AND users.city_name != 'Chicago'
```

    Messel, New York

In this case, we're just adding an additional where clause instead of mucking around with the join structure, which means the very same query can be:

```sql
SELECT
    users.username,
    cities.city_name
FROM
    users LEFT OUTER JOIN cities ON users.city_id = cities.city_id
WHERE users.city_name != 'Chicago'
```

    Messel, New York
    Enobrev, NULL

Again, our fields, and tables are untouched.  We're just modifying conditions, which makes what the query is trying to do fairly clear.  I think comparing these queries and results are more obvious to the reader.

All that said, I'm not necessarily saying ALWAYS USE OUTER JOINS.  I'm just saying that most of the tutorials you find on the subject do not show outer joins.  Almost every one I've read that wasn't a thorough tutorial (covering all the bases) relies on inner joins.  I think that's unfortunate.

Good luck with your learnin's

Mark 
(Armendariz) https://twitter.com/enobrev

----

## Elias' Friendly Advice

First thing to do is to make a visualization of your data. Popular GUI programs can exhibit your database schema as a diagram (where each table is a little square and table relationships are arrows and such)

Second thing is to start making sense of the data, what is really important, and specially notice what's not there and possible sources of inconsistencies. Take note of nullable columns, because your program logic will need to work normally on its absence. (non-nullable fields are marked "not null". fields are by default not null. A int field that is nullable might be a "null" instead, and you need to check)

Then start working on queries for doing simple things, always using the least amount of joins possible. Try to ask questions to the database: you will write them in sql, and they will reply with rows...

You need to decide if you will continue with mysql or will migrate to another thing entirely. A  problem with migrating is that usually mysql dbs hold only part of relevant data: queries are usually stored on the client. (on the place I interned they opted to store all queries on stored procedures, on the db.. to centralize with queries are needed and so on).

What you will need to think is, what do you do with joins? A solution might be to denormalize (that is, repeat the same data on many places so that you don't need to join), another is to transform a big query into many smaller queries. But if you don't have the actual queries -
from the source code of the program that interacted with the DB - you will need to guess which joins are needed. You can only do so if you already made sense of the data. So, if you can't yet grasp it, don't try migrating!

----

