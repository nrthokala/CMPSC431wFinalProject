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
