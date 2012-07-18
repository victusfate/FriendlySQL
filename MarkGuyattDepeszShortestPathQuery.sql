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