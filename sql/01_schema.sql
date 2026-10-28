-- District Education Action Planner
-- Schema definition

DROP TABLE IF EXISTS districts;
DROP TABLE IF EXISTS udise_indicators;

CREATE TABLE districts (
    district_id    TEXT PRIMARY KEY,
    district_name  TEXT NOT NULL,
    state          TEXT NOT NULL
);

-- One row per district: 8 UDISE+ infrastructure indicators (% of schools
-- in the district reporting the facility as present/functional), plus a
-- composite score (simple average of the 8).
CREATE TABLE udise_indicators (
    district_id        TEXT PRIMARY KEY,
    electricity_pct     INTEGER NOT NULL,
    toilets_pct          INTEGER NOT NULL,   -- functional toilets
    water_pct            INTEGER NOT NULL,   -- drinking water
    internet_pct         INTEGER NOT NULL,
    boundary_wall_pct    INTEGER NOT NULL,
    library_pct          INTEGER NOT NULL,
    computer_lab_pct     INTEGER NOT NULL,
    handwashing_pct      INTEGER NOT NULL,
    composite_score      REAL NOT NULL,
    FOREIGN KEY (district_id) REFERENCES districts(district_id)
);
