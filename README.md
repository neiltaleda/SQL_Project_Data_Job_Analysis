# Introduction
This project explores the top paying jobs, in-demand skills and where high demand meets high salary in the field of data analytics.

Check out the SQL Queries here:
[project_sql folder](/project_sql/)

### The questions I wanted to answer through my SQL queries were: 
1. What are the top paying data analyst jobs?
2. What skills are required for these top paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools Used
These are the list of tools I used to deep dive into data analysis job market

- **SQL**: Used to query the database and extract meaningful insights
- **Visual Studio Code**: Used for database management and executing the SQL queries.
- **PostgreSQL**: The chosen database management system, ideal for handling the job posting data.
- **Github**: Essential for version control and sharing SQL scripts and analysis to ensure collaboration and efficient tracking.  

# Analysis
Each query used for this project is aimed at investigating the specific aspects of the data analyst job market.

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

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
Here's the breakdown of the top 10 data analyst jobs
in 2023:
- **Wide Salary Range:** The top 10 paying data analyst roles span from $184,000 to $650,000, indicating signifcant scope in this field.
- **Diverse Employers:** Companies like Samsung, Meta are among those offering high salaries, showing a varied interest across different industries.

### 2. Skills for Top Paying Jobs
To understand what skills are required for 30 top paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-paying roles.

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
ORDER BY
    salary_year_avg DESC;   
```

SQL, Python and R are the most widely demanded skills for high paying data analyst careers.

### 3. In-Demand Skills for Data Analysts
This query helped to identify the skills most frequently required in job postings- displaying the areas with high demand.

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

| skills    | demand_count |
|-----------|--------------|
|sql        |7291          |
|excel      |4611          |
|python     |4330          |
|tableau    |3745          |
|power bi   |2609          |

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```

- **High Demand for Big Data & ML Skills:** Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.

- **Software Development & Deployment Proficiency:** Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.

- **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```


| Skill |ID	       | Skills	 | Demand Count	| Average Salary ($) |
|-------|----------|---------|--------------|--------------------|
| 8	    |go	       |27	     |   115,320    | 115320             |
| 234	|confluence|11	     |   114,210    | 114210             |
| 97	|hadoop	   |22	     |   113,193    | 113193             |
| 80	|snowflake |37	     |   112,948    | 112948             |
| 74	|azure	   |34	     |   111,225    | 111225             |
| 77	|bigquery  |13	     |   109,654    | 109654             |
| 76	|aws	   |32	     |   108,317    | 108317             |
| 4	    |java	   |17	     |   106,906    | 106906             |
| 194	|ssis	   |12	     |   106,683    | 106683             |
| 233	|jira	   |20	     |   104,918    | 104918             |



# Key Learnings
1. Merging tables and using WITH clauses
2. Data aggregation using GROUP BY, COUNT() and AVG()
3. Deriving key insights based on a dataset.

# Conclusion
- **Top-Paying Data Analyst Jobs:** The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!

- **Skills for Top-Paying Jobs:** High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
Most In-Demand Skills: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.

- **Skills with Higher Salaries:** Specialized skills, such as Pyspark and Couchbase, are associated with the highest average salaries, indicating a premium on niche expertise.

- **Optimal Skills for Job Market Value:** Go, Confluence and Hadoop leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.
