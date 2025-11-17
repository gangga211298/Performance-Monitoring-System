# Performance Monitoring Dashboard

## Background

Previously, the performance recap and analysis process at the branch was conducted **manually using Excel**. This required significant time and effort to calculate daily performance before the team could prepare action plans and execute the PDCA cycle.

To reduce manual work and improve efficiency, I developed an automated **Performance Monitoring Dashboard** that updates key performance data on a daily, weekly, monthly, quarterly, and yearly basis.

With this dashboard, all key KPIs are refreshed **automatically**, enabling the Service Manager and the team to focus directly on **analyzing the situation** and **creating action plans**—rather than spending time on manual calculations.

As a result, the monitoring process becomes significantly faster, more accurate, and more efficient, supporting a much more effective PDCA cycle each period.

---

## Objectives

This project aims to build an efficient performance monitoring system as a solution to the time-consuming manual recap process.

Specifically, the dashboard is designed to:

1.  Provide **real-time, structured** branch performance data, covering daily, weekly, monthly, quarterly, and yearly views.
2.  Enable management and branch teams to monitor key KPIs **quickly, accurately, and consistently**, without the need for manual calculations.
3.  Accelerate analysis and decision-making processes, allowing teams to focus on developing action plans and executing the PDCA cycle more effectively.
4.  Serve as a **pilot project** and reference model before the system is scaled and implemented across the remaining **15 branches**.

---

## Tools & Technology

A set of modern data tools was used to ensure automated processing, accurate calculations, and scalable reporting:

-   **PostgreSQL** → Serves as the main data warehouse for storing branch-level operational data, running SQL queries, and performing data transformation processes.
-   **Power BI** → Used to build interactive dashboards, visualize KPI trends, and present **real-time** performance insights for management and branch teams.

---

## Data Flow and Architecture

The system involves structured data flow from the source systems to the visualization layer, covering **Data Collection**, **Database Storage**, **Data Processing (SQL Transformation)**, and **Data Visualization**.

### 1. Data Collection & Source Tables
Data was collected from various internal branch systems. Key tables used include:
* `tb_spp_25` & `tb_spp_24`: Work Order (Unit Entry) data
* `tb_target`: Unit Entry target data
* `tb_rev_25` & `tb_rev_24`: Service & Sparepart revenue data
* `tb_ss_25`, `tb_as_25`, `tb_epk_25`: Detailed service activity, recommendation, and lead time data
* `tb_ring`, `tb_foa`, `tb_job`: Segmentation and classification data (Ring Area, FOA, Job Type: CPUS/SBE/GR)

### 2. Database Storage (PostgreSQL Design)
All data is stored in PostgreSQL. The database is designed with a modular architecture:
* **Raw Data Layer** – Direct extracts from operational systems.
* **Cleaned Data Layer** – Processed and validated data (e.g., using `DISTINCT ON` to clean `tb_promo_clean`, `tb_ring_clean`).
* **Summary Layer** – Aggregated and pre-calculated datasets optimized for dashboard consumption, produced after SQL transformation.

### 3. Data Processing (SQL Transformation)
Data transformation was performed using SQL in PostgreSQL, resulting in the core datasets (`tb_dashboard_25`, `tb_revenue_25`, etc.)

* **Data Cleaning:** Applied `DISTINCT ON` to ensure unique and consistent data to prevent metric inflation during joins.
* **Data Transformation:** Key operations include **Table Joining (LEFT JOIN)** (e.g., joining `tb_spp_25` with `tb_job`, `tb_foa`, and `tb_target`) and **Variable Creation (CASE WHEN)** to classify data (e.g., Booking vs Non-Booking, Fleet vs Retail). Used `COALESCE()` for missing value handling.
* **Feature Engineering:** Created additional features like time-based dimensions, MRA contribution calculation, and applying **Window Functions** (`ROW_NUMBER()`) partitioned by Nomor SPP to ensure only the latest record is used.

### 4. Data Visualization (Power BI Dashboard)
The dashboard was developed in Power BI using **DirectQuery** to PostgreSQL, ensuring real-time data display.

It presents several key operational metrics:
* Performance Achievement (Actual vs Target and Year-over-Year comparison)
* Unit Entry Composition (CPUS, Non-CPUS, SBE, GR)
* Technician & Service Advisor Productivity
* Customer Segmentation (Retail vs Fleet, Ring Area)
* MRA Activity and Contribution

The dashboard includes interactive filters (date, Service Advisor, service type) for flexible daily, weekly, monthly, and annual analysis.

---

## Results & Insight

The implementation of the Performance Monitoring Dashboard significantly improved efficiency by automating the performance recap process.

**Implementation Results (Semester 1 2025):**

| Category | Achievement vs Target | Achievement vs 2024 (Y-o-Y) |
| :--- | :--- | :--- |
| **Unit Entry Overall** | 92.7% | 94.4% |
| **CPUS (Core Focus)** | 96.5% | 103.9% |
| **SBE (Periodic)** | 95% | 104% |
| **GR (General Repair)** | 101% | 105% |

**Key Insights:**

* Unit Entry is dominated by **CPUS (90.49%)**, making it the primary focus for revenue analysis.
* The primary factor causing the branch's overall performance to fall short of the target is **SBE (Periodic Maintenance)**, which contributes the largest volume within CPUS but achieved only **95%** of the target.
* The dashboard facilitates **multidimensional analysis** (*e.g.*, MRA contribution, Ring Area, Retail vs Fleet segmentation) to pinpoint the root causes of SBE's underperformance.
* This approach enables the Service Manager to design a **data-driven** and **effective action plan** for the PDCA cycle.

With this system, daily performance calculations are **automated** and **accurate**, allowing the team to shift focus from administrative tasks to **decision-making and action execution**.

---

## Project Achievements

The **Performance Monitoring Dashboard** served as a successful Pilot Project at Astrido Bitung.

This project has successfully achieved the following:

-   Significant reduction in the Service Manager's workload for daily performance calculation.
-   Acceleration of the analysis and PDCA decision-making cycle.
-   Became the **Reference Model** approved for **replication (*Yokoten*)** across the entire **15-branch Astrido Toyota network**.
-   Demonstrated the effectiveness of the **PostgreSQL + Power BI** stack for scalable performance monitoring at the branch level.

---

## Key Learnings

### Technical Learnings
-   The importance of building a **clean and well-structured database** from the beginning to ensure stable `JOIN` operations and prevent data anomalies.
-   Utilizing **CTEs** and **Window Functions** (`ROW_NUMBER`) in SQL is highly effective for generating consistent summary tables required for DirectQuery.
-   Realized that Power BI performance is highly dependent on efficient **preprocessing and design of summary tables** in PostgreSQL.

### Analytical Learnings
-   Understanding how to evaluate branch performance by focusing on the most impactful KPIs (**CPUS $\rightarrow$ SBE/GR**) to direct the analysis toward the main revenue drivers.
-   Learning to interpret data across multiple dimensions (Ring Area, MRA contribution, Retail vs Fleet) to identify the true root causes behind performance gaps.

### Business Learnings
-   Automating calculations allows the Service Manager to focus on **decision-making and PDCA** instead of administrative tasks.
-   An effective dashboard must directly answer business questions, be easy to understand, and be relevant for operational teams.
-   Recognizing the value of building **scalable and standardized solutions** that can be easily replicated across the entire dealer network.
