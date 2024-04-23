SELECT EL.UserId, SUM(E.caloriesPerKg * UG.currentWeight) AS CaloriesBurnt, EL.ExerciseLogDate
FROM “NeoFitness”.”ExerciseLog” AS EL
JOIN  “NeoFitness”.”Exercise” AS E ON E.ExerciseId = EL.ExerciseId
JOIN  “NeoFitness”.”UserGoal” AS UG ON UG.UserId = EL.UserId 
WHERE EXTRACT(MONTH FROM EL.ExerciseLogDate) = 4 
AND EXTRACT(YEAR FROM EL.ExerciseLogDate) = 2024 
GROUP BY EL.UserId, EL.ExerciseLogDate;
