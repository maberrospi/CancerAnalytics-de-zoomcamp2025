# Cancer Analytics - Data Engineering Project
## Overview
The goal of this project is to apply Data Engineering (DE) concepts learned throughout the DE Zoomcamp 2025. In particular, the project uses the Extrac-Load-Transform (ELT) philosophy, where the data is extracted, loaded into a Data Warehouse and then transformed within the Data Warehouse. The alternative would be to use an Extract-Transform-Load (ETL) process where the data is transformed before being loaded. The transformed data is then used to generate informative visualizations. This project aim is to develop a workflow to ingest and process global cancer data for downstream analysis.

## Pipeline Technologies and Data

![TechnologiesUsed](/images/TechDiagram.jpeg)
This diagram was built using [Lucidchart](https://lucid.co)

In a short summary the data was extracted from the results of the Global Burden of Disease 2021 (GBD) study by the Institute of Health Metrics and Evaluation (IHME). The GBD study is the largest and most comprehensive effort to quantify health loss across places and over time, so health systems can be improved and disparities eliminated. The data includes data for multiple types of diseases. This work focuses on Cancer (Neoplasms) and the project aims to add to the already extensive analysis of the GBD study, by offering insight to a specific type of disease. Registering with their website is needed to access the data and extract it through the GBD Results tool as CSV. The extracted data includes the GBD results between 1980 and 2021 for Cancer cases.

The extracted data was then uploaded to Google Cloud Platform (GCP) in Google Cloud Storage (GCS) and afterwards moved to BigQuery. Subsequently, the data was transformed using dbt and visualized using Google Looker Studio. The ingestion process is  orchestrated using Kestra which is deployed on a Docker image using docker-compose. The GCP infrastruscture mentioned is deployed using Terraform.

## Data Ingestion

The data was first downloaded to the local machine in a manual fashion as this was the only option within the GBD Results Tool. The extraction consisted of several zipped CSV files. The next step executes the Kestra injestion flow. This flow unzips the file, uploads it to GCS, generates the raw data table in BigQuery and an external table with the current data, and finally merges the current data making sure no duplicate rows are added.

The injestion flow was executed multiple times to ingest all the zipped csv files. In the future this can be improved by using Kestra triggers allowing to backfill data from multiple files with one execution. Additionally, since the data is not updated at specific time intervals, the flow is not set to run at specific times. 

## Data Warehouse

Google BigQuery is used as the Data Warehouse. Most tables are generated during the Transformation stage using dbt and are explained in the respective section. After data ingestion, the BigQuery dataset contains one table with the 'raw' ingested data.

## Transformations

Data transformations are performed using dbt core. Luckily, the raw data has a very good quality and does not need intense work. Nevertheless, in the spirit of learning, the data is transformed using dimensional modelling concepts. The models are developed using a star-schema, with the central fact table being the 'fct_cancer_data.sql'. The lineage is displayed below. More information about the models is provided in the [dbt project directory](/dbt_CancerAnalytics/).

![DbtLineage](/images/dbt_diagram.png)

## Dashboard/Visualization

The report generated in Google Looker Studio consists of three pages. Each page can be considered as a dashboard. The report is available on [Looker Studio Cancer Analytics](https://lookerstudio.google.com/reporting/9c2e170f-07a1-4840-865f-50180cfaa0f5)

The first dashboard presents a visualization of the distribution of a specific measure (e.g. Deaths) for a given year on a region level. For the remaining examples I will refer to the measure as Deaths for simplicity. The graph on the bottom presents the number of deaths over time for chosen locations, sex and cancer type. There is also an option to view the percentage value instead of the number by hovering over the graph.

![Dashboard1](/images/Dash1.gif)

The second dashboard has similar visualizations. The upper graph represents the distribution of deaths for a given year based on the Sociodemographic Index (SDI). For reference, SDI is a measure that identifies where countries or other geographic areas sit on the spectrum of development. It is expressed on a scale of 0 to 100, with 0 being the lowest SDI value and 100 being the highest. The lower graph presents the number of deaths for the distinct SDIs over time.

![Dashboard1](/images/Dash2.gif)

The third and finall dashboard highlights the top 10 cancer types for a chosen country and sex over time. While these are somewhat simple models and visualizations, this project highlights the importance of data and data engineering and how data analytics enables us to answer questions and solve problems.

![Dashboard1](/images/Dash3.gif)

## Steps to reproduce 

> [!IMPORTANT]
> Modify the variables appropriately for GCP Project ID, BigQuery Bucket and Dataset names, GCP location and GCP credentials wherever applicable, to reflect your own project, infrastructure and credentials.


### Step 1 - Create project in GCP

1. Create a service account with Storage Admin and BigQuery Admin permissions
2. Generate google key.json and download it
3. Enable BigQuery API for the project

### Step 2 - Configure Terraform

1. Create `main.tf` and `variables.tf` files
	1. The files include the generation of a GCS Bucket and a BigQuery Dataset
2. Run `terraform init` in the project directory
3. Run `terraform plan` to view the proposed actions defined in `main.tf`
4. Run `terraform apply`  to execute the actions

### Step 3 - Prepare ingestion data

* Option 1: Register in the GBD website and download data from the results tool. Make sure to filter the data so that
    1. Download cancer data (Neoplasms) as Cause, choose 'all countries and teritorries' as location, All ages, choose all the sexes, all the years, set metric as Number and finally choose Deaths, DALYs, Incidence and Prevalence as Measures.
* Option 2: Alternatively, a single zipped CSV file with some data is provided in [ExData](/ExData/) as an easier way to get it up and running. Note that this method will result in less data that what was used and perhaps unexpected behavior later on.


### Step 4 - Setup Kestra and Ingest

1. Create a docker compose file that spins up a Kestra container and a postgress container so that the Kestra flows are stored and maintained between sessions
    1. Rename 'ExData' to 'Data' or create directory to store the zipped csv files.   
	2. The compose file includes a Volume connecting the Data directory from the local machine to the container for easy access to the data from Kestra.
	3. Run `docker compose build` followed by `docker compose up` to run the containers.
2. Use flow 'zoomcamp_cance_gcp_kv.yaml' to generate Key Value pairs in Kestra Namespaces.
	1. Flow adds KV pairs for Dataset name, Project ID, Bucket name and GCP location. GCP Credentials can be added manually using the Kestra UI.
3. Run the ingestion flow
	1. Includes unzipping the folders and uploading the csv files to the GCS bucket and to a BigQuery table.
	2. Note: The 'in_file' and 'out_file' should be changed appropriately to point to the correct data. The files should be located in the 'Data' directory since it is the Volume connecting the data to the docker container. 


### Step 5 - Build dbt models

* Option 1 - Run Kestra dbt flow (Recommended):
	1. Run the `dbt_build_all.yaml` flow within the Kestra UI.

* Option 2 - Setup dbt core and Build models:
	1. Follow the [dbt guide](https://docs.getdbt.com/guides/manual-install?step=1) to install and setup dbt core.
		1. Note: This includes creating a virtual environment where dbt core is installed as well as connecting to BigQuery.
	2. Use `dbt build` to run the rest of the models.

The new tables should be created in BigQuery.



## Future improvements
* Ingest data through API (If possible in the future) to avoid manual ingestion tasks.
* Generate more complex analytics and dbt models utilizing window functions for additional insights.