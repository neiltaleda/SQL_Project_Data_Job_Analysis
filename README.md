# Introduction
Dive into the data jobs market. Focusing on data analyst roles, this project explores top paying jobs, in demand skills and where high demand meets high salary in data analytics.

Check out the SQL queries here
[project_sql folder](/project_sql/)

# Background
The aim of this project was to explore the data jobs market effectively. This project has insights on job titles, salaries, locations and essential skills.

### The questions I intend to answer through my SQL queries are:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools Used
Here are the list of tools used for the analysis:
- **SQL:** Used to query the database and extract key insights
- **PostgreSQL:** The database management system used for handling the data.
- **Visual Studio Code:** The code editor for writing all the code.
- **Git and Github:** The version control system for sharing my code and analysis, thereby ensuring collaboration and project tracking.

# The Analysis
Each query for this projectis aimed at investigating the data analyst job market.

### 1. Top Paying Data Analyst Jobs
To identify the highest paying roles, I filtered data analyst positions by yearly salary and location, focusing on remote jobs.

```sql
SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id    
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC    
LIMIT 10;           
```

Here's the breakdown of the top data analyst jobs in 2023:

- **Big Pay Range:** The best-paying data analyst jobs go from $184K up to $650K, showing there's a lot of money to be made in this field.

- **Many Companies Hiring:** High salaries aren’t just at tech giants — companies like SmartAsset, Meta, and AT&T are all paying well, across different industries.

- **Different Job Titles:** There are many kinds of roles, from Data Analyst to Director of Analytics, meaning there’s room to grow and specialize in different areas.

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-paying roles.

```sql
WITH top_paying_jobs AS (
SELECT 
    job_id,
    job_title,
    salary_year_avg,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id    
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC    
LIMIT 10
)
SELECT 
    top_paying_jobs.*,
    skills 
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```

Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:

- SQL is leading with a count of 8.
- Python follows closely with a count of 7.
- Tableau is also highly sought after, with a count of 6. Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.

### 3. In-Demand Skills for Data Analysts
This query showed which skills employers ask for the most, helping us focus on what’s really in demand.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY
    demand_count DESC    
LIMIT 5;
```
Here's the breakdown of the most demanded skills for data analysts in 2023

SQL and Excel are the most demanded skills, displaying the need for data processing and spreadsheet manipulation.
Progamming and Visualization tools like Python, Tableau, and PowerBI

| Skills    | Demand Count  |
|-----------|---------------|
| SQL       | 7291          |
| Excel     | 4611          |
| Python    | 4330          |
| Tableau   | 3745          |
| PowerBI   | 2609          |

### 4. Skills Based on Salary
Here are the different average salaries associated with different skills.

```sql
SELECT skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25;
```

- **Big Data & ML Pay Well:** Skills like PySpark, DataRobot, and Pandas are in high demand for handling large data and building models.
- **Dev Tools Boost Pay:** Knowing tools like GitLab, Airflow, and Kubernetes helps because they support automation and data pipelines.
- **Cloud Skills Matter:** Experience with GCP, Databricks, and Elasticsearch shows strong demand for working in cloud-based data environments.

### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, here we find out skills that are both in high demand and have high salaries.

```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id, 
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY
        skills_dim.skill_id
), average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id 
WHERE
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25; 
```


| Skill ID | Skills      | Demand Count | Average Salary ($) |
|----------|-------------|---------------|---------------------|
| 8        | Go          | 27            | 115,320             |
| 234      | Confluence  | 11            | 114,210             |
| 97       | Hadoop      | 22            | 113,193             |
| 80       | Snowflake   | 37            | 112,948             |
| 74       | Azure       | 34            | 111,225             |
| 77       | BigQuery    | 13            | 109,654             |
| 76       | AWS         | 32            | 108,317             |
| 4        | Java        | 17            | 106,906             |
| 194      | SSIS        | 12            | 106,683             |
| 233      | Jira        | 20            | 104,918             |

- **Programming Skills Are Key:** Python and R are in high demand, though their salaries suggest they’re widely used and expected.

- **Cloud & Big Data Tools Pay Well:** Skills like Snowflake, Azure, and AWS show strong demand and solid pay, highlighting the shift to cloud-based analytics.

- **BI & Database Tools Still Matter:** Tools like Tableau, Looker, and SQL databases remain essential for turning data into insights and managing information.

# Conclusions
From the analysis, several general insights emerged:

- **Top Remote Roles Pay Big:** Some remote data analyst jobs pay up to $650,000.

- **SQL Is Essential:** SQL is the most in-demand and a top-paying skill for data analysts.

- **Niche Skills Pay More:** Specialized tools like SVN and Solidity offer higher average salaries due to their rarity.
