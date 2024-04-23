# CMPSC431wFinalProject
 Below are the questions on the CLI and their corresponding queries.

Insert data of a new User in the User table. 
I made a call to sql file InsertNewUser.sql from the bash file, passing variable parameters :UserName, :UserAge and :UserAddress entered at the command prompt.
	
INSERT INTO "NeoFitness"."User"  (UserName, Age, Address) 
VALUES (:UserName, :UserAge, :UserAddress);


 Delete a User Health record.
	I made a call to sql file DeleteUserHealth.sql from the bash file, passing variable parameters :UserHealthId as the input value entered at the command prompt.

	DELETE FROM “NeoFitness”.”UserHealth” 
WHERE UserHealthId = :UserHealthId;

Update the UserAddress for a specific User.
I made a call to sql file UpdateUserAddress.sql from the bash file, passing variable parameters :UserName and :UserAddress are the input entered at the command prompt

UPDATE “NeoFitness”.”User” 
SET UserAddress = :UserAddress
WHERE UserName = :UserName;

Select all users with age above 30 yrs. 
	I called this script directly from the bash file

	SELECT * FROM “NeoFitness”.”User”
WHERE Age > 30;


Select total number of connections each user has
	I called this script directly from the bash file

	SELECT U.UserName, COUNT(UC.ConnectedToUserId) AS UserConnections
	FROM “NeoFitness”.”User” AS U
	JOIN “NeoFitness”.”UserConnections” AS UC ON UC.UserId = U.UserId
	GROUP BY U.UserName;

Select all users in the order of their Age starting with the oldest.
I called this script directly from the bash file

SELECT * FROM "NeoFitness"."User" 
ORDER BY Age DESC;

Select User health conditions of all users who are older than 25 years.
	I made a call to sql file Userover25.sql from the bash file

	SELECT U.UserName, U.Age, UH.HealthConditions
	FROM “NeoFitness”.”User” AS U
	JOIN “NeoFitness”.”UserHealth” AS UH ON UH.UserId = U.UserId
	WHERE U.Age > 25;
	
Select the total number of calories burnt by each user for the April month 2024 using grouping.
I made a call to sql file CaloriesBurntUser.sql from the bash file

SELECT EL.UserId, SUM(E.caloriesPerKg * UG.currentWeight) AS CaloriesBurnt, EL.ExerciseLogDate
FROM “NeoFitness”.”ExerciseLog” AS EL
JOIN  “NeoFitness”.”Exercise” AS E ON E.ExerciseId = EL.ExerciseId
JOIN  “NeoFitness”.”UserGoal” AS UG ON UG.UserId = EL.UserId 
WHERE EXTRACT(MONTH FROM EL.ExerciseLogDate) = 4 
AND EXTRACT(YEAR FROM EL.ExerciseLogDate) = 2024 
GROUP BY EL.UserId, EL.ExerciseLogDate;


Select User health conditions of users older than 30 yrs using subquery
	I made a call to sql file HealthConditions.sql from the bash file

	SELECT UserId, HealthConditions
	FROM “NeoFitness”.”UserHealth” 
	WHERE UserId IN (SELECT UserId 
FROM “NeoFitness”.”User”
 WHERE Age > 30);
	

Insert a new Daily tracker log inside a TRANSACTION.
I made a call to sql file Transaction.sql from the bash file

BEGIN;

INSERT INTO "DailyGoalTracker" (UserId, RecipeLogId, WaterLogId, ExerciseLogId, FoodLogId, caloriesConsumed, caloriesBurnt)
SELECT DISTINCT U.UserId, RL.RecipeLogId, WL.WaterLogId, EL.ExerciseLogId, FL.FoodLogId,
COALESCE(F.calories,0) + (COALESCE(R.caloriesPerServing,0) * COALESCE(RL.NumofServings,0)) AS caloriesConsumed,
(E.caloriesPerKg * UG.currentWeight) AS caloriesBurnt
FROM "User" AS U
JOIN "UserGoal" AS UG ON UG.UserId = U.UserId
JOIN "ExerciseLog" AS EL ON EL.UserId = U.UserId
JOIN "Exercise" AS E ON E.ExerciseId = EL.ExerciseId
JOIN "FoodLog" AS FL ON FL.UserId = U.UserId AND FL.FoodLogDate = EL.ExerciseLogDate
JOIN "Food" AS F ON F.FoodId = FL.FoodId
LEFT JOIN "RecipeLog" AS RL ON RL.UserId = U.UserId AND RL.RecipeLogDate = EL.ExerciseLogDate
LEFT JOIN "WaterLog" AS WL ON WL.UserId = U.UserId AND WL.WaterLogDate = EL.ExerciseLogDate
LEFT JOIN "Recipes" AS R ON R.RecipeId = RL.RecipeId;

COMMIT;

	
Use error handling in your script.
I made a call to sql file ErrorHandling.sql from the bash file

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
