-- Weakest Indicator per Flagged District
-- For each bottom-quartile district, identifies which single UDISE+
-- indicator is lowest, so the field-verification checklist can lead with
-- the specific gap rather than a generic "infrastructure is poor" note.

WITH ranked AS (
    SELECT
        u.district_id,
        d.district_name,
        d.state,
        u.composite_score,
        NTILE(4) OVER (ORDER BY u.composite_score ASC) AS quartile
    FROM udise_indicators u
    JOIN districts d ON d.district_id = u.district_id
),
unpivoted AS (
    SELECT district_id, 'Electricity' AS indicator, electricity_pct AS pct FROM udise_indicators
    UNION ALL SELECT district_id, 'Functional Toilets', toilets_pct FROM udise_indicators
    UNION ALL SELECT district_id, 'Drinking Water', water_pct FROM udise_indicators
    UNION ALL SELECT district_id, 'Internet', internet_pct FROM udise_indicators
    UNION ALL SELECT district_id, 'Boundary Wall', boundary_wall_pct FROM udise_indicators
    UNION ALL SELECT district_id, 'Library', library_pct FROM udise_indicators
    UNION ALL SELECT district_id, 'Computer Lab', computer_lab_pct FROM udise_indicators
    UNION ALL SELECT district_id, 'Handwashing Facility', handwashing_pct FROM udise_indicators
),
weakest AS (
    SELECT
        district_id,
        indicator,
        pct,
        RANK() OVER (PARTITION BY district_id ORDER BY pct ASC) AS rnk
    FROM unpivoted
)
SELECT
    r.district_name,
    r.state,
    r.composite_score,
    w.indicator AS weakest_indicator,
    w.pct AS weakest_indicator_pct
FROM ranked r
JOIN weakest w ON w.district_id = r.district_id AND w.rnk = 1
WHERE r.quartile = 1
ORDER BY r.composite_score ASC;
