USE layoffs;

-- Create a staging table to work on to avoid making mistakes on raw data

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- REMOVING DUPLICATE DATA

-- 1. Display duplicate data using a CTE and the ROW_NUMBER() window function

WITH duplicates_cte AS (
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, 
			total_laid_off, percentage_laid_off, 
            `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging 
)
SELECT *
FROM duplicates_cte
WHERE row_num > 1; -- results show 5 duplicated rows

-- 2. create temporary table with the row_num column
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, 
			total_laid_off, percentage_laid_off, 
            `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- 3. delete all rows in layoffs_staging2 where row_num > 1, delete row_num
SET SQL_SAFE_UPDATES = 0;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- STANDARDIZING DATA

-- removing leading and trailing spaces
UPDATE layoffs_staging2
SET company = TRIM(company);

-- the industry column looks like it has empty rows, null values, 
-- same industries listed as different due to lack of standardization

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

SELECT DISTINCT industry
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%'; -- there's 'Crypto', CryptoCurrency', and 'Crypto Currency'

UPDATE layoffs_staging2
SET industry = "Crypto"
WHERE industry LIKE 'Crypto%'; -- Changed all to 'Crypto'

-- standardization issue in country - there's two United States (one with a . at the end)
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY country;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE "United States%";

-- change date column from text to date datatype

-- running this query to confirm correct format change
SELECT `date`, 
		STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

-- changing format to prevent an error when correcting data type
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- changing data type to DATE
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- HANDLING NULL VALUES AND EMPTY ROWS

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- If both total_laid_off and percentage_laid_off are null, the datapoint offers no information to the analysis
-- these rows will be deleted

DELETE 
FROM layoffs_staging2
WHERE (total_laid_off IS NULL 
AND percentage_laid_off IS NULL);

-- populate misssing data where missing data can be determined

-- This self-join displays the industry column where a company has available industry data but with null/empty rows in other datapoints
SELECT t1.company, t2.company, T1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- update table to populate industry where values are known

UPDATE layoffs_staging2
SET industry = NULL -- First set all blanks to null 
WHERE industry = '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;