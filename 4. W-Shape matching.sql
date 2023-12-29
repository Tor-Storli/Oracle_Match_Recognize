-----------------------------------------------------------------
-- Pattern Match for a W-Shape
----------------------------------------------------------------
SELECT symbol, 
                "date",
                match_num,
                var_match, 
                adjclose, 
                volume, 
                log_return
FROM  (SELECT * FROM Stocks 
            WHERE (symbol = 'AAPL' AND 
                        EXTRACT(YEAR FROM "date") = 2022 AND
                        EXTRACT(MONTH FROM "date") = 2 ))  
MATCH_RECOGNIZE (
 PARTITION BY symbol
 ORDER BY "date"
 MEASURES
 MATCH_NUMBER() AS match_num,
 CLASSIFIER() AS var_match, 
 STRT."date" AS "start_date",
 FINAL LAST(UP."date") AS "end_date"
 ALL ROWS PER MATCH
 AFTER MATCH SKIP TO LAST UP
 PATTERN (STRT DOWN+ UP+ DOWN+ UP+)
 DEFINE
 DOWN AS DOWN.adjclose < PREV(DOWN.adjclose),
 UP AS UP.adjclose > PREV(UP.adjclose)
 ) MR
 ORDER BY MR.symbol, MR.match_num, MR."date";