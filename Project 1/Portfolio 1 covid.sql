Select * from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

 --Select * from PortfolioProject..CovidVaccinations
--order by 3,4

-- Select Data being used

Select Location , date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2


-- Viewing the Total Cases vs Total Deaths
-- Shows percentage of deaths if you contracted covid in your country

Select Location , date, total_cases, total_deaths, (total_deaths/ total_cases) * 100 as Death_Percentage
from PortfolioProject..CovidDeaths
where location like '%Asia%'
order by 1,2

-- Total Cases vs Population
Select location, date, total_Cases, population, (total_cases / population) * 100 as Percentage
from PortfolioProject..CovidDeaths
where location like '%United Kingdom%'
order by 1,2

-- What country has the highest infection rate?
Select location,MAX(total_Cases) as Highest_infection_count, population, MAX((total_cases / population)) * 100 as Percent_Population_Infected
from PortfolioProject..CovidDeaths
group by Location, population
order by Percent_Population_Infected desc

-- Countries with Highest Death Count per Population
Select location, MAX(cast(total_deaths as int)) as Total_Death_Count
from PortfolioProject..CovidDeaths
where continent is not null
group by Location
order by Total_Death_Count desc

-- By continent
Select continent, MAX(cast(total_deaths as int)) as Total_Death_Count
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by Total_Death_Count desc

-- Globabl numbers

Select  SUM(new_Cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(Cast(new_deaths as int))/Sum(New_cases ) * 100 as Global_death_percentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2

-- Total Population vs Vaccinations
With PopvsVac (Continent,Location,Date,Population, New_Vaccinations, RollingPeopleVaccinated)
as
(

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date ) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths as dea	
join PortfolioProject..CovidVaccinations as vac	
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



--Temp Table
Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(300),
LOcation nvarchar(300),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date ) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths as dea	
join PortfolioProject..CovidVaccinations as vac	
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating view
Drop table if exists PercentPopulationVaccinated
Create view VaccinePop as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date ) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths as dea	
join PortfolioProject..CovidVaccinations as vac	
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select * from VaccinePop

-- Queries used for Visualizations to be exported to Tableau

-- 1 
Select  SUM(new_Cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(Cast(new_deaths as int))/Sum(New_cases ) * 100 as Global_death_percentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2

-- 2 
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is null
and location not in ('World' , 'European Union', 'International')
Group by location
order by TotalDeathCount desc

-- 3
-- What country has the highest infection rate?
Select location,MAX(total_Cases) as Highest_infection_count, population, MAX((total_cases / population)) * 100 as Percent_Population_Infected
from PortfolioProject..CovidDeaths
group by Location, population
order by Percent_Population_Infected desc

--4
Select Location, Population, Date, MAX(total_Cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject.. CovidDeaths
Group by location, population, date	
order by PercentPopulationInfected desc

