SELECT symbol, 
       "Date",
       match_num,
       var_match, 
       ADJUSTED
FROM  (SELECT SYMBOL, "Date", ADJUSTED
                FROM ForEX   WHERE (symbol = 'AUDUSD=X' AND 
                                         EXTRACT(YEAR FROM "Date") = 2015 AND
                                         EXTRACT(MONTH FROM "Date")  = 6
                                       )
                ) 
MATCH_RECOGNIZE (
       PARTITION BY symbol
       ORDER BY "Date"
       MEASURES STRT."Date" AS "start_Date",
                FINAL LAST(UP."Date") AS "up_Date",
                FINAL LAST(UP2."Date") AS "up2_Date",
                FINAL LAST(DOWN."Date") AS "down_Date",
                FINAL LAST(DOWN2."Date") AS "down2_Date",
                MATCH_NUMBER() AS match_num,
                CLASSIFIER() AS var_match
       ALL ROWS PER MATCH
       AFTER MATCH SKIP TO LAST UP
       PATTERN (STRT UP+ DOWN+ UP2+ DOWN+ UP+ DOWN2+)
       DEFINE
             UP AS UP.ADJUSTED > PREV(UP.ADJUSTED),
             DOWN AS DOWN.ADJUSTED < PREV(DOWN.ADJUSTED),
             UP2 AS UP2.ADJUSTED > MAX(UP.ADJUSTED),         
             DOWN2 AS DOWN2.ADJUSTED < MIN(DOWN.ADJUSTED)
) MR
ORDER BY MR.symbol, MR.match_num, MR."Date";