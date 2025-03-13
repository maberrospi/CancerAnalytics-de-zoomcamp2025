# Cancer Analytics - Data Engineering Project
## Overview
The goal of this project is to apply Data Engineering (DE) concepts learned throughout the DE Zoomcamp 2025. In particular, the project uses the Extrac-Load-Transform (ELT) philosophy, where the data is extracted, loaded into a Data Warehouse and then transformed within the Data Warehouse. The alternative would be to use an Extract-Transform-Load (ETL) process where the data is transformed before being loaded. The transformed data is then used to generate informative visualizations.

## Pipeline Technologies and Data

![TechnologiesUsed](https://github.com/maberrospi/CancerAnalytics-de-zoomcamp2025/tree/main/images/TechDiagram.png)

In a short summary the data was extracted from the results of the Global Burden of Disease 2021 (GBD) study by the Institute of Health Metrics and Evaluation (IHME). The GBD study is the largest and most comprehensive effort to quantify health loss across places and over time, so health systems can be improved and disparities eliminated. The data includes data for multiple types of diseases. This work focuses on Cancer (Neoplasms) and the project aims to add to the already extensive analysis of the GBD study, by offering insight to a specific type of disease. Registering with their website is needed to access the data and extract it through the GBD Results tool as CSV.
The extracted data was then uploaded to Google Cloud Platform (GCP) in Google Cloud Storage (GCS) and afterwards moved to BigQuery. Subsequently, the data was transformed using dbt and visualized using Google Looker Studio. The ingestion process is part of the orchestration process which was set up using Kestra.



