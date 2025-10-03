# SQL_Project-Sales_Performance_Insights

### Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Techniques Used](#techniques-used)
- [Data Cleaning and Preparation](#data-cleaning-and-Preparation)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Analysis Results ](#analysis-results)
- [Links and Sources](#links-and-sources)



### Project Overview

This is an Advanced Data Analytics project that leverages sophisticated SQL techniques to answer specific business questions.
It focuses on solving real-world business challenges by writing complex SQL queries, which include the extensive use of Advanced Window Functions, Common Table Expressions (CTEs), and Subqueries.

The project follows a comprehensive roadmap and involves executing several key analysis types:

- **Change Over Time Analysis**: To track trends and identify data seasonality.
- **Cumulative Analysis**: To progressively aggregate data over time, enabling us to understand the business's overall growth or decline trajectory (i.e., running totals).
- **Performance Analysis**: To benchmark current values against a target or historical standard (e.g., comparing current sales against the product's average or the previous year's sales).
- **Part-to-Whole Analysis**: To determine the proportional contribution of a segment to the total (e.g., calculating the percentage contribution of a specific category to overall sales).
- **Data Segmentation**: To group data into specific, meaningful ranges, thereby creating new dimensions for analysis (e.g., segmenting products by cost brackets or customers by their spending behavior)."


![Q6-Chart](https://github.com/GabryGit/SQL-Project-Global-sustainable-development/blob/main/Charts/Q6.png)

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

### Data Sources


### Tools

- PostgreSQL - Data Analysis



### Techniques Used

- CTE (Common Table Expression)
- Subqueries
- Views
- Window Functions (aggregate/ranking window functions)
- Joins


  
### Data Cleaning and Preparation

In the initial data preparation phase, we performed Data cleaning and formatting with Power Query in Microsoft Excel - before importing it in PostgreSQL.
You can find cleaned datasets [[here]](https://github.com/GabryGit/SQL-Project-Global-sustainable-development/tree/main/Clean_datasets).



### Exploratory Data Analysis

EDA involved exploring the data to answer key questions, such as:

- Q1. "What are the top 10 countries that emitted the highest percentage of global CO₂ in 2023?"
- Q2. "Is there a correlation between CO₂ emissions and the amount of agricultural land in a country?"
- Q3. "Assessment of the impact of fossil fuel energy and clean energy (nuclear and renewables) on CO₂ emissions, averaged over the last 10 years."
- ...
- Q7. "Comparison between average GDP growth and average energy consumption per capita growth from 2000 to 2020."
- ...
- Q10. "Comparison of population aging between developed and developing countries."
- ...
- Q12. "Correlation between a country's economy and its healthcare situation."
- ...
- Q13.2 "Number of victims and missing migrants per year, divided by category."
- ...
  


### Analysis Results 

The answers to the various analysis questions are within the [[SQL script]](https://github.com/GabryGit/SQL-Project-Global-sustainable-development/blob/main/SQL_Project-Global_Sustainable_Developement.sql), at the end of each query used to extract the necessary data. The resulting charts/tables from the various queries are also stored in this [[folder]](https://github.com/GabryGit/SQL-Project-Global-sustainable-development/tree/main/Charts). 

![Q5-Chart](https://github.com/GabryGit/SQL-Project-Global-sustainable-development/blob/main/Charts/Q5.png)
![Q13.2-Chart](https://github.com/GabryGit/SQL-Project-Global-sustainable-development/blob/main/Charts/Q13.2.png)

### Limitations

Missing values spotted on 'Global Data on Sustainable Energy' dataset to be cleaned.
