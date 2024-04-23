SELECT UserId, HealthConditions
	FROM “NeoFitness”.”UserHealth” 
	WHERE UserId IN (SELECT UserId 
FROM “NeoFitness”.”User”
 WHERE Age > 30);
