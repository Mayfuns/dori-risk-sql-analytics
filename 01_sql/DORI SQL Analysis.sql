SELECT *
FROM table1;

SELECT *
FROM table2;

--count patient records
SELECT COUNT(patient_id) as "No of Records"
FROM table1;

-- count of lesion
SELECT COUNT(lesion_id)
FROM table2;

-- number of region
SELECT COUNT(DISTINCT(region)) AS "No of Skin Regions"
FROM table2;

SELECT DISTINCT(region) AS "Skin Regions"
FROM table2;

--Age RANGE
SELECT
    MIN(age) AS minimum_age,
    MAX(age) AS maximum_age,
    ROUND(AVG(age)) AS average_age
FROM table1;

--Diagnostic
SELECT DISTINCT(diagnostic),COUNT(diagnostic)
FROM table2
GROUP BY 1
ORDER BY 2 DESC;

--Diagnostic categories
SELECT
    distinct(diagnostic),
    CASE
        WHEN (diagnostic) IN ('MEL', 'SCC', 'BCC') THEN 'Malignant'
        WHEN (diagnostic) = 'ACK' THEN 'Precancerous'
        WHEN (diagnostic) IN ('SEK', 'NEV') THEN 'Benign'
        ELSE 'Unknown'
    END AS diagnosis_group
FROM table2;


--Task 1: Patient Demographic Risk Analysis
--1.Which age group has the highest number of skin cancer diagnoses?
--2.What is the distribution of diagnoses between male and female patients?
--3.Which body regions record the highest number of patients with malignant diagnoses?
--4.How many patients have a previous history of skin cancer?

--1. Which age group has the highest number of skin cancer diagnoses?
		--Skin Cancer Age Groups
SELECT
    CASE
        WHEN t1.age < 20 THEN 'Under 20'
        WHEN t1.age BETWEEN 20 AND 39 THEN '20-39'
        WHEN t1.age BETWEEN 40 AND 59 THEN '40-59'
        WHEN t1.age BETWEEN 60 AND 79 THEN '60-79'
        ELSE '80+'
    END AS age_group,
    COUNT(*) AS skin_cancer_patients
FROM table1 t1
JOIN table2 t2
    ON t1.patient_id = t2.patient_id
GROUP BY 1
ORDER BY skin_cancer_patients DESC;

--2.What is the distribution of diagnoses between male and female patients?
SELECT 
    t1.gender,
    COUNT(*) AS diagnosis_count,
    ROUND(
        COUNT(*) * 100.0 /
        (
            SELECT COUNT(*)
            FROM table1 AS a
            JOIN table2 AS b
                ON a.patient_id = b.patient_id
        ),
        2
    ) AS diagnosis_percentage
FROM table1 AS t1
JOIN table2 AS t2
    ON t1.patient_id = t2.patient_id
GROUP BY t1.gender
ORDER BY diagnosis_percentage DESC;

--3.Which body regions record the highest number of patients with malignant diagnoses?
SELECT
    t2.region,
    COUNT(DISTINCT t1.patient_id) AS malignant_patient_count
FROM table1 AS t1
JOIN table2 AS t2
    ON t1.patient_id = t2.patient_id
WHERE t2.diagnostic IN ('MEL', 'SCC', 'BCC')
GROUP BY t2.region
ORDER BY malignant_patient_count DESC;

--4.How many patients have a previous history of skin cancer?
SELECT
    COUNT(*) AS patients_with_skin_cancer_history
FROM table1
WHERE skin_cancer_history = TRUE;

---Patients Skin cancer history
SELECT
    CASE
        WHEN skin_cancer_history = TRUE THEN 'Previous history'
        WHEN skin_cancer_history = FALSE THEN 'No previous history'
        ELSE 'Unknown'
    END AS history_status,
    COUNT(*) AS patient_count
FROM table1
GROUP BY history_status
ORDER BY patient_count DESC;

--Task 2: Lesion Growth and Diagnosis Analysis
--1.Which diagnosis category appears most frequently?
--2.How many lesions were reported as growing over time?
--3.Which symptoms are most commonly associated with lesions?
--4.How many lesions were biopsed before diagnosis confirmation?
--5.Which diagnosis type has the highest average lesion diameter?

--1.Which diagnosis category appears most frequently?

SELECT
    diagnostic,
    COUNT(*) AS diagnosis_count
FROM table2
GROUP BY diagnostic
ORDER BY diagnosis_count DESC;

--2.How many lesions were reported as growing over time?
SELECT
    COUNT(*) FILTER(WHERE grew = TRUE) AS growing_lesions,
    COUNT(*) AS total_lesions,
    ROUND(
        COUNT(*) FILTER (WHERE grew = TRUE) * 100.0
        / COUNT(*),
        2
    ) AS growing_percentage
FROM table2;

--3.Which symptoms are most commonly associated with lesions?
SELECT
    COUNT(*) FILTER (WHERE itch = TRUE) AS itching,
    COUNT(*) FILTER (WHERE hurt = TRUE) AS pain,
    COUNT(*) FILTER (WHERE changed = TRUE) AS changed_appearance,
    COUNT(*) FILTER (WHERE bleed = TRUE) AS bleeding,
    COUNT(*) FILTER (WHERE elevation = TRUE) AS elevation
FROM table2;

-- Most common symptom
SELECT
    symptoms.symptom,
    COUNT(*) AS symptom_count
FROM table2 AS t2
CROSS JOIN LATERAL (
    VALUES
        ('Itching', t2.itch),
        ('Pain', t2.hurt),
        ('Changed appearance', t2.changed),
        ('Bleeding', t2.bleed),
        ('Elevation', t2.elevation)
) AS symptoms(symptom, is_present)
WHERE symptoms.is_present = TRUE
GROUP BY symptoms.symptom
ORDER BY symptom_count DESC;

--4.How many lesions were biopsed before diagnosis confirmation?
SELECT
    COUNT(*) AS biopsied_lesions
FROM table2
WHERE biopsed = TRUE;

--5.Which diagnosis type has the highest average lesion diameter?
SELECT
    diagnostic,
    ROUND(
        CAST(
            AVG((diameter_1 + diameter_2) / 2.0)
            AS NUMERIC
        ),
        2
    ) AS average_lesion_diameter
FROM table2
WHERE diameter_1 IS NOT NULL
  AND diameter_2 IS NOT NULL
GROUP BY diagnostic
ORDER BY average_lesion_diameter DESC;


--Task 3: Environmental Healthcare Analysis
--1.Which body region has the highest number of diagnosed cases?
--2.How many patients lack access to piped water?
--3.How many patients do not have access to sewage systems?
--4.Which body regions report the highest number of biopsied lesions?
--5.Is there a relationship between poor sanitation access and severe diagnosis

--1.Body region wit highest number of diagnosed cases

SELECT
    region,
    COUNT(*) AS diagnosed_cases
FROM table2
GROUP BY region
ORDER BY diagnosed_cases DESC
LIMIT 1;

--2.How many patients lack access to piped water?
SELECT
    COUNT(*) AS patients_without_piped_water
FROM table1
WHERE has_piped_water = FALSE;

--Access no piped water VS No ACCESS
SELECT
    CASE
        WHEN has_piped_water = TRUE THEN 'Has piped water'
        WHEN has_piped_water = FALSE THEN 'No piped water'
        ELSE 'Unknown'
    END AS water_access,
    COUNT(*) AS patient_count
FROM table1
GROUP BY water_access
ORDER BY patient_count DESC;

--3.How many patients do not have access to sewage systems?
SELECT
    COUNT(*) AS patients_without_sewage_system
FROM table1
WHERE has_sewage_system = FALSE;

--Access to sewage water VS NO ACCESS
SELECT
    CASE
        WHEN has_sewage_system = TRUE THEN 'Has sewage system'
        WHEN has_sewage_system = FALSE THEN 'No sewage system'
        ELSE 'Unknown'
    END AS sewage_access,
    COUNT(*) AS patient_count
FROM table1
GROUP BY sewage_access
ORDER BY patient_count DESC;

--4.Which body regions report the highest number of biopsied lesions?
SELECT
    region,
    COUNT(*) AS biopsied_lesion_count
FROM table2
WHERE biopsed = TRUE
GROUP BY region
ORDER BY biopsied_lesion_count DESC;

--5.Is there a relationship between poor sanitation access and severe diagnosis

SELECT
    CASE
        WHEN t1.has_piped_water IS FALSE
          OR t1.has_sewage_system IS FALSE
           THEN 'Poor sanitation access'
		WHEN t1.has_piped_water IS TRUE
         AND t1.has_sewage_system IS TRUE
           THEN 'Adequate sanitation access'
		ELSE 'Unknown'
    	END AS sanitation_status,
	COUNT(*) AS total_patients,
	SUM(
        CASE
            WHEN t2.diagnostic IN ('MEL', 'SCC', 'BCC')
                THEN 1
            ELSE 0
        END
    ) AS severe_diagnosis_count,
ROUND(
        AVG(
            CASE
                WHEN t2.diagnostic IN ('MEL', 'SCC', 'BCC')
                    THEN 1.0
                ELSE 0.0
            END
        ) * 100,
        2
    ) AS severe_diagnosis_percentage
FROM table1 AS t1
JOIN table2 AS t2
    ON t1.patient_id = t2.patient_id
GROUP BY
    CASE
        WHEN t1.has_piped_water IS FALSE
          OR t1.has_sewage_system IS FALSE
            THEN 'Poor sanitation access'
       WHEN t1.has_piped_water IS TRUE
         AND t1.has_sewage_system IS TRUE
            THEN 'Adequate sanitation access'
  ELSE 'Unknown'
    END
ORDER BY severe_diagnosis_percentage DESC;

--Task 4: Lifestyle and Behavioural Risk Analysis
---1. How many patients are smokers?
---2.How many patients consume alcohol regularly?
---3.Which diagnosis types are most common among smokers?
---4.What percentage of smokers also consume alcohol?
---5.Are patients who both smoke and drink more likely to develop malignant conditions?
---6.Which lifestyle factor has the strongest relationship with severe diagnosis outcomes?

--1. How many patients are smokers?
-- 1. How many patients are smokers?

SELECT
    COUNT(*) AS number_of_smokers
FROM table1
WHERE smoke = TRUE;

--2.How many patients consume alcohol regularly?
SELECT
    COUNT(*) AS number_of_alcohol_consumers
FROM table1
WHERE drink = TRUE;

---3.Which diagnosis types are most common among smokers?
SELECT
    t2.diagnostic,
    COUNT(*) AS diagnosis_count
FROM table1 AS t1
JOIN table2 AS t2
    ON t1.patient_id = t2.patient_id
WHERE t1.smoke = TRUE
GROUP BY t2.diagnostic
ORDER BY diagnosis_count DESC
LIMIT 1;

--4.What percentage of smokers also consume alcohol?
SELECT
    COUNT(*) AS total_smokers,
    COUNT(*) FILTER (WHERE drink = TRUE) AS smokers_who_drink,
    ROUND(
        COUNT(*) FILTER (WHERE drink = TRUE) * 100.0
        / NULLIF(COUNT(*), 0),
        2
    ) AS percentage_of_smokers_who_drink
FROM table1
WHERE smoke = TRUE;

--5.Are patients who both smoke and drink more likely to develop malignant conditions?
SELECT
    CASE
        WHEN t1.smoke IS TRUE AND t1.drink IS TRUE
            THEN 'Smokes and drinks'
          ELSE 'Others'
    END AS lifestyle_group,
	COUNT(*) AS total_patients,
	COUNT(*) FILTER (
        WHERE t2.diagnostic IN ('MEL', 'SCC', 'BCC')
    ) AS malignant_cases,
ROUND(
        COUNT(*) FILTER (
            WHERE t2.diagnostic IN ('MEL', 'SCC', 'BCC')
        ) * 100.0 / COUNT(*),
        2
    ) AS malignant_percentage
FROM table1 AS t1
JOIN table2 AS t2
    ON t1.patient_id = t2.patient_id
GROUP BY 1
ORDER BY malignant_percentage DESC;

--6.Which lifestyle factor has the strongest relationship with severe diagnosis outcomes?
SELECT
    CASE
        WHEN t2.diagnostic IN ('MEL', 'SCC', 'BCC')
            THEN 'Severe diagnosis'
        ELSE 'Non-severe diagnosis'
    END AS diagnosis_outcome,
	COUNT(*) FILTER (
        WHERE t1.smoke IS TRUE
    ) AS smokers,
	COUNT(*) FILTER (
        WHERE t1.drink IS TRUE
    ) AS drinkers,
	COUNT(*) FILTER (
        WHERE t1.smoke IS TRUE
          AND t1.drink IS TRUE
    ) AS patients_who_smoke_and_drink,
	COUNT(*) AS total_patients
FROM table1 AS t1
JOIN table2 AS t2
    ON t2.patient_id = t1.patient_id
GROUP BY 1
ORDER BY 1;

--
SELECT
    CASE
        WHEN t1.smoke = TRUE AND t1.drink = TRUE
            THEN 'Smoking and alcohol'
        WHEN t1.smoke = TRUE
            THEN 'Smoking only'
        WHEN t1.drink = TRUE
            THEN 'Alcohol only'
        ELSE 'Neither'
    END AS lifestyle_factor,
COUNT(*) AS total_patients,
 COUNT(*) FILTER (
        WHERE t2.diagnostic IN ('MEL', 'SCC', 'BCC')
    ) AS severe_cases,
  ROUND(
        COUNT(*) FILTER (
            WHERE t2.diagnostic IN ('MEL', 'SCC', 'BCC')
        ) * 100.0 / COUNT(*),
        2
    ) AS severe_percentage
FROM table1 AS t1
JOIN table2 AS t2
    ON t1.patient_id = t2.patient_id
GROUP BY 1
ORDER BY severe_percentage DESC;