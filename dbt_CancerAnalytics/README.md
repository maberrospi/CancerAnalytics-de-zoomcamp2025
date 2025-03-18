# Explanation of dbt models

![DbtLineage](/images/dbt_diagram.png)

> [!Info]
> Information about the models can also be viewed using dbt docs. To generate docs run `dbt docs generate` followed by `dbt docs serve`. This is possible through the dbt core CLI.

The transformations are divided in two layers, staging and core. The staging layer includes two resources. The `stg_cancer_data` table which is generated from the raw data and contains the necessary fields for later analysis as well as a `locations_regions` seed table which maps the countries/locations to their respective region. The layer schemas contain additional information of each model in the model description. 

> [!Note]
> In this particular case with the amount of data present following a wide table approach may be enough. However, I followed a dimensional modelling approach to reinforce the concepts learned during the bootcamp. Following a star schema design offers efficient storage of data, history maintainance, and data updates by reducing the duplication of repetitive definitions, making it fast to aggregate and filter data in the data warehouse. In addition, a star schema can adapt well to fit OLAP models.

The core layer divides the staging table so that it follows Kimball's Dimensional Modelling concepts and the Star Schema principle. As such the central fact table `fct_cancer_data` contains cancer facts (e.g. Number of Deaths caused by Prostate cancer in a given year, sex etc.). The table is partitioned by year since it is likely to be used as a filter during analyses. This fact tables is connected to four dimension tables `dim_cause`, `dim_location`, `dim_measure` and `dim_sex`.

Lastly, the core layer includes three models which were used for the visualizations. The `fct_cancer_agg_sdi` model aggregates the number of a given measure (Deaths, Dalys etc.) per year and Sociodemographic Index (SDI) as well as calculates the percentage based on the total number. It is partitioned by year as it is used as a filter during the corresponding analysis. The `fct_cancer_by_region` model offers a similar aggregation per region and is also partitioned in a similar way. Lastly, the `fct_cancer_with_percent` model calculates the percentage of a given measure for a specific cause (Cancer type) with respect to the year, location and sex. This model is partitioned by year and clustered by location and cause since the analysis filters data using these fields. 

> [!Note]
> While the amount of data may not be enough for queries to benefit from partitioning and clustering, these were maintained as part of understanding these optimization processes and employing best practices.

> [!Tip]
> It is important to nota that the staging, fact and dimensional models are not incremental. This means the tables will be rebuilt every time we run the models. If we plan to ingest data in specific intervals (e.g. each day) then these models should use the 'Incremental' table configuration. For the purpose of this project using a table configuration is enough.