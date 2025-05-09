-- Creating Views for Use in Tableau 

-- GLOBAL ANALYSIS
-- 1. Global Case Fatality Rate Over Time
-- Purpose: Tracks the percentage of global reported cases that resulted in death, by date.
-- Use in Tableau: Line chart showing how fatality rate evolved globally as the pandemic progressed, using the same line graph as vaccination rollout trends to compare.
CREATE VIEW GlobalCaseFatalityRateOverTime_VIZ AS
SELECT date, 
       SUM(total_deaths) AS Deaths, 
       SUM(total_cases) AS Cases, 
       SUM(total_deaths) / SUM(total_cases) * 100 AS Case_Fatality_Rate_Percent
FROM coviddeaths
WHERE continent IS NOT NULL
  AND total_cases IS NOT NULL
  AND total_deaths IS NOT NULL
  AND date > '2020-01-11'
GROUP BY 1
ORDER BY 1;

-- 2. Global Vaccination Progress Over Time
-- Purpose: Shows total number of daily and cumulative vaccinations administered globally.
-- Use in Tableau: Line chart with case fatality rate over time showing potential relationship.
CREATE VIEW TotalVaccinesGivenOverTime_VIZ AS
SELECT date, Daily_Vaccinations, 
       SUM(Daily_Vaccinations) OVER (ORDER BY date) AS Running_Total_Vaccinations
FROM (
    SELECT 
        date,
        SUM(IFNULL(new_vaccinations, 0)) AS Daily_Vaccinations
    FROM covidvaccinations
    WHERE continent IS NOT NULL
      AND date > '2020-01-11'
    GROUP BY date
) AS daily;

-- CONTINENT ANALYSIS
-- 3. Total Deaths by Continent
-- Purpose: Ranks continents by total reported deaths for macro-level comparison.
-- Use in Tableau: Bar chart comparing death tolls across continents, in the same dashboard to compare to the case fatality rates of each continent.
CREATE VIEW TotalReportedDeathsByContinent_VIZ AS
SELECT continent, MAX(total_deaths) AS Total_Reported_Deaths
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;

-- 4. Case Fatality Rate per Continent
-- Purpose: Calculates the percentage of reported cases that resulted in death per continent.
-- Use in Tableau: Comparative analysis of health system impact by continent, comparing to total reported deaths.
CREATE VIEW CaseFatalityRateByContinent_VIZ AS
SELECT continent, 
       MAX(total_deaths) AS Total_Reported_Deaths, 
       MAX(total_cases) AS Total_Reported_Cases, 
       MAX(total_deaths) / MAX(total_cases) * 100 AS Case_Fatality_Rate_Percent
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Case_Fatality_Rate_Percent DESC;

-- COUNTRY ANALYSIS
-- 5. Crude Mortality Rate per Country
-- Purpose: Measures what percentage of a country’s population died from COVID (overall mortality).
-- Use in Tableau: Map to identify the countries with highest crude mortality rates.
CREATE VIEW CrudeMortalityRateByCountry_VIZ AS
SELECT country, 
       MAX(total_deaths) AS Total_Deaths, 
       MAX(population) AS Population, 
       MAX(total_deaths) / MAX(population) * 100 AS Crude_Mortality_Rate_Percent
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY 1
ORDER BY Crude_Mortality_Rate_Percent DESC;

-- 6. Case Count Compared to Population
-- Purpose: Determines what percentage of the population was reported as infected in each country.
-- Use in Tableau: Geographic representation of reported cases compared to the population of each country.
CREATE VIEW CaseCountComparedToPopulation_VIZ AS
SELECT country, 
       MAX(total_cases) AS Total_Cases, 
       MAX(population) AS Population, 
       MAX(total_cases) / MAX(population) * 100 AS Cases_To_Population_Percent
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY country
ORDER BY Cases_To_Population_Percent DESC;

-- 7. Case Fatality Rate per Country
-- Purpose: Calculates the death rate per country based on total reported cases and deaths.
-- Use in Tableau: Create a treemap with a filter to be able to compare the case fatality rate between selected countries. 
CREATE VIEW CaseFatalityRateByCountry_VIZ AS
SELECT country, 
       MAX(total_deaths) AS Total_Reported_Deaths, 
       MAX(total_cases) AS Total_Reported_Cases, 
       MAX(total_deaths) / MAX(total_cases) * 100 AS Case_Fatality_Rate_Percent
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY country
ORDER BY Case_Fatality_Rate_Percent DESC;