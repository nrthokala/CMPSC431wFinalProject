SET Schema 'NeoFitness';
DO $$
DECLARE
   result int;
BEGIN
  Select count(*) INTO result from "DailyGoalTracker";
  IF result = 0 THEN
     RAISE EXCEPTION 'No data found';
  ELSE
     RAISE NOTICE 'Data Found.';
  END IF;
 EXCEPTION
   WHEN  OTHERS  THEN
    RAISE NOTICE  'Exception occurred';
END;
$$
language plpgsql;
