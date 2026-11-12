# Supply Chain Data Pipeline (Northwind)

An end-to-end batch pipeline built on the Northwind sample database. It extracts operational data, loads it into a local warehouse, transforms it with dbt, tests it, and produces two business tables.

## Data source

- **Dataset:** Northwind (originally from Microsoft), via [pthom/northwind_psql](https://github.com/pthom/northwind_psql)
- **License:** Microsoft Public License (Ms-PL), included in `data/source/LICENSE`
- **Scope:** 830 orders, 2,155 order lines, 77 products, 29 suppliers, 6 shippers (1996 to 1998)

## Architecture

```
GitHub dump (PostgreSQL)
  → source database (DuckDB)            [notebook: extract]
  → CSV files in data/raw/              [notebook: extract]
  → warehouse, schema `raw`             [notebook: load]
  → dbt staging views                   [dbt: staging]
  → dbt mart tables                     [dbt: marts]
  → tests (27 checks)                   [dbt: tests]
  → charts and reconciliation           [notebook: analyze]
```

## Models

| Layer | Model | What it answers |
|---|---|---|
| Staging | `stg_orders`, `stg_order_details`, `stg_products`, `stg_suppliers`, `stg_shippers` | Clean, typed copies of each raw table |
| Mart | `mart_shipping_performance` | Late-shipment rate and average days to ship, per shipping company |
| Mart | `mart_supplier_inventory_risk` | Share of active products at or below reorder level, per supplier |

## Tests

- `unique` and `not_null` on primary keys
- `relationships` (foreign keys): orders → shippers, order lines → orders and products, products → suppliers
- Singular test: an order cannot ship before it was placed

## How to run

Requirements: Python 3.10+ and the packages `duckdb pandas matplotlib dbt-core dbt-duckdb nbformat nbclient ipykernel`.

1. Open `supply_chain_pipeline.ipynb` from the project root.
2. Run all cells. The notebook downloads the source dump, builds the warehouse, runs `dbt build`, reconciles the marts against the raw data, and saves the chart.

To run dbt by itself from `dbt_project/`:

```
dbt build --profiles-dir .
```

## Outputs

- `warehouse/supply_chain.duckdb`: the warehouse with `raw`, staging, and mart tables
- `reports/supply_chain_dashboard.png`: charts for shipping performance and supplier inventory risk

## Notes and limits

- Orders that have not shipped (21 of 830) are excluded from shipping metrics.
- Northwind has no purchase orders or inventory history, so inventory risk is a point-in-time snapshot from the product table, not a time series.
- Everything runs locally. There is no scheduler or incremental loading yet. Those are the next steps for a stronger version of this project.
