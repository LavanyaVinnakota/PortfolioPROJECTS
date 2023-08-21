select *
from PortfolioProject..CovidDeaths$
order by 3,4

--select*
--from PortfolioProject..covidvaccinations$
--order by 3,4
---SELECT THE DATA WE ARE GOING TO USE-----------------------------
select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths$
order by 1,2

--LOOKING AT TOTAL CASES VS TOTAL DEATHS
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where location like'%India%'
order by 1,2

-----LOOKING AT TOTAL CASES VS POPULATION
select location,date,total_cases,population,(total_cases/population)*100 as Deathper
from PortfolioProject..CovidDeaths$
--where location like '%India%'
order by 1,2

--WHICH COUNTRY IS HAVING HIGH INFECTION RATE COMPARED TO POPULATION-------------

select location,population,Max(total_cases) as high_infection_count,max((total_cases/population))*100
as Percentage_population_infected
from PortfolioProject..CovidDeaths$
group by location,population
order by Percentage_population_infected desc

---SHOWING THE COUNTRIES WITH HIGHEST DEATH COUNT OVER POPULATION
select location,Max(total_deaths)as TotalDeathCount
from PortfolioProject..CovidDeaths$
where continent is not null
group by location
order by TotalDeathCount desc

--LETS LOOK BY CONTINENTS
select continent,Max(total_deaths)as TotalDeathCount
from PortfolioProject..CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCount desc

select location,Max(total_deaths)as TotalDeathCount
from PortfolioProject..CovidDeaths$
where continent is  null
group by location
order by TotalDeathCount desc

-----CONTINENTS WITH HIGHEST DEATH COUNT
select continent,Max(total_deaths)as TotalDeathCount
from PortfolioProject..CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCount desc


-----------------GLOBAL NUMBERS------
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
group by date
order by 1,2
------JOINING TWO TABLES BY LOCATION AND DATE--------
select* 
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
on dea.location=vac.location 
and dea.date=vac.date
-----LOOKING AT TOTAL POPULATION VS  VACCINATIONS---------
select dea.continent,dea.location,dea.date,dea.population,vac.New_vaccinations,
SUM(vac.new_vaccinations)OVER (PARTITION BY dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
on dea.location=vac.location 
and dea.date=vac.date
WHERE dea.continent is not null
order by 2,3

----USING CTE--------
WITH PopVSVac(continent,location,date,population,New_vaccinations,RollingPeopleVaccinated)
AS
(
select dea.continent,dea.location,dea.date,dea.population,vac.New_vaccinations,
SUM(vac.New_vaccinations)OVER (PARTITION BY dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
)
SELECT*,(RollingPeopleVaccinated/population)*100
FROM PopVSVac

----------------TEMP TABLE---------------------

DROP TABLE IF EXISTS  #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations  numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.New_vaccinations,
SUM(vac.New_vaccinations)OVER (PARTITION BY dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null

SELECT*,(RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated



-----CREATING VIEWS----------
CREATE VIEW PercentPopulationVaccinated AS
select dea.continent,dea.location,dea.date,dea.population,vac.New_vaccinations,
SUM(vac.New_vaccinations)OVER (PARTITION BY dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null








