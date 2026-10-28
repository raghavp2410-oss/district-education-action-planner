# District Education Action Planner

Benchmarking school infrastructure across districts and turning the result
into a recurring, trackable action cycle — not a one-off report.

## Problem

UDISE+ (the national school infrastructure dataset) reports indicators like
electricity, toilets, and internet connectivity per district, but a report
alone doesn't change anything. Two things were needed: a way to consistently
surface the districts that need attention most, and a process that makes
sure flagged issues actually get followed up on.

## Approach

- **Data**: synthetic dataset modeled on UDISE+ structure — 42 districts
  across 11 states, 8 infrastructure indicators (electricity, functional
  toilets, drinking water, internet, boundary wall, library, computer lab,
  handwashing facility) plus a composite score. See
  [`data/`](data/).
- **Benchmarking** (`sql/`): benchmarked all 8 indicators across the 40+
  districts and ranked by composite score.
- **Power BI** (`docs/powerbi_spec.md`): bottom-quartile priority flags and
  an indicator heatmap, documented as a data model + DAX spec.
- **Field verification**: built a standard checklist
  ([`docs/field_verification_checklist.md`](docs/field_verification_checklist.md))
  so flagged districts get the same verification process every time, and a
  [quarterly review cadence](docs/review_cadence.md) targeting 90% of
  flagged issues reviewed per cycle, with action owners and closure
  tracking.

## Results (on the synthetic dataset)

**Bottom-quartile flagged districts** (11 of 42, by composite score):

| District | State | Composite Score | Weakest Indicator |
|---|---|---|---|
| Gaya | Bihar | 32.8 | Library (25%) |
| Madhepura | Bihar | 32.9 | Library (24%) |
| Gadchiroli | Maharashtra | 36.5 | Computer Lab (20%) |
| Chamoli | Uttarakhand | 37.0 | Internet (24%) |
| Khagaria | Bihar | 37.6 | Library (25%) |
| Bellary | Karnataka | 37.9 | Computer Lab (22%) |
| Malkangiri | Odisha | 38.4 | Computer Lab (31%) |
| Rajnandgaon | Chhattisgarh | 39.0 | Computer Lab (22%) |
| Bijapur | Chhattisgarh | 39.2 | Internet (27%) |
| Latehar | Jharkhand | 40.9 | Computer Lab (29%) |
| Hailakandi | Assam | 41.4 | Internet (27%) |

*(full output in [`docs/sample_outputs.txt`](docs/sample_outputs.txt))*

Breaking out the weakest indicator per district (rather than just flagging
on composite score) shows the gap isn't uniform: computer labs and
libraries lag most often, internet in a smaller cluster — which argues for
targeted fixes over a blanket infrastructure push.

## Repo structure

```
district-education-action-planner/
├── data/
│   ├── districts.csv              # 42 districts
│   ├── udise_indicators.csv       # 8 indicators + composite score per district
│   └── education_planner.db       # SQLite db with both tables loaded
├── sql/
│   ├── 01_schema.sql
│   ├── 02_bottom_quartile_flagging.sql
│   └── 03_weakest_indicator_by_district.sql
└── docs/
    ├── powerbi_spec.md
    ├── field_verification_checklist.md
    ├── review_cadence.md
    └── sample_outputs.txt
```

## Reproducing this

```bash
sqlite3 -header -column data/education_planner.db < sql/02_bottom_quartile_flagging.sql
sqlite3 -header -column data/education_planner.db < sql/03_weakest_indicator_by_district.sql
```

## Notes

Indicator values are synthetic (generated with a fixed random seed) and
modeled to resemble realistic UDISE+ distributions, with internet and
computer-lab access deliberately lagging other indicators — this is a
methodology demonstration, not a claim about actual infrastructure in these
districts.
