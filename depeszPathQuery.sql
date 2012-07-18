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