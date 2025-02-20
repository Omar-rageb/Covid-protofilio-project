select *
from new_project..Covid_Deaths
where continent is not null
order by 1,2 

select location,date,total_cases,population,(total_cases/population)*100 as cases_percentage
from new_project..Covid_Deaths
--where location like '%States%'
where continent is not null
order by 1,2 

--looking to total cases VS population
select location,max(total_cases) as highest_INFACTION_COUNT ,population,max((total_cases/population))*100 as INFACTION_cases_percentage
from new_project..Covid_Deaths
where continent is not null
group by location,population
order by 1,2

-- Shoeing the continent thats have the most death per population
select continent,max(cast(total_deaths as int)) as highest_INFACTIONdeath_COUNT 
from new_project..Covid_Deaths
where continent is not null
group by continent
order by highest_INFACTIONdeath_COUNT desc

select sum(new_cases)as totalcases,sum(cast(new_deaths as int))as totaldeaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentag
from new_project..Covid_Deaths
where continent is not null
order by 1,2


--Temp table
DROP TABLE IF EXISTS #percentpopulationvaccinated;
CREATE TABLE #percentpopulationvaccinated
(
    continent nvarchar(255),
    location nvarchar(255),
    date datetime,
    population numeric,
    new_vaccinations int,
    Rollingpeoplevaccination numeric
);

insert into #percentpopulationvaccinated
select cd.continent ,cd.location,cd.date,cd.population ,cv.new_vaccinations
,sum(cast(cv.new_vaccinations as int))over (partition by cd.location order by cd.location,cd.date)
as Rollingpepolevaccenation
from new_project..Covid_Deaths cd
join new_project..covid_vaccinations cv
on cd.location=cv.location
and cd.date = cv.date
--where cd.continent is not null
--order by 2,3

select *, (Rollingpeoplevaccination/Population)*100 
from #percentpopulationvaccinated
-------------------------------------------------------------------

drop view if EXISTS percentpopulationvaccinated;
-- CREAT VIEW FOR LATTER

create view percentpopulationvaccinated as
select cd.continent ,cd.location,cd.date,cd.population ,cv.new_vaccinations
,sum(cast(cv.new_vaccinations as int))over (partition by cd.location order by cd.location,cd.date)
as Rollingpepolevaccenation
from new_project..Covid_Deaths cd
join new_project..covid_vaccinations cv
on cd.location=cv.location
and cd.date = cv.date
where cd.continent is not null
--order by 2,3

 select*
 from percentpopulationvaccinated