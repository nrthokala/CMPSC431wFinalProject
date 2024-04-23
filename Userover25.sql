SELECT U.UserName, U.Age, UH.HealthConditions
	FROM “NeoFitness”.”User” AS U
	JOIN “NeoFitness”.”UserHealth” AS UH ON UH.UserId = U.UserId
	WHERE U.Age > 25;
