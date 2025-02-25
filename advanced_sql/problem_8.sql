/*
Find job postings from first quarter that have salaries greater than $70K
- Combine job posting tables from the first quarter of 2023
- Gets job postings with an average yearly salary > $70,000

*/

SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::date,
    salary_year_avg
FROM (

    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter1_job_postings
WHERE 
    quarter1_job_postings.salary_year_avg > 70000 AND
    quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    quarter1_job_postings DESC;