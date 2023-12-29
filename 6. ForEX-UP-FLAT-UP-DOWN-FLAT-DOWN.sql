------------------------------------------------------------
-- UP-FLAT-UP--DOWN-FLAT-DOWN
------------------------------------------------------------
SELECT symbol, 
                "Date",
                match_num,
                var_match, 
                ADJUSTED,
                ADJUSTED_diff
FROM  (SELECT  symbol, 
                "Date",
                ADJUSTED,
                ADJUSTED - LAG(ADJUSTED, 1) OVER (PARTITION BY symbol ORDER BY  "Date") AS ADJUSTED_diff
FROM ForEX
WHERE (symbol = 'GBPUSD=X' AND 
                                         EXTRACT(YEAR FROM "Date") = 2020 AND
                                         EXTRACT(MONTH FROM "Date")  = 4
                                       )) 
 MATCH_RECOGNIZE (
 PARTITION BY symbol
 ORDER BY "Date"
 MEASURES STRT."Date" AS "start_Date",
 FINAL LAST(UPFLAT."Date") AS "up_flat_Date",
 FINAL LAST(DOWNFLAT."Date") AS "down_flat_Date",
 FINAL LAST(DOWN."Date") AS "bottom_Date",
 FINAL LAST(UP."Date") AS "end_Date",
 MATCH_NUMBER() AS match_num,
 CLASSIFIER() AS var_match
 ALL ROWS PER MATCH
 AFTER MATCH SKIP TO LAST UP
 PATTERN (STRT UP+ UPFLAT+ UP+ DOWN+ DOWNFLAT+ DOWN+)
 DEFINE
         UPFLAT AS UPFLAT.ADJUSTED_diff BETWEEN 0 AND  0.0008,
         DOWNFLAT AS DOWNFLAT.ADJUSTED_diff BETWEEN -0.0008 AND 0,
         DOWN AS DOWN.ADJUSTED < PREV(DOWN.ADJUSTED),
         UP AS UP.ADJUSTED > PREV(UP.ADJUSTED)
 ) MR
ORDER BY MR.symbol, MR.match_num, MR."Date";