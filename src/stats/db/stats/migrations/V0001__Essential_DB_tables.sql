CREATE TABLE cases_per_day (
    id SERIAL PRIMARY KEY,
    date DATE,
    number INTEGER
);

CREATE TABLE cases_per_day (
    id SERIAL PRIMARY KEY,
    case_uuid UUID NOT NULL,
    disease ???,
    report_date DATE NOT NULL,
    creation_date DATE NOT NULL,
    report_year SMALLINT NOT NULL CHECK (report_year > 2000),
    report_month SMALLINT NOT NULL CHECK (report_month >= 1 AND report_month <= 12),
    report_week SMALLINT NOT NULL CHECK (report_week >= 1 AND report_week <= 52),
    case_classification,
    outcome, 
    case_origin,
    quarantine,
    person_uuid UUID NOT NULL, 
    sex,
    date_of_birth DATE,
    age_at_report SMALLINT NOT NULL CHECK (age_at_report <=130),
    occupation_type,
    present_condition,
    region_uuid UUID NOT NULL,
    region_name,
    district_uuid UUID NOT NULL,
    district_name  
);