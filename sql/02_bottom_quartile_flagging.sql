-- Bottom-Quartile Priority Flagging
-- Benchmarks all 8 UDISE+ indicators across districts, ranks districts by
-- composite score, and flags those in the bottom quartile for field
-- verification and action planning.

WITH ranked AS (
    SELECT
        u.district_id,
        d.district_name,
        d.state,
        u.electricity_pct,
        u.toilets_pct,
        u.water_pct,
        u.internet_pct,
        u.boundary_wall_pct,
        u.library_pct,
        u.computer_lab_pct,
        u.handwashing_pct,
        u.composite_score,
        NTILE(4) OVER (ORDER BY u.composite_score ASC) AS quartile
    FROM udise_indicators u
    JOIN districts d ON d.district_id = u.district_id
)
SELECT
    district_name,
    state,
    composite_score,
    electricity_pct,
    toilets_pct,
    water_pct,
    internet_pct,
    boundary_wall_pct,
    library_pct,
    computer_lab_pct,
    handwashing_pct,
    'Bottom Quartile - Flagged' AS priority_flag
FROM ranked
WHERE quartile = 1
ORDER BY composite_score ASC;
