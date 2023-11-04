--Created a database and I call it "VehicleAcc".
--Next, I imported the CSV files to this database as tables.
--Now, I am going to answer to some questions with SQL to conduct exploratory data analysis.
------------------------------------------------------------------------------------
--Question 1: How many accidents have occurred in urban areas versus rural areas?
SELECT
	[Area],
	COUNT([AccidentIndex]) AS 'Total Accidents'
FROM
	[dbo].[accident]
GROUP BY
	[Area];

--Question 2: Which day of the week has the highest number of accidents?
SELECT
	[Day],
	COUNT([AccidentIndex]) AS 'Total Accidents'
FROM
	[dbo].[accident]
GROUP BY
	[Day]
ORDER BY
	'Total Accidents' DESC;

--Question 3: What is the average age of vehicles involved in accidents based on their type?
SELECT
	[VehicleType],
	COUNT([AccidentIndex]) AS 'Total Accidents',
	AVG([AgeVehicle]) AS 'Average Year'
FROM
	[dbo].[vehicle]
WHERE
	[AgeVehicle] IS NOT NULL
GROUP BY
	[VehicleType]
ORDER BY
	'Total Accidents' DESC;

--Question 4: Can we identify any trends in accidents based on the age of vehicles involved?
SELECT
	AgeGroup,
	COUNT([AccidentIndex]) AS 'Total Accidents',
	AVG([AgeVehicle]) AS 'Average Year'
FROM(
	SELECT
		[AccidentIndex],
		[AgeVehicle],
		CASE
			WHEN [AgeVehicle] BETWEEN 0 AND 5 THEN 'New'
			WHEN [AgeVehicle] BETWEEN 6 AND 10 THEN 'Regular'
			ELSE 'Old'
		END AS 'AgeGroup'
	FROM
		[dbo].[vehicle]
)AS SubQuery
GROUP BY
	AgeGroup

--Question 5: Are there any specific weather conditions that contribute to severe accidents?
DECLARE @Severity varchar(100)
SET @Severity = 'Slight' --Can be Serious/Fatal/Slight
SELECT
	[WeatherConditions],
	COUNT([Severity]) AS 'Total Accident'
FROM
	[dbo].[accident]
WHERE
	[Severity]=@Severity 
GROUP BY
	[WeatherConditions]
ORDER BY
	'Total Accident' DESC;

--Question 6: Do accidents often involve impacts on the left-hand side of vehicles?
SELECT
	[LeftHand],
	COUNT([AccidentIndex]) AS 'Total Accidents'
FROM
	[dbo].[vehicle]
GROUP BY
	[LeftHand]
HAVING
	[LeftHand] IS NOT NULL;

--Question 7: Are there any relationships between journey purposes and the severity of accidents?
SELECT
	V.[JourneyPurpose],
	COUNT(A.[Severity]) AS 'Total Accidents',
	CASE
		WHEN COUNT(A.[Severity]) BETWEEN 0 AND 1000 THEN 'Low'
		WHEN COUNT(A.[Severity]) BETWEEN 1001 AND 3000 THEN 'Moderate'
		ELSE 'High'
	END AS 'Level'
FROM
	[dbo].[accident] A
JOIN
	[dbo].[vehicle] V ON V.[AccidentIndex]=A.[AccidentIndex]
GROUP BY
	V.[JourneyPurpose]
ORDER BY
	'Total Accidents' DESC;

--Question 8: Calculate the average age of vehicles involved in accidents , considering Day light and point of impact:
DECLARE @Impact varchar(100)
DECLARE @Light varchar(100)
SET @Impact = 'Offside'   -- Did not impact,Offside,Front,Back
SET @Light = 'Daylight' --Daylight,Darkness

SELECT
	A.[LightConditions],
	V.[PointImpact],
	AVG([AgeVehicle]) AS 'Average Year'
FROM
	[dbo].[accident] A
JOIN
	[dbo].[vehicle] V ON V.[AccidentIndex]=A.[AccidentIndex]
GROUP BY
	A.[LightConditions],V.[PointImpact]
HAVING
	V.[PointImpact]= @Impact AND A.[LightConditions]= @Light;