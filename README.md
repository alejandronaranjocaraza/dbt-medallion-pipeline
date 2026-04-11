# Healthcare Company Sample Data Pipeline with dbt

This repository contains a sanitized sample of a healthcare company's data pipeline built with dbt.
The project follows a medallion architecture (staging/bronze → intermediate/silver → marts/gold).
The *marts* layer is designed around the *star schema* philosophy: a central *fact* table holds
business process metrics while multiple *dimension* tables provide contextual information for each
business entity.

The project is anonymized but reflects the real structure used to transform and load data from the
company's ERP system (Odoo), covering sales and appointment data, and making it accessible to the
data analysis team.

## A Note on the Full Pipeline

This repository represents only one stage of the company's complete data pipeline. The full system
follows an ELT pattern implemented in Python, DuckDB, and dbt, orchestrated with Apache Airflow.
AWS S3 is used for storage, with all data handled as Parquet files. The pipeline runs on AWS EC2
instances.

## Objective

The project aims to stay faithful to medallion and star schema design principles while remaining
practical for an emerging business whose systems and data are in continuous development. The primary
concern throughout is balancing robust architecture with readable, maintainable code — ensuring the
data analysis team receives consistent, accurate data even as the underlying systems evolve.

## Key Design Decisions

- SCD2 tracking via dbt snapshots applied selectively to slowly-changing entities
  (products, partners) but not transactional records
- `referencia_analisis` parsed at the bronze layer to extract embedded business
  dimensions (company, business unit, doctor) without modifying source columns
- Refund pairs excluded from `fact__sales` at the intermediate layer using a
  self-referencing exclusion CTE
- Timezone normalization (UTC → America/Mexico_City) applied uniformly at the
  silver layer

## Repository Structure
```text
company_dbt/
├── analyses/                   # Reserved for ad-hoc analytical SQL
├── macros/                     # Reserved for reusable dbt macros
├── models/                     # Core transformation models
│   └── odoo/
│       ├── 01_staging/         # Bronze: source cleaning and deduplication
│       ├── 02_intermediate/    # Silver: business logic and joins
│       └── 03_marts/           # Gold: analytics-ready models
│           ├── agg/            # Pre-aggregated metrics
│           │   ├── doctors/
│           │   ├── patients/
│           │   └── sales/
│           ├── dim/            # Dimension tables (star schema)
│           │   ├── general/
│           │   └── sales/
│           └── fact/           # Fact tables (star schema)
├── seeds/                      # Static reference data (CSV)
│   └── odoo/
└── snapshots/                  # SCD2 history tracking
```

## Learning

I joined the company with no prior experience with DuckDB, dbt, or Apache Airflow.
Building this pipeline required hands-on familiarization with all three tools, as well
as broader reading on data modeling and warehouse design principles — including medallion
architecture, star schema, and slowly changing dimensions.

## References

- [dbt Documentation](https://docs.getdbt.com/docs/introduction)
- [DuckDB Documentation](https://duckdb.org/docs/)
- Joe, R., & Matt, H. (2022). *Fundamentals of Data Engineering.*<https://www.oreilly.com/library/view/fundamentals-of-data/9781098108298/>
- Ralph K., & Margy, R. (2013). *The Data Warehouse Toolkit*<https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/books/data-warehouse-dw-toolkit/>
