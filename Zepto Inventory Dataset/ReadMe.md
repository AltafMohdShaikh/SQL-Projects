# Zepto E-Commerce Data Analysis (SQL)

## Project Overview
This project focuses on cleaning, migrating, and analyzing an e-commerce grocery dataset from Zepto using **MySQL**. The goal was to transform raw data and answer critical business performance questions.

## Tech Stack
* **Database Engine:** MySQL
* **Tool:** MySQL Workbench

## Key Data Engineering Steps Taken
1. **Schema Migration:** Converted PostgreSQL `SERIAL` constraints into MySQL-compatible `INT AUTO_INCREMENT` structures.
2. **Data Cleaning:** Handled data type mismatches by remapping boolean text flags (`TRUE`/`FALSE`) to binary options (`1`/`0`).
3. **Data Transformation:** Standardized monetary values by transforming pricing metrics from *paise* to *rupees* (`mrp / 100.0`).
4. **Safety Guards:** Bypassed MySQL Safe Update Mode using primary key filtering logic (`WHERE sku_id > 0`).

## Business Questions Answered
The analytical script contains queries optimized for:
* Tracking top-performing categories by average discount and estimated revenue.
* Inventory weight auditing (converting grams to kilograms for bulk metrics).
* Identifying out-of-stock items leaking potential premium revenue.
