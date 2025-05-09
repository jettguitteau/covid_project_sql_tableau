Global COVID-19 Analysis Project

Overview
This project explores global COVID-19 data to uncover insights into mortality, case fatality rates, and the impact of vaccination efforts. Using SQL, Python, and Tableau, I analyzed and visualized how the pandemic affected different countries and continents over time. The primary goal is to make the data accessible and insightful to the general public, offering a global perspective on how COVID-19 unfolded and how different regions responded.


Tools & Technologies
- **Python** – Used to clean date formats and load the dataset into MySQL.
- **SQL (MySQL Workbench)** – Used for data cleaning, transformation, and analysis.
- **Tableau** – Used for creating visualizations and dashboards.
- **Data Source:** [Our World in Data – COVID-19](https://ourworldindata.org/covid-deaths)


Key Visualizations (Tableau Story)
https://public.tableau.com/app/profile/jett.guitteau/viz/covid_data_tableau_17467985719760/COVIDDataStory

The final Tableau Story includes five interactive visualizations:

1. **Case Fatality Rate vs. Vaccinations Over Time**  
   A dual-line chart showing a global decrease in case fatality rate as total vaccinations increased, suggesting a strong inverse relationship.

2. **Deaths by Continent**  
   Two bar charts comparing:
   - Total reported deaths per continent
   - Case fatality rate per continent  
   Highlights how raw death counts and adjusted mortality percentages can tell very different stories.

3. **Global Crude Mortality Rate Map**  
   A world map visualizing total COVID-19 deaths as a percentage of population for each country.

4. **Cases Per Population Map**  
   A world map showing how widespread infections were in each country as a percentage of their population.

5. **Country Comparison Treemap**  
   A treemap with filters that allow viewers to compare case fatality rates between selected countries.


Key Takeaways
- **North America** had the highest number of reported deaths but only a mid-tier case fatality rate, suggesting widespread transmission but relatively effective case management.
- **Africa and China** reported notably low case and death counts, which may reflect underreporting rather than actual outcomes due to limited data transparency or capacity.
- **Case fatality rates dropped significantly** in direct correlation with the rollout of vaccines starting in late 2020.
- Among western countries, **the United States had a higher crude mortality rate** than peers such as Canada or Western Europe.
- **Oceania** had by far the lowest death counts and best case fatality rates, indicating highly effective pandemic response strategies.
- Countries with reliable reporting show similar infection rates by population, supporting the reliability of their other reported metrics and reinforcing the success or failure of various regional strategies.


SQL Views Used
This project used SQL views to prepare datasets optimized for Tableau visualization. These include:
- Global case fatality rates over time
- Total vaccines administered globally
- Total deaths and case fatality rates by continent
- Crude mortality rates and case counts per country
- Interactive views for country-level comparisons

You can find all SQL queries with annotations in the sql file 'sql_queries_with_annotations.sql', and you can see the views used for the Tableau vizzes in the sql file 'sql_creating_views_for_tableau.sql'.

The python file used to clean dates and upload the data to MySQL is available in the repository as 'data_clean_dates_and_upload.py'.

The raw data can be seen in the 'coviddeaths' and 'covidvaccinations' CSV files.
---

Author:
Jett Guitteau
  
Data Analyst | SQL, Python & Tableau Enthusiast  
Feel free to connect on LinkedIn: https://www.linkedin.com/in/jettguitteau/
