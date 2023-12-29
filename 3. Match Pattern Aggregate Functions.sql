
-----------------------------------------------------------------
-- Pattern Match with an Aggregate on a Variable
----------------------------------------------------------------
SELECT symbol, 
                "date",
                match_num,
                var_match, 
                up_days, 
                total_days, 
                cnt_days, 
                adjclose_diff
                adjclose, 
                volume, 
                log_return
FROM (SELECT * FROM Stocks 
            WHERE (symbol = '^GSPC' AND 
                        EXTRACT(YEAR FROM "date") = 2021 AND
                        EXTRACT(MONTH FROM "date") = 5 ))    
MATCH_RECOGNIZE (PARTITION BY symbol ORDER BY "date"
 MEASURES
 MATCH_NUMBER() AS match_num,
 CLASSIFIER() AS var_match,
 FINAL COUNT(UP."date") AS up_days,
 FINAL COUNT("date") AS total_days,
 RUNNING COUNT("date") AS cnt_days,
 adjclose - STRT.adjclose AS adjclose_diff
 ALL ROWS PER MATCH
 AFTER MATCH SKIP TO LAST UP
 PATTERN (STRT DOWN+ UP+)
 DEFINE
 DOWN AS DOWN.adjclose < PREV(DOWN.adjclose),
 UP AS UP.adjclose > PREV(UP.adjclose)
 ) MR
ORDER BY MR.symbol, MR.match_num, MR."date";