import pandas as pd
from sqlalchemy import create_engine

# 1. Load the CSV
coviddeaths = pd.read_csv('coviddeaths.csv')

# 2. Preview the data
print("Before cleaning:")
print(coviddeaths.head())

# 3. Convert the 'date' column to proper datetime
coviddeaths['date'] = pd.to_datetime(coviddeaths['date'], format='%m/%d/%Y', errors='coerce')

# 4. Handle any potential date errors
print("After date parsing:")
print(coviddeaths[['date']].head())
# Checking for rows where date conversion failed
invalid_dates = coviddeaths[coviddeaths['date'].isnull()]
if not invalid_dates.empty:
    print("\n Found rows with invalid dates:")
    print(invalid_dates) 
# There are no printed results. 

# 5. Connect to MySQL
engine = create_engine("mysql+pymysql://root:password123@localhost/covid_project")

# 6. Export to MySQL
coviddeaths.to_sql(name='coviddeaths', con=engine, if_exists='replace', index=False)

print("✅ Data cleaned and uploaded to MySQL as coviddeaths.")

'''
Completing the same steps a second time for the second table: covidvaccinations
'''

# 1. Load the CSV
covidvaccinations = pd.read_csv('covidvaccinations.csv')

# 2. Preview the data
print("Before cleaning:")
print(covidvaccinations.head())

# 3. Convert the 'date' column to proper datetime
covidvaccinations['date'] = pd.to_datetime(covidvaccinations['date'], format='%m/%d/%Y', errors='coerce')

# 4. Handle any potential date errors
print("After date parsing:")
print(covidvaccinations[['date']].head())
# Checking for rows where date conversion failed
invalid_dates = covidvaccinations[covidvaccinations['date'].isnull()]
if not invalid_dates.empty:
    print("\n Found rows with invalid dates:")
    print(invalid_dates) 
# There are no printed results. 

# 5. Connect to MySQL
engine = create_engine("mysql+pymysql://root:password123@localhost/covid_project")

# 6. Export to MySQL
covidvaccinations.to_sql(name='covidvaccinations', con=engine, if_exists='replace', index=False)

print("✅ Data cleaned and uploaded to MySQL as covidvaccinations.")