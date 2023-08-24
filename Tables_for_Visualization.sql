-------TABLE 1 FOR POWERBI-------
SELECT SUM(cast(new_cases as int )) as total_cases,SUM(new_deaths )as total_deaths,SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2

------------TABLE 2 FOR POWERBI----------------
Select location,SUM(cast(new_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
where continent is  not null
and location not in('world','European Union','International')
group by location
order by TotalDeathCount desc

-------------TABLE 3 FOR POWERBI--------------
Select location,population,MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
Group by location,population
order by PercentPopulationInfected desc

----------TABLE 4 FOR POWERBI--------------------
Select location,population,date,MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
where continent is not null
Group by location,population,date
order by PercentPopulationInfected desc
