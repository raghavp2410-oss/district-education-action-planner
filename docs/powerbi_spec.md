# Power BI Spec — Bottom-Quartile Priority Flags

Documented as a data model + DAX spec (not a binary `.pbix`) so it's
reviewable and reproducible — see the note in the govt-scheme-access-analysis
project for why. To rebuild: Power BI Desktop → import
`data/districts.csv` and `data/udise_indicators.csv` → relate on
`district_id` → add the measures below.

## DAX measures

```DAX
Composite Score = AVERAGE(udise_indicators[composite_score])

District Quartile =
VAR AllScores = ALL(udise_indicators[composite_score])
VAR Rank = RANKX(AllScores, [Composite Score], , ASC)
VAR TotalDistricts = COUNTROWS(ALL(udise_indicators))
RETURN
    SWITCH(
        TRUE(),
        Rank <= TotalDistricts * 0.25, "Q1 (Bottom Quartile)",
        Rank <= TotalDistricts * 0.50, "Q2",
        Rank <= TotalDistricts * 0.75, "Q3",
        "Q4 (Top Quartile)"
    )

Weakest Indicator Pct =
MINX(
    {
        udise_indicators[electricity_pct], udise_indicators[toilets_pct],
        udise_indicators[water_pct], udise_indicators[internet_pct],
        udise_indicators[boundary_wall_pct], udise_indicators[library_pct],
        udise_indicators[computer_lab_pct], udise_indicators[handwashing_pct]
    },
    [Value]
)
```

## Visuals

- **Bottom-quartile flag table**: district, state, composite score,
  weakest indicator, quartile — filtered to Q1, conditional formatting red
  for lowest scores (mirrors `sql/02_bottom_quartile_flagging.sql`)
- **Indicator heatmap**: matrix of district × indicator, color-scaled 0–100%,
  to spot whether low scores are broad (infra-poor district) or concentrated
  in one indicator (e.g. internet lagging everywhere)
- **Review-cycle tracker**: stacked bar of flagged / reviewed / carried-over
  districts per quarter, against the 90%-reviewed target
