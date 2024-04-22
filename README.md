# Cleaning Data with MySQL

## Overview

In today's dynamic global economy, workforce fluctuations are not uncommon. Between 2020 and 2024 hundreds of thousands of employee have lost their jobs to layoffs around the world. Understanding the patterns and underlying factors behind these layoffs is crucial for businesses, employees, jobseekers, and policymakers alike. In this project, I explore a comprehensive dataset capturing details of employee layoffs from diverse industries and regions around the world.

## Objective
The primary objective of this project is to showcase my proficiency in data cleaning using MySQL. I aim to demonstrate the ability to cleanse, transform, and prepare raw data for analysis, enabling extraction of meaningful insights.

## About the Dataset
The dataset contains details of employee layoffs by companies in different cities and across industries, as reported by Bloomberg, San Francisco Business Times, TechCrunch, and The New York Times

Source: [Layoffs Dataset - Kaggle](https://www.kaggle.com/datasets/swaptr/layoffs-2022/data)

### Data Dictionary

- company: Name of the company initiating the layoff
- location: City location of the company
- industry: Categorizes the industry to which the company belongs
- total_laid_off: Total number of employees laid off
- percentage_laid_off: Percentage of the employees laid off as a proportion of the total company population
- date: The date at which the layoffs were announced or implemented
- stage: Describes the stage of company's funding
- country: Specifies the country where the layoffs primarily occurred
- funds_raised_millions: Represents the total funds raised by the company, measured in millions

## Data Cleaning

The file [cleaning.sql](https://github.com/BerylCAtieno/cleaning-data-with-MySQL/blob/main/cleaning.sql) demonstrates the use of DQL and DML to meticulously clean the dataset. The data cleaning process addresses several issues including the following;

- Duplicate data
- Lack of data standardization
- Null values and empty data cells
- Data formating and data type issues

## Analysis and Insights
## Conclusion
