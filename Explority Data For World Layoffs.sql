# Exploritory Data Analyzes

SELECT * 
FROM world_layoffs.layoffs_staging2;

# Max Total Laid Off

SELECT MAX(total_laid_off)
FROM world_layoffs.layoffs_staging2;

# Max/Min Percentage Laid Off

SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off IS NOT NULL;

# Companies With 100% Layoffs

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1;

# 100% Laid Off And Rasied The Most Money In Decending Order

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

# Top 5 Compaines With A Single Day Layoff

SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging
ORDER BY 2 DESC
LIMIT 5;

# Top 10 Companies With Most Total Layoffs

SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

# Top 10 Locations With Most Total Layoffs

SELECT location, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

# Countries Total Layoffs

SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

# Years Total Layoffs

SELECT YEAR(date), SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 ASC;

# Industry Total Layoffs

SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

# Stage Total Layoffs

SELECT stage, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

# Top 3 Companies Per Year

WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS 
(
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

# Total Layoffs Per Month

SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC;

# Rolling Total Of Layoffs Per Month

WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;

# Total Employees At Point Of Layoff

SELECT company, total_laid_off, percentage_laid_off, ROUND((total_laid_off * (1 / percentage_laid_off)),0) AS total_employees, `date`
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
AND percentage_laid_off IS NOT NULL
ORDER BY total_employees DESC;
