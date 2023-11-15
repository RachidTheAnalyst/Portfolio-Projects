
select *
from PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

select *
from PortfolioProject..CovidVaccinations
order by 3,4


Select location,date,total_cases,new_cases,total_deaths,population_density
from PortfolioProject..CovidDeaths
order by 1,2

--Looking at total cases vs total deaths
--show likelihood of dying if you contract covid in your country

Select Location,date,total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%morocco%'
--and Where continent is not null
order by 1,2

-- Looking at total cases vs population
-- Shows what percentage of population got covid

Select Location,date,total_cases,population_density,(total_cases/population_density)*100 as Percentpopulationinfected
from PortfolioProject..CovidDeaths
--where location like '%morocco%'
Where continent is not null
order by 1,2

--Looking at country with highest infection rate compared to population

Select Location,population_density,Max(total_cases) as HighestInfectionCount,
Max((total_cases/population_density))*100 as Percentpopulationinfected
from PortfolioProject..CovidDeaths
--where location like '%morocco%'
Where continent is not null
Group by location,population_density
order by Percentpopulationinfected Desc

--Showing countries with highest death count per population

Select Location,Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%morocco%'
Where continent is not null
Group by location
order by TotalDeathCount Desc


-- Let's Break things down by continent

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%morocco%'
Where continent is not null
Group by continent
order by TotalDeathCount Desc

--Global Numbers

Select Sum(new_cases) as Total_Deaths, 
       Sum(cast(new_deaths as int)) as TotalDeaths, 
	   Sum(cast(new_deaths as int))/ 
	   Sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%morocco%'
Where continent is not null
order by 1,2

--Looking at total population vs vaccianations

--Use CTE

with PopvsVac(Continent,location,Date,population_density,new_vaccinations,RollingPeopleVaccinated)
As (
select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations,
       Sum(convert(BIGINT,vac.new_vaccinations)) 
	   over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	   --(RollingPeopleVaccinated/population_density)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.Location = vac.Location
	 and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
select*,(RollingPeopleVaccinated/population_density)*100
from PopvsVac





--TEMP TABLE

Drop Table if exists #Percentpopulationvccinated
Create table #Percentpopulationvccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population_density numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #Percentpopulationvccinated
select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations,
       Sum(convert(BIGINT,vac.new_vaccinations)) 
	   over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	   --(RollingPeopleVaccinated/population_density)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.Location = vac.Location
	 and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3


select*,(RollingPeopleVaccinated/population_density)*100
from #Percentpopulationvccinated

--creating view to store data for later visualization


Create view Percentpopulationvccinated as
select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations,
       Sum(convert(BIGINT,vac.new_vaccinations)) 
	   over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	   --(RollingPeopleVaccinated/population_density)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.Location = vac.Location
	 and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

select *
from Percentpopulationvccinated
