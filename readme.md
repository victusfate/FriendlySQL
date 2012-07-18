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
AND cities.city_name != 'Chicago'
```

    Messel, New York

In this case, we're just adding an additional where clause instead of mucking around with the join structure, which means the very same query can be:

```sql
SELECT
    users.username,
    cities.city_name
FROM
    users LEFT OUTER JOIN cities ON users.city_id = cities.city_id
WHERE cities.city_name != 'Chicago'
```

    Messel, New York
    Enobrev, NULL

The above querys in sqlfiddle: http://sqlfiddle.com/#!2/f1a2e/3

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

## Advanced Queries, Solving the Shortest Path with SQL

<a class="sh2" href="http://www.depesz.com/2012/06/25/how-to-get-shortest-connection-between-two-cities/" rel="bookmark" title="Permanent Link to How to get shortest connection between two cities">How to get shortest connection between two cities</a>
<div class="single-post-meta-top">Jun 25th, 2012 @ 05:43 pm &rsaquo; depesz<br />

<p>Yesterday, on <a href="irc://irc.freenode.net/#postgresql">#postgresql on irc</a> some guy asked:</p>

<div class="wp_syntax"><div class="code"><pre class="text" style="font-family:monospace;">22:28 &lt; rafasc&gt; i am trying to use plpgsql to find the shortest path between two cities, each pair of cities has one or more edges, each edge has a different wheight.
22:28 &lt; rafasc&gt; Is there a easy way to compute the shortest path between two cities?</pre></div></div>

<p>Well, I was not really in a mood to solve it, so I just told him to try with recursive queries, and went on my way.</p>
<p>But I thought about it. And decided to see if I can write the query.</p>
<p><span id="more-2482"></span></p>
<p>To get some test data, I created two simple tables:</p>

<div class="wp_syntax"><div class="code"><pre class="sql" style="font-family:monospace;">$ \d cities
<span style="color: #993333; font-weight: bold;">TABLE</span> <span style="color: #ff0000;">&quot;public.cities&quot;</span>
<span style="color: #993333; font-weight: bold;">COLUMN</span> │ <span style="color: #993333; font-weight: bold;">TYPE</span> │ Modifiers
────────┼──────┼───────────
 city   │ text │ <span style="color: #993333; font-weight: bold;">NOT</span> <span style="color: #993333; font-weight: bold;">NULL</span>
Indexes:
<span style="color: #ff0000;">&quot;cities_pkey&quot;</span> <span style="color: #993333; font-weight: bold;">PRIMARY</span> <span style="color: #993333; font-weight: bold;">KEY</span><span style="color: #66cc66;">,</span> btree <span style="color: #66cc66;">&#40;</span>city<span style="color: #66cc66;">&#41;</span>
Referenced <span style="color: #993333; font-weight: bold;">BY</span>:
<span style="color: #993333; font-weight: bold;">TABLE</span> <span style="color: #ff0000;">&quot;routes&quot;</span> <span style="color: #993333; font-weight: bold;">CONSTRAINT</span> <span style="color: #ff0000;">&quot;routes_from_city_fkey&quot;</span> <span style="color: #993333; font-weight: bold;">FOREIGN</span> <span style="color: #993333; font-weight: bold;">KEY</span> <span style="color: #66cc66;">&#40;</span>from_city<span style="color: #66cc66;">&#41;</span> <span style="color: #993333; font-weight: bold;">REFERENCES</span> cities<span style="color: #66cc66;">&#40;</span>city<span style="color: #66cc66;">&#41;</span>
<span style="color: #993333; font-weight: bold;">TABLE</span> <span style="color: #ff0000;">&quot;routes&quot;</span> <span style="color: #993333; font-weight: bold;">CONSTRAINT</span> <span style="color: #ff0000;">&quot;routes_to_city_fkey&quot;</span> <span style="color: #993333; font-weight: bold;">FOREIGN</span> <span style="color: #993333; font-weight: bold;">KEY</span> <span style="color: #66cc66;">&#40;</span>to_city<span style="color: #66cc66;">&#41;</span> <span style="color: #993333; font-weight: bold;">REFERENCES</span> cities<span style="color: #66cc66;">&#40;</span>city<span style="color: #66cc66;">&#41;</span>
&nbsp;
$ \d routes
<span style="color: #993333; font-weight: bold;">TABLE</span> <span style="color: #ff0000;">&quot;public.routes&quot;</span>
<span style="color: #993333; font-weight: bold;">COLUMN</span>   │  <span style="color: #993333; font-weight: bold;">TYPE</span>   │ Modifiers
───────────┼─────────┼───────────
 from_city │ text    │ <span style="color: #993333; font-weight: bold;">NOT</span> <span style="color: #993333; font-weight: bold;">NULL</span>
 to_city   │ text    │ <span style="color: #993333; font-weight: bold;">NOT</span> <span style="color: #993333; font-weight: bold;">NULL</span>
 <span style="color: #993333; font-weight: bold;">LENGTH</span>    │ <span style="color: #993333; font-weight: bold;">INTEGER</span> │ <span style="color: #993333; font-weight: bold;">NOT</span> <span style="color: #993333; font-weight: bold;">NULL</span>
Indexes:
<span style="color: #ff0000;">&quot;routes_pkey&quot;</span> <span style="color: #993333; font-weight: bold;">PRIMARY</span> <span style="color: #993333; font-weight: bold;">KEY</span><span style="color: #66cc66;">,</span> btree <span style="color: #66cc66;">&#40;</span>from_city<span style="color: #66cc66;">,</span> to_city<span style="color: #66cc66;">&#41;</span>
<span style="color: #993333; font-weight: bold;">CHECK</span> constraints:
<span style="color: #ff0000;">&quot;routes_check&quot;</span> <span style="color: #993333; font-weight: bold;">CHECK</span> <span style="color: #66cc66;">&#40;</span>from_city <span style="color: #66cc66;">&lt;</span> to_city<span style="color: #66cc66;">&#41;</span>
Foreign<span style="color: #66cc66;">-</span><span style="color: #993333; font-weight: bold;">KEY</span> constraints:
<span style="color: #ff0000;">&quot;routes_from_city_fkey&quot;</span> <span style="color: #993333; font-weight: bold;">FOREIGN</span> <span style="color: #993333; font-weight: bold;">KEY</span> <span style="color: #66cc66;">&#40;</span>from_city<span style="color: #66cc66;">&#41;</span> <span style="color: #993333; font-weight: bold;">REFERENCES</span> cities<span style="color: #66cc66;">&#40;</span>city<span style="color: #66cc66;">&#41;</span>
<span style="color: #ff0000;">&quot;routes_to_city_fkey&quot;</span> <span style="color: #993333; font-weight: bold;">FOREIGN</span> <span style="color: #993333; font-weight: bold;">KEY</span> <span style="color: #66cc66;">&#40;</span>to_city<span style="color: #66cc66;">&#41;</span> <span style="color: #993333; font-weight: bold;">REFERENCES</span> cities<span style="color: #66cc66;">&#40;</span>city<span style="color: #66cc66;">&#41;</span></pre></div></div>

<p>Data in them is very simple:</p>

<div class="wp_syntax"><div class="code"><pre class="sql" style="font-family:monospace;">$ <span style="color: #993333; font-weight: bold;">SELECT</span> <span style="color: #66cc66;">*</span> <span style="color: #993333; font-weight: bold;">FROM</span> cities <span style="color: #993333; font-weight: bold;">LIMIT</span> <span style="color: #cc66cc;">5</span>;
      city
────────────────
 Vancouver
 Calgary
 Winnipeg
 Sault St Marie
 Montreal
<span style="color: #66cc66;">&#40;</span><span style="color: #cc66cc;">5</span> <span style="color: #993333; font-weight: bold;">ROWS</span><span style="color: #66cc66;">&#41;</span>
&nbsp;
$ <span style="color: #993333; font-weight: bold;">SELECT</span> <span style="color: #66cc66;">*</span> <span style="color: #993333; font-weight: bold;">FROM</span> routes <span style="color: #993333; font-weight: bold;">LIMIT</span> <span style="color: #cc66cc;">5</span>;
 from_city │  to_city  │ <span style="color: #993333; font-weight: bold;">LENGTH</span>
───────────┼───────────┼────────
 Calgary   │ Vancouver │      <span style="color: #cc66cc;">3</span>
 Seattle   │ Vancouver │      <span style="color: #cc66cc;">1</span>
 Portland  │ Seattle   │      <span style="color: #cc66cc;">1</span>
 Calgary   │ Seattle   │      <span style="color: #cc66cc;">4</span>
 Calgary   │ Helena    │      <span style="color: #cc66cc;">4</span>
<span style="color: #66cc66;">&#40;</span><span style="color: #cc66cc;">5</span> <span style="color: #993333; font-weight: bold;">ROWS</span><span style="color: #66cc66;">&#41;</span></pre></div></div>

<p>In case you wonder &#8211; the data represents base map for &#8220;Ticket to Ride&#8221; game &#8211; awesome thing, and if you haven&#8217;t played it &#8211; get it, and play.</p>
<p><a href="/wp-content/uploads/2012/06/Ticket_to_ride.png"><img src="/wp-content/uploads/2012/06/Ticket_to_ride-small.png" width="400" height="300" alt="Ticket to Ride - US Map"/></a></p>
<p>This map was part of <a href="http://arstechnica.com/gaming/2011/05/review-ticket-to-ride-on-ipad-a-high-quality-port-of-board-game/" onclick="pageTracker._trackPageview('/outgoing/arstechnica.com/gaming/2011/05/review-ticket-to-ride-on-ipad-a-high-quality-port-of-board-game/?referer=');">review</a> of the game on <a href="http://arstechnica.com" onclick="pageTracker._trackPageview('/outgoing/arstechnica.com?referer=');">ars technica</a>.</p>
<p>But anyway. So, I have 36 cities, and 78 unique paths between them, each with length information. So, with this I should be able to find the shortest path.</p>
<p>One word of warning though &#8211; the fact that it&#8217;s possible to do in database, doesn&#8217;t mean it&#8217;s good idea. Personally, I think that it should be done in some standalone application, which would use some smarter algorithms, extensive cache, and so on. But &#8211; this is just a proof of concept, and the data size that I&#8217;m working on is small enough that it shouldn&#8217;t matter.</p>
<p>Each route is stored only once in routes. So I&#8217;ll start by duplicating the rows, so I will have them written &#8220;in both directions&#8221;:</p>

<div class="wp_syntax"><div class="code"><pre class="sql" style="font-family:monospace;"><span style="color: #993333; font-weight: bold;">CREATE</span> <span style="color: #993333; font-weight: bold;">VIEW</span> all_routes <span style="color: #993333; font-weight: bold;">AS</span>
    <span style="color: #993333; font-weight: bold;">SELECT</span> from_city<span style="color: #66cc66;">,</span> to_city<span style="color: #66cc66;">,</span> <span style="color: #993333; font-weight: bold;">LENGTH</span> <span style="color: #993333; font-weight: bold;">FROM</span> routes
    <span style="color: #993333; font-weight: bold;">UNION</span> <span style="color: #993333; font-weight: bold;">ALL</span>
    <span style="color: #993333; font-weight: bold;">SELECT</span> to_city<span style="color: #66cc66;">,</span> from_city<span style="color: #66cc66;">,</span> <span style="color: #993333; font-weight: bold;">LENGTH</span> <span style="color: #993333; font-weight: bold;">FROM</span> routes</pre></div></div>

<p>This will save me some typing later on.</p>
<p>First, let&#8217;s start with some small route, but one that will show that it actually works &#8211; Duluth-Toronto is great example.</p>
<p>Reason is very simple, We have these 3 routes:</p>

<div class="wp_syntax"><div class="code"><pre class="sql" style="font-family:monospace;">   from_city    │    to_city     │ <span style="color: #993333; font-weight: bold;">LENGTH</span>
────────────────┼────────────────┼────────
 Duluth         │ Sault St Marie │      <span style="color: #cc66cc;">3</span>
 Sault St Marie │ Toronto        │      <span style="color: #cc66cc;">2</span>
 Duluth         │ Toronto        │      <span style="color: #cc66cc;">6</span>
<span style="color: #66cc66;">&#40;</span><span style="color: #cc66cc;">3</span> <span style="color: #993333; font-weight: bold;">ROWS</span><span style="color: #66cc66;">&#41;</span></pre></div></div>

<p>There is a direct connection (length 6), but it&#8217;s actually cheaper to go via Sault St Marie, with total length of 5!</p>
<p><em>Here is a pause, of ~ 1 hour when I tried to write a query to solve my problem. And I failed. Kind of.</em></p>
<p>Query that would return the data is relatively simple:</p>

```sql
WITH RECURSIVE
    multiroutes AS (
        SELECT
            from_city,
            to_city,
            ARRAY[ from_city, to_city ] AS full_route,
            LENGTH AS total_length
        FROM
            all_routes
        WHERE
            from_city = 'Duluth'
        UNION ALL
        SELECT
            m.from_city,
            n.to_city,
            m.full_route || n.to_city,
            m.total_length + n.LENGTH
        FROM
            multiroutes m
            JOIN all_routes n ON m.to_city = n.from_city
        WHERE
            n.to_city <> ALL( m.full_route )
    )
SELECT *
FROM multiroutes
WHERE to_city = 'Toronto'
ORDER BY total_length DESC LIMIT 1;
```
<p>But the problem is &#8211; it&#8217;s extremely slow. And uses a lot of resources, which made OOM killer in my desktop to kill it (yes, stupid OOM killer).</p>
<p>I tried to implement simple pruning of searched paths if they are longer than current shortest on given route, but I couldn&#8217;t find a way to do it &#8211; it seems to require subselect, and subselects referring to recursive queries, are not allowed within the recursive query itself.</p>
<p><em>(I think that perhaps RhodiumToad (on irc) can do it in a single query, but I&#8217;m far away from his level of skills, so I had to pass)</em></p>
<p>Does that mean it can&#8217;t be done in database? No.</p>
<p>Luckily, we have functions. And functions can be rather smart.</p>
<p>To make the function simpler to use and write, I defined a type:</p>

<div class="wp_syntax"><div class="code"><pre class="sql" style="font-family:monospace;"><span style="color: #993333; font-weight: bold;">CREATE</span> <span style="color: #993333; font-weight: bold;">TYPE</span> route_dsc <span style="color: #993333; font-weight: bold;">AS</span> <span style="color: #66cc66;">&#40;</span>
    from_city     TEXT<span style="color: #66cc66;">,</span>
    to_city       TEXT<span style="color: #66cc66;">,</span>
    full_route    TEXT<span style="color: #66cc66;">&#91;</span><span style="color: #66cc66;">&#93;</span><span style="color: #66cc66;">,</span>
    total_length  INT4
<span style="color: #66cc66;">&#41;</span>;</pre></div></div>

<p>This is a quite easy way to encapsulate all information about a single route as somewhat scalar value.</p>
<p>Now, I can write the function:</p>

```sql
CREATE OR REPLACE FUNCTION
    getshortestroute( pfrom TEXT, pto TEXT )
    RETURNS SETOF routedsc AS
$$
DECLARE
    sanitycount   INT4;
    finalroutes   routedsc[];
    currentroutes routedsc[];
    r              routedsc;
BEGIN
    SELECT COUNT(*) INTO sanitycount
        FROM cities
        WHERE city IN (pfrom, pto);
    IF sanitycount <> 2 THEN
        raise exception 'These are NOT two, distinct, correct city names.';
    END IF;
 
    currentroutes := array(
        SELECT ROW(fromcity, tocity, ARRAY[fromcity, tocity], LENGTH)
        FROM allroutes
        WHERE fromcity = pfrom
    );
    finalroutes := currentroutes;
 
    LOOP
        currentroutes := array(
            SELECT ROW(
                c.fromcity,
                a.tocity,
                c.fullroute || a.tocity,
                c.totallength + a.LENGTH)
            FROM
                unnest( currentroutes ) AS c
                JOIN allroutes a ON c.tocity = a.fromcity
            WHERE
                a.tocity <> ALL( c.fullroute )
                AND
                c.totallength + a.LENGTH <= least(
                    COALESCE(
                        (
                            SELECT MIN(l.totallength)
                            FROM unnest( finalroutes ) AS l
                            WHERE ( l.fromcity, l.tocity ) = (c.fromcity, pto)
                        ),
                        c.totallength + a.LENGTH
                    ),
                    COALESCE(
                        (
                            SELECT MIN(l.totallength)
                            FROM unnest( finalroutes ) AS l
                            WHERE ( l.fromcity, l.tocity ) = (c.fromcity, a.tocity)
                        ),
                        c.totallength + a.LENGTH
                    )
                )
        );
        EXIT WHEN currentroutes = '{}';
        finalroutes := finalroutes || currentroutes;
    END LOOP;
    RETURN query
        WITH rr AS (
            SELECT
                fromcity,
                tocity,
                fullroute,
                totallength,
                denserank()
                    OVER (partition BY fromcity, tocity ORDER BY totallength) AS rank
            FROM unnest( finalroutes )
            WHERE fromcity = pfrom AND tocity = pto
        )
        SELECT fromcity, tocity, fullroute, total_length FROM rr WHERE rank = 1;
    RETURN;
END;
```


<p>Looks huge, but in fact it&#8217;s only because there are many queries inside. So, let&#8217;s see what the function does:</p>
<ul>
<li>lines 1-4 &#8211; standard preamble with function name, 2 arguments (cities we want to connect), and information that we will be returning set of records based on the type I just defined. In here you might wonder &#8211; why set of? We want just the shortest route. Yes, that&#8217;s correct but it&#8217;s perfectly possible (and very common) that there are many rows with the same, minimal length. So, instead of picking one randomly &#8211; I will return them all.</li>
<li>lines 6-9 &#8211; variable declarations, not really interesting</li>
<li>lines 11-16 &#8211; sanity check. Simple verification that both given names are city names, and that they are different.</li>
<li>lines 18-22 &#8211; I build current_routes based on all routes coming from source city. For example, If I&#8217;d call the function to find me route from Duluth to Toronto, the array would get these rows:

<div class="wp_syntax"><div class="code"><pre class="sql" style="font-family:monospace;">$ <span style="color: #993333; font-weight: bold;">SELECT</span> from_city<span style="color: #66cc66;">,</span> to_city<span style="color: #66cc66;">,</span> ARRAY<span style="color: #66cc66;">&#91;</span>from_city<span style="color: #66cc66;">,</span> to_city<span style="color: #66cc66;">&#93;</span><span style="color: #66cc66;">,</span> <span style="color: #993333; font-weight: bold;">LENGTH</span>
<span style="color: #993333; font-weight: bold;">FROM</span> all_routes
<span style="color: #993333; font-weight: bold;">WHERE</span> from_city <span style="color: #66cc66;">=</span> <span style="color: #ff0000;">'Duluth'</span>;
 from_city │    to_city     │           array           │ <span style="color: #993333; font-weight: bold;">LENGTH</span>
───────────┼────────────────┼───────────────────────────┼────────
 Duluth    │ Helena         │ <span style="color: #66cc66;">&#123;</span>Duluth<span style="color: #66cc66;">,</span>Helena<span style="color: #66cc66;">&#125;</span>           │      <span style="color: #cc66cc;">6</span>
 Duluth    │ Winnipeg       │ <span style="color: #66cc66;">&#123;</span>Duluth<span style="color: #66cc66;">,</span>Winnipeg<span style="color: #66cc66;">&#125;</span>         │      <span style="color: #cc66cc;">4</span>
 Duluth    │ Sault St Marie │ <span style="color: #66cc66;">&#123;</span>Duluth<span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Sault St Marie&quot;</span><span style="color: #66cc66;">&#125;</span> │      <span style="color: #cc66cc;">3</span>
 Duluth    │ Toronto        │ <span style="color: #66cc66;">&#123;</span>Duluth<span style="color: #66cc66;">,</span>Toronto<span style="color: #66cc66;">&#125;</span>          │      <span style="color: #cc66cc;">6</span>
 Duluth    │ Omaha          │ <span style="color: #66cc66;">&#123;</span>Duluth<span style="color: #66cc66;">,</span>Omaha<span style="color: #66cc66;">&#125;</span>            │      <span style="color: #cc66cc;">2</span>
 Duluth    │ Chicago        │ <span style="color: #66cc66;">&#123;</span>Duluth<span style="color: #66cc66;">,</span>Chicago<span style="color: #66cc66;">&#125;</span>          │      <span style="color: #cc66cc;">3</span>
<span style="color: #66cc66;">&#40;</span><span style="color: #cc66cc;">6</span> <span style="color: #993333; font-weight: bold;">ROWS</span><span style="color: #66cc66;">&#41;</span></pre></div></div>

</li>
<li>line 23 &#8211; I copy current_routes to &#8220;final_routes&#8221;. current_routes contains only routes that the loop below has to work on, but final routes &#8211; is an array of all routes that will be used for finding final solution</li>
<li>lines 25-59 &#8211; basically infinite loop (of course with proper exit condition), which recursively finds routes:
<ul>
<li>lines 26-56 &#8211; core of the function. This query builds new list of routes, based on what&#8217;s in current_routes, with following criteria:
<ul>
<li>new route must be from a city that is at the end of some route in &#8220;current_routes&#8221; (i.e. it&#8217;s next segment for multi-city route</li>
<li>added (to route) city cannot be already in full_route (there is no point in revisiting cities when we&#8217;re looking for shortest path</li>
<li>new total length of route (i.e. some route from current_routes + new segment) has to be shorter (or the same) as existing shortest path between these two cities. By &#8220;these&#8221; I mean original &#8220;from&#8221; city, and newly added &#8220;to&#8221; city. So, if we already have a route between cities &#8220;a&#8221; and &#8220;b&#8221; that is &#8220;10&#8243; long, there is no point in adding new route that is &#8220;20&#8243; long.</li>
<li>similar condition as above, but checking against already found <em>requested</em> route &#8211; i.e. route between cities user requested in passing arguments</li>
<li>above two criteria make sense only if there are matching routes already in final_routes &#8211; hence the need for coalesce()</li>
</ul>
<p>            All such routes are stored in current_routes for future checking</li>
<li>line 57 &#8211; if the query above didn&#8217;t return any routes &#8211; we&#8217;re done, can exit the loop</li>
<li>line 58 &#8211; if there are some routes &#8211; add them to final_routes, and repeat the loop</li>
</ul>
</li>
<li>lines 60-72 &#8211; return of the important data. I take all the routes in final_routes, from there, pick only the ones that match from_city/to_city with parameters given on function call, and then I use dense_rank() to find all records that have minimal total_length. All these records will get returned.</li>
</ul>
<p>If that&#8217;s complex, let me show you an example. What is stored, in which variable, at which step, when finding the route from Duluth to Toronto.</p>
<ul>
<li>after line 23 in function, both current_routes and final_routes contain:<br />
<table class="normal">
<thead>
<tr>
<th>from_city</th>
<th>to_city</th>
<th>total_length</th>
<th>full_route</th>
</tr>
</thead>
<tbody>
<tr>
<td>Duluth</td>
<td>Helena</td>
<td>6</td>
<td>{Duluth,Helena}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Winnipeg</td>
<td>4</td>
<td>{Duluth,Winnipeg}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Sault St Marie</td>
<td>3</td>
<td>{Duluth,&#8221;Sault St Marie&#8221;}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Toronto</td>
<td>6</td>
<td>{Duluth,Toronto}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Omaha</td>
<td>2</td>
<td>{Duluth,Omaha}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Chicago</td>
<td>3</td>
<td>{Duluth,Chicago}</td>
</tr>
</tbody>
</table>
</li>
<li>First run of the main recursive query &#8211; at line 57 current_routes are:<br />
<table class="normal">
<thead>
<tr>
<th>from_city</th>
<th>to_city</th>
<th>total_length</th>
<th>full_route</th>
</tr>
</thead>
<tbody>
<tr>
<td>Duluth</td>
<td>Toronto</td>
<td>5</td>
<td>{Duluth,&#8221;Sault St Marie&#8221;,Toronto}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Pittsburg</td>
<td>6</td>
<td>{Duluth,Chicago,Pittsburg}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Saint Louis</td>
<td>5</td>
<td>{Duluth,Chicago,&#8221;Saint Louis&#8221;}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Denver</td>
<td>6</td>
<td>{Duluth,Omaha,Denver}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Kansas City</td>
<td>3</td>
<td>{Duluth,Omaha,&#8221;Kansas City&#8221;}</td>
</tr>
</tbody>
</table>
<p>    and since it&#8217;s obviously not empty set &#8211; it continues.<br/><br />
    Please note that it didn&#8217;t (for example) add route Duluth &#8211; Helena &#8211; Seattle (which is correct route, as you can see on the image above). Reason is very simple &#8211; we already found one route Duluth &#8211; Toronto, and its length is 6, so adding new route which is longer than this &#8211; doesn&#8217;t make sense.
    </li>
<li>At line 58 final_routes are set to:<br />
<table class="normal">
<thead>
<tr>
<th>from_city</th>
<th>to_city</th>
<th>total_length</th>
<th>full_route</th>
</tr>
</thead>
<tbody>
<tr>
<td>Duluth</td>
<td>Helena</td>
<td>6</td>
<td>{Duluth,Helena}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Winnipeg</td>
<td>4</td>
<td>{Duluth,Winnipeg}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Sault St Marie</td>
<td>3</td>
<td>{Duluth,&#8221;Sault St Marie&#8221;}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Toronto</td>
<td>6</td>
<td>{Duluth,Toronto}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Omaha</td>
<td>2</td>
<td>{Duluth,Omaha}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Chicago</td>
<td>3</td>
<td>{Duluth,Chicago}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Toronto</td>
<td>5</td>
<td>{Duluth,&#8221;Sault St Marie&#8221;,Toronto}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Pittsburg</td>
<td>6</td>
<td>{Duluth,Chicago,Pittsburg}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Saint Louis</td>
<td>5</td>
<td>{Duluth,Chicago,&#8221;Saint Louis&#8221;}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Denver</td>
<td>6</td>
<td>{Duluth,Omaha,Denver}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Kansas City</td>
<td>3</td>
<td>{Duluth,Omaha,&#8221;Kansas City&#8221;}</td>
</tr>
</tbody>
</table>
<p>    Which is simply previous final_routes with added new 5.
    </li>
<li>After next iteration of the loop, based on 5-element current_routes, we got only two new routes:<br />
<table class="normal">
<thead>
<tr>
<th>from_city</th>
<th>to_city</th>
<th>total_length</th>
<th>full_route</th>
</tr>
</thead>
<tbody>
<tr>
<td>Duluth</td>
<td>Oklahoma City</td>
<td>5</td>
<td>{Duluth,Omaha,&#8221;Kansas City&#8221;,&#8221;Oklahoma City&#8221;}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Saint Louis</td>
<td>5</td>
<td>{Duluth,Omaha,&#8221;Kansas City&#8221;,&#8221;Saint Louis&#8221;}</td>
</tr>
</tbody>
</table>
<p>    And of course they got added to final_routes.
    </li>
<li>another iteration of the loop, based on current_routes with just two elements &#8211; didn&#8217;t return any rows. There simply is no way to extend routes &#8220;Duluth-Omaha-Kansas City&#8221; or &#8220;Duluth-Omaha-Saint Louis&#8221; in a way that wouldn&#8217;t extend already found route &#8220;Duluth-Sault St Marie-Toronto&#8221; with length 5.</li>
<li>Since this iteration of loop didn&#8217;t find anything, loop exits, and the final_routes contains:<br />
<table class="normal">
<thead>
<tr>
<th>from_city</th>
<th>to_city</th>
<th>total_length</th>
<th>full_route</th>
</tr>
</thead>
<tbody>
<tr>
<td>Duluth</td>
<td>Helena</td>
<td>6</td>
<td>{Duluth,Helena}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Winnipeg</td>
<td>4</td>
<td>{Duluth,Winnipeg}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Sault St Marie</td>
<td>3</td>
<td>{Duluth,&#8221;Sault St Marie&#8221;}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Toronto</td>
<td>6</td>
<td>{Duluth,Toronto}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Omaha</td>
<td>2</td>
<td>{Duluth,Omaha}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Chicago</td>
<td>3</td>
<td>{Duluth,Chicago}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Toronto</td>
<td>5</td>
<td>{Duluth,&#8221;Sault St Marie&#8221;,Toronto}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Pittsburg</td>
<td>6</td>
<td>{Duluth,Chicago,Pittsburg}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Saint Louis</td>
<td>5</td>
<td>{Duluth,Chicago,&#8221;Saint Louis&#8221;}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Denver</td>
<td>6</td>
<td>{Duluth,Omaha,Denver}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Kansas City</td>
<td>3</td>
<td>{Duluth,Omaha,&#8221;Kansas City&#8221;}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Oklahoma City</td>
<td>5</td>
<td>{Duluth,Omaha,&#8221;Kansas City&#8221;,&#8221;Oklahoma City&#8221;}</td>
</tr>
<tr>
<td>Duluth</td>
<td>Saint Louis</td>
<td>5</td>
<td>{Duluth,Omaha,&#8221;Kansas City&#8221;,&#8221;Saint Louis&#8221;}</td>
</tr>
</tbody>
</table>
</li>
</ul>
<p>Based on the final_routes above, query in lines 61-72 calculates correct answer, and shows it.</p>
<p>OK. So it works. But how slow it is?</p>
<p>First, let&#8217;s start with very simple example &#8211; Atlanta &#8211; Nashville. These two cities are connected using a single one-element route. Call to function:</p>

<div class="wp_syntax"><div class="code"><pre class="sql" style="font-family:monospace;">$ <span style="color: #993333; font-weight: bold;">SELECT</span> <span style="color: #66cc66;">*</span> <span style="color: #993333; font-weight: bold;">FROM</span> get_shortest_route<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'Atlanta'</span><span style="color: #66cc66;">,</span> <span style="color: #ff0000;">'Nashville'</span><span style="color: #66cc66;">&#41;</span>;
 from_city │  to_city  │     full_route      │ total_length
───────────┼───────────┼─────────────────────┼──────────────
 Atlanta   │ Nashville │ <span style="color: #66cc66;">&#123;</span>Atlanta<span style="color: #66cc66;">,</span>Nashville<span style="color: #66cc66;">&#125;</span> │            <span style="color: #cc66cc;">1</span>
<span style="color: #66cc66;">&#40;</span><span style="color: #cc66cc;">1</span> <span style="color: #993333; font-weight: bold;">ROW</span><span style="color: #66cc66;">&#41;</span>
&nbsp;
<span style="color: #993333; font-weight: bold;">TIME</span>: <span style="color: #cc66cc;">1.045</span> ms</pre></div></div>

<p>What about the Duluth-Toronto?</p>

<div class="wp_syntax"><div class="code"><pre class="sql" style="font-family:monospace;">$ <span style="color: #993333; font-weight: bold;">SELECT</span> <span style="color: #66cc66;">*</span> <span style="color: #993333; font-weight: bold;">FROM</span> get_shortest_route<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'Duluth'</span><span style="color: #66cc66;">,</span> <span style="color: #ff0000;">'Toronto'</span><span style="color: #66cc66;">&#41;</span>;
 from_city │ to_city │            full_route             │ total_length
───────────┼─────────┼───────────────────────────────────┼──────────────
 Duluth    │ Toronto │ <span style="color: #66cc66;">&#123;</span>Duluth<span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Sault St Marie&quot;</span><span style="color: #66cc66;">,</span>Toronto<span style="color: #66cc66;">&#125;</span> │            <span style="color: #cc66cc;">5</span>
<span style="color: #66cc66;">&#40;</span><span style="color: #cc66cc;">1</span> <span style="color: #993333; font-weight: bold;">ROW</span><span style="color: #66cc66;">&#41;</span>
&nbsp;
<span style="color: #993333; font-weight: bold;">TIME</span>: <span style="color: #cc66cc;">2.239</span> ms</pre></div></div>

<p>Something longer perhaps:</p>

<div class="wp_syntax"><div class="code"><pre class="sql" style="font-family:monospace;">$ <span style="color: #993333; font-weight: bold;">SELECT</span> <span style="color: #66cc66;">*</span> <span style="color: #993333; font-weight: bold;">FROM</span> get_shortest_route<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'Duluth'</span><span style="color: #66cc66;">,</span> <span style="color: #ff0000;">'Los Angeles'</span><span style="color: #66cc66;">&#41;</span>;
 from_city │   to_city   │                                  full_route                                   │ total_length
───────────┼─────────────┼───────────────────────────────────────────────────────────────────────────────┼──────────────
 Duluth    │ Los Angeles │ <span style="color: #66cc66;">&#123;</span>Duluth<span style="color: #66cc66;">,</span>Omaha<span style="color: #66cc66;">,</span>Denver<span style="color: #66cc66;">,</span>Phoenix<span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Los Angeles&quot;</span><span style="color: #66cc66;">&#125;</span>                                   │           <span style="color: #cc66cc;">14</span>
 Duluth    │ Los Angeles │ <span style="color: #66cc66;">&#123;</span>Duluth<span style="color: #66cc66;">,</span>Omaha<span style="color: #66cc66;">,</span>Denver<span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Santa Fe&quot;</span><span style="color: #66cc66;">,</span>Phoenix<span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Los Angeles&quot;</span><span style="color: #66cc66;">&#125;</span>                        │           <span style="color: #cc66cc;">14</span>
 Duluth    │ Los Angeles │ <span style="color: #66cc66;">&#123;</span>Duluth<span style="color: #66cc66;">,</span>Omaha<span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Kansas City&quot;</span><span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Oklahoma City&quot;</span><span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Santa Fe&quot;</span><span style="color: #66cc66;">,</span>Phoenix<span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Los Angeles&quot;</span><span style="color: #66cc66;">&#125;</span> │           <span style="color: #cc66cc;">14</span>
 Duluth    │ Los Angeles │ <span style="color: #66cc66;">&#123;</span>Duluth<span style="color: #66cc66;">,</span>Helena<span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Salt Lake City&quot;</span><span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Las Vegas&quot;</span><span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Los Angeles&quot;</span><span style="color: #66cc66;">&#125;</span>                    │           <span style="color: #cc66cc;">14</span>
 Duluth    │ Los Angeles │ <span style="color: #66cc66;">&#123;</span>Duluth<span style="color: #66cc66;">,</span>Omaha<span style="color: #66cc66;">,</span>Denver<span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Salt Lake City&quot;</span><span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Las Vegas&quot;</span><span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Los Angeles&quot;</span><span style="color: #66cc66;">&#125;</span>              │           <span style="color: #cc66cc;">14</span>
<span style="color: #66cc66;">&#40;</span><span style="color: #cc66cc;">5</span> <span style="color: #993333; font-weight: bold;">ROWS</span><span style="color: #66cc66;">&#41;</span></pre></div></div>

<p>And how about a cross country?</p>

<div class="wp_syntax"><div class="code"><pre class="sql" style="font-family:monospace;">$ <span style="color: #993333; font-weight: bold;">SELECT</span> <span style="color: #66cc66;">*</span> <span style="color: #993333; font-weight: bold;">FROM</span> get_shortest_route<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'Vancouver'</span><span style="color: #66cc66;">,</span> <span style="color: #ff0000;">'Miami'</span><span style="color: #66cc66;">&#41;</span>;
 from_city │ to_city │                                      full_route                                      │ total_length
───────────┼─────────┼──────────────────────────────────────────────────────────────────────────────────────┼──────────────
 Vancouver │ Miami   │ <span style="color: #66cc66;">&#123;</span>Vancouver<span style="color: #66cc66;">,</span>Calgary<span style="color: #66cc66;">,</span>Helena<span style="color: #66cc66;">,</span>Omaha<span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Kansas City&quot;</span><span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Saint Louis&quot;</span><span style="color: #66cc66;">,</span>Nashville<span style="color: #66cc66;">,</span>Atlanta<span style="color: #66cc66;">,</span>Miami<span style="color: #66cc66;">&#125;</span> │           <span style="color: #cc66cc;">23</span>
 Vancouver │ Miami   │ <span style="color: #66cc66;">&#123;</span>Vancouver<span style="color: #66cc66;">,</span>Seattle<span style="color: #66cc66;">,</span>Helena<span style="color: #66cc66;">,</span>Omaha<span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Kansas City&quot;</span><span style="color: #66cc66;">,</span><span style="color: #ff0000;">&quot;Saint Louis&quot;</span><span style="color: #66cc66;">,</span>Nashville<span style="color: #66cc66;">,</span>Atlanta<span style="color: #66cc66;">,</span>Miami<span style="color: #66cc66;">&#125;</span> │           <span style="color: #cc66cc;">23</span>
<span style="color: #66cc66;">&#40;</span><span style="color: #cc66cc;">2</span> <span style="color: #993333; font-weight: bold;">ROWS</span><span style="color: #66cc66;">&#41;</span>
&nbsp;
<span style="color: #993333; font-weight: bold;">TIME</span>: <span style="color: #cc66cc;">62.507</span> ms</pre></div></div>

<p>The longer the road the more time it takes to find it. Which is pretty understandable.</p>
<p>So, to wrap it. It can be done in database. It is not as slow as I expected. <em>I</em> wasn&#8217;t able to find a way to do it without functions, but it might be possible for someone smarter than me.</p>
<p>And I still don&#8217;t think it&#8217;s a good idea to put this logic in database.</p>


<h2>Mark Guyatt's approach 1</h2>
```sql
WITH RECURSIVE
findpath AS (
  SELECT 'Vancouver'::text AS from_city, 'Miami'::text AS to_city
),
multiroutes AS (
  SELECT
    m.from_city,
    m.to_city,
    ARRAY[m.from_city, m.to_city] AS full_route,
    LENGTH AS total_length,
    m.to_city = f.to_city AS solved,
    MIN(CASE WHEN m.to_city = f.to_city THEN LENGTH ELSE NULL END) OVER () AS min_solve
  FROM findpath f
  JOIN all_routes m USING (from_city)
  UNION ALL
  SELECT
    m.from_city,
    n.to_city,
    m.full_route || n.to_city,
    m.total_length + n.LENGTH,
    n.to_city = f.to_city AS solved,
    MIN(CASE WHEN n.to_city = f.to_city THEN m.total_length + n.LENGTH ELSE NULL END) OVER () AS min_solve
  FROM findpath f
  JOIN multiroutes m USING (from_city)
  JOIN all_routes n ON m.to_city = n.from_city AND NOT m.solved AND n.to_city <> ALL( m.full_route) AND (m.min_solve IS NULL OR m.min_solve IS NOT NULL AND m.total_length + n.LENGTH <= m.min_solve)
),
solution AS (
  SELECT
    m.from_city,
    m.to_city,
    m.full_route,
    m.total_length,
    MIN(m.total_length) OVER () AS best_length
  FROM multiroutes m JOIN findpath f USING (to_city)
)
SELECT * FROM solution WHERE total_length = best_length;
```

<h2>Mark Guyatt's approach 2</h2>
```sql
WITH RECURSIVE
findpath AS (
    SELECT 'Vancouver'::text AS from_city, 'Miami'::text AS to_city
),
multiroutes AS (
    SELECT
        m.from_city,
        m.to_city,
        ARRAY[m.from_city, m.to_city] AS full_route,
        LENGTH AS total_length,
        m.to_city = f.to_city AS solved,
        MIN(CASE WHEN m.to_city = f.to_city THEN LENGTH ELSE NULL END) OVER () AS min_solve,
        LENGTH AS best_to_length
    FROM findpath f
        JOIN all_routes m USING (from_city)
    UNION ALL
    SELECT
        m.from_city,
        n.to_city,
        m.full_route || n.to_city,
        m.total_length + n.LENGTH,
        n.to_city = f.to_city AS solved,
        MIN(CASE WHEN n.to_city = f.to_city THEN m.total_length + n.LENGTH ELSE NULL END) OVER () AS min_solve,
        MIN(m.total_length + n.LENGTH) OVER (PARTITION BY n.to_city) AS best_to_length
    FROM findpath f
        JOIN multiroutes m USING (from_city)
        JOIN all_routes n ON m.to_city = n.from_city AND n.to_city <> ALL( m.full_route) AND (m.min_solve IS NULL OR m.min_solve IS NOT NULL AND m.total_length + n.LENGTH <= m.min_solve)
    WHERE NOT m.solved
        AND m.total_length = m.best_to_length
),
solution AS (
    SELECT
        m.from_city,
        m.to_city,
        m.full_route,
        m.total_length,
        MIN(m.total_length) OVER () AS best_length
    FROM multiroutes m JOIN findpath f USING (to_city)
)
SELECT * FROM solution WHERE total_length = best_length;
```

<h2>Depesz makes an update to Mark's query</h2>
```sql
WITH RECURSIVE
findpath AS (
    SELECT 'Vancouver'::text AS from_city, 'Miami'::text AS to_city
),
multiroutes AS (
    SELECT
        m.from_city,
        m.to_city,
        ARRAY[m.from_city, m.to_city] AS full_route,
        LENGTH AS total_length,
        m.to_city = f.to_city AS solved,
        MIN(CASE WHEN m.to_city = f.to_city THEN LENGTH ELSE NULL END) OVER () AS min_solve,
        LENGTH AS best_to_length
    FROM findpath f
        JOIN all_routes m USING (from_city)
    UNION ALL
    SELECT
        m.from_city,
        n.to_city,
        m.full_route || n.to_city,
        m.total_length + n.LENGTH,
        n.to_city = f.to_city AS solved,
        least(
            m.min_solve,
            MIN(CASE WHEN n.to_city = f.to_city THEN m.total_length + n.LENGTH ELSE NULL END) OVER ()
        ) AS min_solve,
        MIN(m.total_length + n.LENGTH) OVER (PARTITION BY n.to_city) AS best_to_length
    FROM findpath f
        JOIN multiroutes m USING (from_city)
        JOIN all_routes n ON m.to_city = n.from_city AND n.to_city <> ALL( m.full_route) AND (m.min_solve IS NULL OR m.min_solve IS NOT NULL AND m.total_length + n.LENGTH <= m.min_solve)
    WHERE NOT m.solved
        AND m.total_length = m.best_to_length
),
solution AS (
    SELECT
        m.from_city,
        m.to_city,
        m.full_route,
        m.total_length,
        MIN(m.total_length) OVER () AS best_length
    FROM multiroutes m JOIN findpath f USING (to_city)
)
SELECT * FROM solution WHERE total_length = best_length;
```

- - -


