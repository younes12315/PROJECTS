SELECT 
    *
FROM
    `covid project`.coviddeaths$;
    
    #------------infection and death percentage------------------------#


SELECT 
    location,
    date,
    new_cases,
    total_cases,
    total_deaths,
    ((total_cases / population) * 100) AS 'cases percentage'
FROM
    coviddeaths$
WHERE
    continent IS NOT NULL
ORDER BY location , date;


SELECT 
    sum(total_cases) as total_cases,
    sum(total_deaths) as total_deaths,
    ROUND(((sum(total_cases) / sum(population)) * 100),3) AS 'cases percentage'
FROM
    coviddeaths$
WHERE
    continent IS NOT NULL;


#infection rate#
SELECT 
    location,
    max(date) as LATEST_DATE_AVAILABLE,
    population,
    MAX(total_cases) AS 'MAXIMUM INFECTED',
    MAX(total_deaths) AS 'TOTAL DEATHS',
    ((MAX(total_cases) / population) * 100) AS Infection_rate
FROM
    coviddeaths$
WHERE
    continent IS NOT NULL
GROUP BY location , population
ORDER BY Infection_rate ASC;

#DEATH PERCENTAGE#
SELECT 
    location,
    population,
    MAX(total_cases) AS 'MAXIMUM INFECTED',
    MAX(total_deaths) AS TOTAL_DEATHS,
    (MAX(total_deaths) / MAX(total_cases)) * 100 AS Death_percentage
FROM
    coviddeaths$
WHERE
    continent IS NOT NULL
GROUP BY location , population
ORDER BY TOTAL_DEATHS ASC;

# DEATH PERCENTAGE BY CONTINENT #
SELECT 
    continent,
    MAX(total_cases) AS 'MAXIMUM INFECTED',
    MAX(total_deaths) AS TOTAL_DEATHS,
    (MAX(total_deaths) / MAX(total_cases)) * 100 AS Death_percentage
FROM
    coviddeaths$
WHERE
    continent IS NOT NULL
GROUP BY continent
ORDER BY TOTAL_DEATHS ASC;

# DEATH PERCENTAGE BY CONTINENT AND POPULATION #

SELECT 
    continent,
    population,
    MAX(total_cases) AS 'MAXIMUM INFECTED',
    MAX(total_deaths) AS TOTAL_DEATHS,
    (MAX(total_deaths) / population) * 100 AS Death_percentage
FROM
    coviddeaths$
WHERE
    continent IS NOT NULL
GROUP BY continent 
ORDER BY TOTAL_DEATHS ASC;


SELECT 
    continent,
    MAX(total_cases) AS total_cases,
    MAX(total_deaths) AS total_deaths,
    (MAX(total_cases) / MAX(population)) * 100 AS infected_percentage,
    (MAX(total_deaths) / MAX(total_cases)) * 100 AS death_percentage
FROM
    coviddeaths$
WHERE
    continent IS NOT NULL
GROUP BY continent
ORDER BY population ASC;

SELECT 
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    ROUND(SUM(new_deaths) / SUM(new_cases), 2) AS death_percentage
FROM
    coviddeaths$
WHERE
    continent IS NOT NULL
;


#----vaccinated_people_percentage----------------#
SELECT 
* , 
ROUND ((max(TOTAL_PEOPLE_VACCINATED)/population *100),2) as VACCINATED_PEOPLE_PERCENTAGE
from
(SELECT 
    d.continent,
    d.location,
    d.date,
    d.population,
    v.new_vaccinations,
    sum(v.new_vaccinations) over (partition by d.location  order by d.location , d.date) as TOTAL_PEOPLE_VACCINATED
FROM
    coviddeaths$ d
        JOIN
    covidvaccinations$ v ON d.location = v.location
        AND d.date = v.date
WHERE
    d.continent IS NOT NULL 
ORDER BY d.location , d.date) a
group by location , date 
;
#-----------------view-------------------------#
CREATE VIEW  population_vaccinated as 
SELECT 
* , 
ROUND ((max(TOTAL_PEOPLE_VACCINATED)/population *100),2) as VACCINATED_PEOPLE_PERCENTAGE
from
(SELECT 
    d.continent,
    d.location,
    d.date,
    d.population,
    v.new_vaccinations,
    sum(v.new_vaccinations) over (partition by d.location  order by d.location , d.date) as TOTAL_PEOPLE_VACCINATED
FROM
    coviddeaths$ d
        JOIN
    covidvaccinations$ v ON d.location = v.location
        AND d.date = v.date
WHERE
    d.continent IS NOT NULL 
ORDER BY d.location , d.date) a
group by location , date 
;



