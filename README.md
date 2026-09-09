# Mission SafeCity: Women's Safety Data Analysis (MySQL)

An end-to-end relational database and analytical SQL project modeling women's safety incident data. This project designs a normalized relational database across 7 core entities, ingests operational CSV datasets, and implements 25 business critical SQL queries ranging from exploratory data analysis to advanced business priority scoring.

---

## Repository Structure

```text
├── datasets/
│   ├── devices.csv
│   ├── incident_types.csv
│   ├── incidents.csv
│   ├── infrastructure.csv
│   ├── locations.csv
│   ├── response_outcomes.csv
│   └── safety.csv
├── 01_schema_setup.sql
├── 02_data_analysis_queries.sql
├── 03_sql_analysis_output.xlsx
├── Mission_SafeCity_SQL_Project_Presentation.pptx
├── Mission_SafeCity_ER_Diagram.png
├── Mission_SafeCity_ER_Diagram.mwb
└── README.md
```
---

## Tech Stack & File Breakdown

### Technologies & Tools
* **Database Management System (DBMS)**: MySQL 8.0+
* **Query Language**: Structured Query Language (SQL) — DDL, DML, DQL
* **Database Clients**: MySQL Workbench
* **Data Ingestion**: Optimized bulk loading using `LOAD DATA LOCAL INFILE`
* **Reporting**: Excel reporting dashboard and KPI dashboard

---

### File Contents & Purpose

* **`01_schema_setup.sql` (Database Definition & Ingestion)**:
  * **DDL (Data Definition Language)**: Creates the `safety_incidents` database and sets up 7 normalized relational tables with primary keys and foreign key constraints
  * **Data Ingestion**: Configures `local_infile` settings and bulk loads raw `.csv` files from the `datasets/` directory into MySQL

* **`02_data_analysis_queries.sql` (Analytical & Reporting Layer)**:
  * **Data Quality & Validation (Queries 1–4)**: Establishes dataset trust by checking row counts, identifying duplicate incidents, checking for missing values, and validating age and response time ranges.
  * **Core Analytics & Operations (Queries 5–16)**: Evaluates overall KPIs, incident types, severity distribution, locations, panic-button usage, and operational context like shifts, weather, and witnesses

    (Multi table relational joins, string concatenation, date and time extractions (HOUR, DATE), subqueries, and grouping with HAVING filters)
  * **Advanced Queries (17–25)**: Advanced analytical modeling utilizing:
    * **Window Functions**: DENSE_RANK(), ROW_NUMBER()
    * **Common Table Expressions (CTEs)**: Modular WITH clauses for isolating severe incidents and building priority score models.
    * **Time-Series Analysis**: Month over Month revenue growth velocity and ride frequency intervals via LAG() and DATEDIFF().

---

## 💡 Key Business Questions Answered

1. **Locations & Risk Identification**: Detects high risk locations, understands where incidents concentrate, and measures response time differences between risk levels.
2. **Severity Distribution & Incident Types**: Identifies the most common incident categories and compares response performance by severity to highlight resource allocation needs.
3. **Technology & Device Efficacy**: Measures panic button usage rates and compares average response times across mobile, smartwatch, and dedicated panic button devices.
4. **Operational Context**: Analyzes how weather conditions, and the presence of witnesses correlate with incident volumes and response times.
5. **Business Priorities & Resource Allocation**: Uses advanced SQL to generate a business priority score based on incident counts, response times, and risk bonuses to identify top triage locations.

---

## 🚀 How to Understand & Run the Project

### Prerequisites
* MySQL Server 8.0+ installed and running.
* MySQL Workbench or terminal client.

---

### Step-by-Step Execution Guide

#### Configure & Execute Data Ingestion (`01_schema_setup.sql`)

1. Open `01_schema_setup.sql` in MySQL Workbench or your editor
2. Update the file paths in the `LOAD DATA LOCAL INFILE` statements to match the absolute path of the `datasets/` folder on your local machine
   ```sql
   LOAD DATA LOCAL INFILE '/path/to/your/repo/datasets/devices.csv'
   INTO TABLE devices ...
   ```
3. Run the entire script to create the database, tables, constraints, and populate the data
  
#### Run Analytical Queries (`02_data_analysis_queries.sql`)
Execute `02_data_analysis_queries.sql` either query by query to inspect specific metrics or all at once to generate complete analytics tables.
