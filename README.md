# DORI Risk Analysis — Healthcare SQL Analytics

A PostgreSQL healthcare risk-analysis project examining **skin-lesion diagnoses, patient demographics, environmental access and lifestyle factors**.

[View the supporting project](https://mayfuns.github.io/mariam-analytics-portfolio/supporting-projects.html#dori)

## SQL file

[View the complete DORI SQL analysis](01_sql/DORI%20SQL%20Analysis.sql)

## Analysis areas

### Patient demographic risk
- Age groups associated with skin-cancer diagnoses
- Diagnosis distribution by gender
- Body regions with malignant diagnoses
- Previous skin-cancer history

### Lesion growth & diagnosis
- Diagnosis frequency
- Lesions reported as growing
- Common lesion symptoms
- Biopsy activity
- Average lesion diameter by diagnosis

### Environmental healthcare factors
- Diagnosed cases by body region
- Access to piped water
- Access to sewage systems
- Biopsied lesions by region
- Severe diagnoses compared with sanitation access

### Lifestyle & behavioural risk
- Smoking prevalence
- Alcohol consumption
- Diagnoses among smokers
- Percentage of smokers who also drink
- Malignant outcomes among people who both smoke and drink
- Comparison of lifestyle factors with severe diagnosis outcomes

## SQL techniques demonstrated

- PostgreSQL
- INNER JOIN
- CASE expressions
- GROUP BY and ORDER BY
- Aggregate functions
- Conditional aggregation with `FILTER`
- Subqueries
- `NULLIF`
- `CROSS JOIN LATERAL`
- Percentage calculations
- Boolean filtering
- Risk segmentation

## Decision-support perspective

The project goes beyond counts by grouping diagnoses into malignant, precancerous and benign categories, then comparing those outcomes against demographics, lesion characteristics, sanitation access and lifestyle behaviours.

## Repository structure

```text
01_sql/
02_database/
03_data/
04_results/
05_documentation/
```

## Portfolio

- [Portfolio homepage](https://mayfuns.github.io/mariam-analytics-portfolio/)
- [Supporting projects](https://mayfuns.github.io/mariam-analytics-portfolio/supporting-projects.html#dori)
