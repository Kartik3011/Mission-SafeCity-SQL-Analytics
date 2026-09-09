-- ============================================================
-- MISSION SAFECITY - WOMEN'S SAFETY SQL PROJECT
-- ============================================================

CREATE DATABASE IF NOT EXISTS safety_incidents;
USE safety_incidents;

-- DROP TABLES IF THEY ALREADY EXIST

DROP TABLE IF EXISTS incidents;
DROP TABLE IF EXISTS infrastructure;
DROP TABLE IF EXISTS response_outcomes;
DROP TABLE IF EXISTS incident_types;
DROP TABLE IF EXISTS devices;
DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS safety;


SET GLOBAL local_infile = 1;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

-- DEVICES
CREATE TABLE devices (
    Device_ID VARCHAR(10) PRIMARY KEY,
    Device_Type VARCHAR(50)
);


-- INCIDENT TYPES
CREATE TABLE incident_types (
    Incident_Type_ID VARCHAR(10) PRIMARY KEY,
    Incident_Type VARCHAR(100),
    Severity VARCHAR(20)
);


-- LOCATIONS
CREATE TABLE locations (
    Location_ID VARCHAR(10) PRIMARY KEY,
    Area_Name VARCHAR(150),
    Zone VARCHAR(50),
    Risk_Level VARCHAR(20),
    Latitude DECIMAL(10,6),
    Longitude DECIMAL(10,6)
);


-- RESPONSE OUTCOMES
CREATE TABLE response_outcomes (
    Outcome_ID VARCHAR(10) PRIMARY KEY,
    Response_Outcome VARCHAR(100)
);


-- INFRASTRUCTURE
CREATE TABLE infrastructure (
    Infrastructure_ID VARCHAR(10) PRIMARY KEY,
    Location_ID VARCHAR(10),
    CCTV_Count INT,
    Streetlight_Count INT,
    Emergency_Poles INT,
    Patrol_Frequency VARCHAR(50),

    FOREIGN KEY (Location_ID)
        REFERENCES locations(Location_ID)
);


-- INCIDENTS
CREATE TABLE incidents (
    Incident_ID VARCHAR(20) PRIMARY KEY,
    Date DATE,
    Time TIME,
    Location_ID VARCHAR(10),
    Device_ID VARCHAR(10),
    Incident_Type_ID VARCHAR(10),
    Outcome_ID VARCHAR(10),
    Victim_Age INT,
    Panic_Button_Used VARCHAR(10),
    Response_Time_Minutes INT,
    Weather VARCHAR(50),
    Witness_Count INT,
    Shift VARCHAR(20),

    FOREIGN KEY (Location_ID)
        REFERENCES locations(Location_ID),

    FOREIGN KEY (Device_ID)
        REFERENCES devices(Device_ID),

    FOREIGN KEY (Incident_Type_ID)
        REFERENCES incident_types(Incident_Type_ID),

    FOREIGN KEY (Outcome_ID)
        REFERENCES response_outcomes(Outcome_ID)
);


-- SAFETY
CREATE TABLE safety (
    Device_Type VARCHAR(50),
    GPS_Coordinates VARCHAR(100),
    Panic_Button_Activation VARCHAR(10),
    Incident_Type VARCHAR(100),
    Response_Time_Minutes INT,
    Response_Outcome VARCHAR(100),
    Date DATE,
    Time TIME,
    Day VARCHAR(20),
    Location_Type VARCHAR(100),
    Age INT,
    Emergency_Contact_Status VARCHAR(100)
);



-- IMPORT CSV FILES



-- DEVICES
LOAD DATA LOCAL INFILE
'C:/Users/troze/OneDrive/Desktop/K/Imarticus/Mission SafeCity Women''s Safety SQL Project/datasets/devices.csv'  -- double '' as 
INTO TABLE devices
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- double '' as  folder contains an apostrophe in: Women's Safety SQL Project so we used ''

-- INCIDENT TYPES
LOAD DATA LOCAL INFILE
'C:/Users/troze/OneDrive/Desktop/K/Imarticus/Mission SafeCity Women''s Safety SQL Project/datasets/incident_types.csv'
INTO TABLE incident_types
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- LOCATIONS
LOAD DATA LOCAL INFILE
'C:/Users/troze/OneDrive/Desktop/K/Imarticus/Mission SafeCity Women''s Safety SQL Project/datasets/locations.csv'
INTO TABLE locations
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- RESPONSE OUTCOMES
LOAD DATA LOCAL INFILE
'C:/Users/troze/OneDrive/Desktop/K/Imarticus/Mission SafeCity Women''s Safety SQL Project/datasets/response_outcomes.csv'
INTO TABLE response_outcomes
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- INFRASTRUCTURE
LOAD DATA LOCAL INFILE
'C:/Users/troze/OneDrive/Desktop/K/Imarticus/Mission SafeCity Women''s Safety SQL Project/datasets/infrastructure.csv'
INTO TABLE infrastructure
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- INCIDENTS
LOAD DATA LOCAL INFILE
'C:/Users/troze/OneDrive/Desktop/K/Imarticus/Mission SafeCity Women''s Safety SQL Project/datasets/incidents.csv'
INTO TABLE incidents
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    Incident_ID,
    Date,
    Time,
    Location_ID,
    Device_ID,
    Incident_Type_ID,
    Outcome_ID,
    Victim_Age,
    Panic_Button_Used,
    Response_Time_Minutes,
    Weather,
    Witness_Count,
    Shift
);


-- SAFETY
LOAD DATA LOCAL INFILE
'C:/Users/troze/OneDrive/Desktop/K/Imarticus/Mission SafeCity Women''s Safety SQL Project/datasets/safety.csv'
INTO TABLE safety
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- VIEW SAMPLE DATA

SELECT * FROM devices LIMIT 10;

SELECT * FROM incident_types LIMIT 10;

SELECT * FROM locations LIMIT 10;

SELECT * FROM response_outcomes LIMIT 10;

SELECT * FROM infrastructure LIMIT 10;

SELECT * FROM incidents LIMIT 10;

SELECT * FROM safety LIMIT 10;

USE safety_incidents;

-- VERIFYING ROW COUNTS

SELECT 'devices' AS Table_Name, COUNT(*) AS Row_Count FROM devices
UNION ALL
SELECT 'incident_types', COUNT(*) FROM incident_types
UNION ALL
SELECT 'locations', COUNT(*) FROM locations
UNION ALL
SELECT 'response_outcomes', COUNT(*) FROM response_outcomes
UNION ALL
SELECT 'infrastructure', COUNT(*) FROM infrastructure
UNION ALL
SELECT 'incidents', COUNT(*) FROM incidents
UNION ALL
SELECT 'safety', COUNT(*) FROM safety;