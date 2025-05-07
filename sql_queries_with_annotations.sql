-- Total Cases vs Total Deaths in France
-- Goal: Understand how deadly COVID has been in France by calculating the death rate.
SELECT country, MAX(total_cases) AS Total_Cases, MAX(total_deaths) AS Total_Deaths, 
		(MAX(total_deaths)/MAX(total_cases) * 100) AS PercentageDeaths
FROM coviddeaths
WHERE country = 'France'
GROUP BY 1 
LIMIT 1;

-- Total Cases vs Population in France Over Time
-- Goal: Measure infection spread over time by calculating what percentage of the population was infected.
SELECT country, date, total_cases, population, 
       (total_cases/population * 100) AS PercentagePopInfected
FROM coviddeaths
WHERE country = 'France'
ORDER BY 5 ASC;

-- Countries with the Highest Cases per Population
-- Goal: Identify countries where COVID spread most widely, relative to population size.
SELECT country, MAX(total_cases) AS Total_Cases, MAX(population) AS Population, 
       MAX(total_cases)/MAX(population) * 100 AS Cases_to_Population
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY country
ORDER BY 4 DESC;

-- Countries with Highest Death Rate per Cases
-- Goal: Highlight countries with the deadliest outbreaks (most deaths per case).
SELECT country, MAX(total_deaths) AS Total_Reported_Deaths, 
       MAX(total_cases) AS Total_Reported_Cases, 
       MAX(total_deaths)/MAX(total_cases) * 100 AS Case_Fatality_Rate
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY country
ORDER BY Case_Fatality_Rate DESC;

-- Continent-Level: Most Deaths
-- Goal: Compare overall death tolls between continents.
SELECT continent, MAX(total_deaths) AS Total_Deaths
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;

-- Comparing Infection Rates Between Continents
-- Goal: Show how widespread infections were across continents.
SELECT continent, MAX(total_cases) AS TotalReportedCases, 
       MAX(population) AS Population, 
       MAX(total_cases)/MAX(population) * 100 AS InfectionRatePercent
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY InfectionRatePercent DESC;

-- Comparing Death Rates Per Cases Between Continents
-- Goal: Identify which continents had the highest case fatality rates.
SELECT continent, MAX(total_deaths) AS Total_Reported_Deaths, 
       MAX(total_cases) AS Total_Reported_Cases, 
       MAX(total_deaths)/MAX(total_cases) * 100 AS Case_Fatality_Rate
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Case_Fatality_Rate DESC;

-- Countries with the Most Deaths
-- Goal: Rank countries by absolute death count.
SELECT country, MAX(total_deaths) AS Total_Deaths
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;

-- Deaths as a percent of Population
-- Goal: Understand COVID’s total mortality impact relative to population size.
SELECT country, MAX(total_deaths) AS Total_Deaths, 
       MAX(population) AS Population, 
       MAX(total_deaths)/MAX(population) * 100 AS Crude_Mortality_Rate
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY 1
ORDER BY Crude_Mortality_Rate DESC;

-- Global Death Rate Over Time
-- Goal: Track the changing global case fatality rate (deaths per cases) as the pandemic evolved.
SELECT date, 
       SUM(total_deaths) AS Deaths, 
       SUM(total_cases) AS Cases, 
       SUM(total_deaths)/SUM(total_cases) * 100 AS Case_Fatality_Rate
FROM coviddeaths
WHERE continent IS NOT NULL
  AND total_cases IS NOT NULL
  AND total_deaths IS NOT NULL
  AND date > '2020-01-11'
GROUP BY 1
ORDER BY 1;

-- Joining Vaccination and Death Data
-- Goal: Combine infection and vaccination datasets to view entire data set.
SELECT * 
FROM coviddeaths d 
JOIN covidvaccinations v 
  ON d.country = v.country 
 AND d.date = v.date;

-- Global Vaccination Totals Over Time (Using Subquery)
-- Goal: Track total global vaccination doses with a running total.
SELECT date, DailyVaccinations, 
       SUM(DailyVaccinations) OVER (ORDER BY date) AS RunningTotalVaccinations
FROM (
    SELECT 
        date,
        SUM(IFNULL(new_vaccinations, 0)) AS DailyVaccinations
    FROM covidvaccinations
    WHERE continent IS NOT NULL
      AND date >= '2020-12-01'
    GROUP BY date
) AS daily;

-- Vaccination Progress by Country Over Time (Using CTE)
-- Goal: Track each country’s vaccination progress over time.
WITH dailyByCountry AS (
    SELECT 
        date, country, 
        SUM(IFNULL(new_vaccinations, 0)) AS DailyVaccinations
    FROM covidvaccinations
    WHERE continent IS NOT NULL
      AND date >= '2020-12-01'
    GROUP BY 1, 2
) 
SELECT date, country, DailyVaccinations, 
       SUM(DailyVaccinations) OVER (PARTITION BY country ORDER BY date) AS RunningTotalVaccinations
FROM dailyByCountry;

-- Total Population Vs. People Vaccinated
-- Goal: Identify which countries have vaccinated the largest % of their population.
SELECT country, 
       MAX(people_vaccinated) AS PeopleVaccinated, 
       MAX(population) AS Population, 
       MAX(people_vaccinated)/MAX(population) * 100 AS VaccinationRate
FROM covidvaccinations
WHERE continent IS NOT NULL
  AND people_vaccinated IS NOT NULL
GROUP BY 1;

-- Temporary Table: Avg Doses Per Person Over Time
-- Goal: Use a temp table to store running vaccination totals and compare to population.
DROP TABLE IF EXISTS RunningTotalVaccinations;

CREATE TEMPORARY TABLE RunningTotalVaccinations (
    continent VARCHAR(255),
    country VARCHAR(255),
    date DATETIME,
    population DOUBLE,
    new_vaccinations DOUBLE,
    running_total_vaccinations DECIMAL(20, 0)
);

-- Insert running total of vaccinations by country and date
INSERT INTO RunningTotalVaccinations
SELECT d.continent, d.country, d.date, d.population, v.new_vaccinations, 
       SUM(IFNULL(v.new_vaccinations, 0)) OVER (PARTITION BY country ORDER BY date) AS RunningTotalVaccinations
FROM coviddeaths d
JOIN covidvaccinations v
  ON d.country = v.country 
 AND d.date = v.date;

-- Calculate average doses per person in the U.S.
SELECT *, 
       (running_total_vaccinations / population) AS AvgDosesPerPerson
FROM RunningTotalVaccinations
WHERE country LIKE '%united states%';