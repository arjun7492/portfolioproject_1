select*
from PortfolioProject_1..covid_deaths$	
where continent is not null
order by 3,4

--select*
--from PortfolioProject_1..covid_vaccine$	
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject_1..covid_deaths$	
order by 1,2

--total cases vs total deaths

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as Deathpercentage 
from PortfolioProject_1..covid_deaths$	
where location like 'india'
order by 1,2

--total cases vs population
select location,date,total_cases,population, (total_cases/population)*100 as poppercentage
from PortfolioProject_1..covid_deaths$	
where location like 'india'
order by 1,2

--highest infected countries
select location,population, MAX(total_cases) as highestinfected, MAX(total_cases/population)*100 as poppercentageinfected
from PortfolioProject_1..covid_deaths$	
--where location like 'india'
group by location,population
order by poppercentageinfected desc

--highest death countries

select continent, MAX(cast(total_deaths as int)) as totaldeathcount
from PortfolioProject_1..covid_deaths$	
--where location like 'india'
where continent is not null
group by continent
order by totaldeathcount desc


select date,total_cases,total_deaths, (total_deaths/total_cases)*100 as Deathpercentage 
from PortfolioProject_1..covid_deaths$	
--where location like 'india'
where continent is not null
group by date
order by 1,2


select date,sum(new_cases),sum(new_deaths ), sum(new_deaths )/sum(new_cases)*100 as Deathpercentage 
from PortfolioProject_1..covid_deaths$	
--where location like 'india'
where continent is not null 
group by date
order by 1,2

--use CTE
WITH popvsvac( continent,location,date,population,new_vaccinations,totalvaccination)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date ) as totalvaccination
--,(totalvaccination/dea.population)*100 as vaccinatedpercent
from PortfolioProject_1..covid_deaths$ dea
join PortfolioProject_1..covid_vaccine$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null 
)
select* ,(totalvaccination/population)*100
from popvsvac 


--temp table
drop table if exists #peoplevaccinatedpercent
create table #peoplevaccinatedpercent
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
totalvaccination numeric,
)

insert into #peoplevaccinatedpercent
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date ) as totalvaccination
--,(totalvaccination/dea.population)*100 as vaccinatedpercent
from PortfolioProject_1..covid_deaths$ dea
join PortfolioProject_1..covid_vaccine$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null 
--order by 2.3

select* ,(totalvaccination/population)*100
from #peoplevaccinatedpercent

create view peoplevaccinatedpercent as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date ) as totalvaccination
--,(totalvaccination/dea.population)*100 as vaccinatedpercent
from PortfolioProject_1..covid_deaths$ dea
join PortfolioProject_1..covid_vaccine$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null 


select*
from peoplevaccinatedpercent