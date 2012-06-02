Rafael's Words of Wisdom on SQL
---------------

On Fri, Jun 01, 2012 at 08:22:21PM -0400, Mark Essel wrote:
> one part of my new startup job is being responsible for any problems that crop up. And our user data is all in a MySQL database, without any easy front end (ORM).
>
> Where do I begin?
>
> How did this happen?

SQL is nothing complicated. MySQL docs are great and you can search its manual for elements of its syntax: [http://dev.mysql.com/doc/refman/5.0/en](http://dev.mysql.com/doc/refman/5.0/en)

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

