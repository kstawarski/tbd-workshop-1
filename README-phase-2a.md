IMPORTANT ❗ ❗ ❗ Please remember to destroy all the resources after each work session. You can recreate infrastructure by creating new PR and merging it to master.

![img.png](doc/figures/destroy.png)

0. The goal of this phase is to create infrastructure, perform benchmarking/scalability tests of sample three-tier lakehouse solution and analyze the results using:
* [TPC-DI benchmark](https://www.tpc.org/tpcdi/)
* [dbt - data transformation tool](https://www.getdbt.com/)
* [GCP Composer - managed Apache Airflow](https://cloud.google.com/composer?hl=pl)
* [GCP Dataproc - managed Apache Spark](https://spark.apache.org/)
* [GCP Vertex AI Workbench - managed JupyterLab](https://cloud.google.com/vertex-ai-notebooks?hl=pl)

Worth to read:
* https://docs.getdbt.com/docs/introduction
* https://airflow.apache.org/docs/apache-airflow/stable/index.html
* https://spark.apache.org/docs/latest/api/python/index.html
* https://medium.com/snowflake/loading-the-tpc-di-benchmark-dataset-into-snowflake-96011e2c26cf
* https://www.databricks.com/blog/2023/04/14/how-we-performed-etl-one-billion-records-under-1-delta-live-tables.html

2. Authors:

   Z11

   https://github.com/kstawarski/tbd-workshop-1

3. Sync your repo with https://github.com/bdg-tbd/tbd-workshop-1.

4. Provision your infrastructure.

    a) setup Vertex AI Workbench `pyspark` kernel as described in point [8](https://github.com/bdg-tbd/tbd-workshop-1/tree/v1.0.32#project-setup)

    b) upload [tpc-di-setup.ipynb](https://github.com/bdg-tbd/tbd-workshop-1/blob/v1.0.36/notebooks/tpc-di-setup.ipynb) to
the running instance of your Vertex AI Workbench

5. In `tpc-di-setup.ipynb` modify cell under section ***Clone tbd-tpc-di repo***:

   a)first, fork https://github.com/mwiewior/tbd-tpc-di.git to your github organization.

   b)create new branch (e.g. 'notebook') in your fork of tbd-tpc-di and modify profiles.yaml by commenting following lines:
   ```
        #"spark.driver.port": "30000"
        #"spark.blockManager.port": "30001"
        #"spark.driver.host": "10.11.0.5"  #FIXME: Result of the command (kubectl get nodes -o json |  jq -r '.items[0].status.addresses[0].address')
        #"spark.driver.bindAddress": "0.0.0.0"
   ```
   This lines are required to run dbt on airflow but have to be commented while running dbt in notebook.

   c)update git clone command to point to ***your fork***.




6. Access Vertex AI Workbench and run cell by cell notebook `tpc-di-setup.ipynb`.

    a) in the first cell of the notebook replace: `%env DATA_BUCKET=tbd-2023z-9910-data` with your data bucket.


   b) in the cell:
         ```%%bash
         mkdir -p git && cd git
         git clone https://github.com/mwiewior/tbd-tpc-di.git
         cd tbd-tpc-di
         git pull
         ```
      replace repo with your fork. Next checkout to 'notebook' branch.

    c) after running first cells your fork of `tbd-tpc-di` repository will be cloned into Vertex AI  enviroment (see git folder).

    d) take a look on `git/tbd-tpc-di/profiles.yaml`. This file includes Spark parameters that can be changed if you need to increase the number of executors and
  ```
   server_side_parameters:
       "spark.driver.memory": "2g"
       "spark.executor.memory": "4g"
       "spark.executor.instances": "2"
       "spark.hadoop.hive.metastore.warehouse.dir": "hdfs:///user/hive/warehouse/"
  ```


7. Explore files created by generator and describe them, including format, content, total size.

   The following files were generated:

   ![img.png](doc/figures/workshop2a_task7_all_files.png)

   Generated files are grouped into 3 batches. They have the following sizes:

   ![img.png](doc/figures/workshop2a_task7_file_sizes.png)

   The first batch contains transaction data grouped per quarter in pairs:
   the first file (without extension) contains the actual data delimited by tabulation,
   while the one with the \_audit.csv suffix contains the column names for the data.

   There are also files describing and containing smaller amounts of data (in .csv and .txt format),
   that are also not grouped by time chunks, but by their topic.

   The second and third batches are similar in that they contain much less data than the first batch.
   They lack the transaction data present in the first batch.
   Otherwise, they contain the same files.

8. Analyze tpcdi.py. What happened in the loading stage?

   First, the script created a Spark session.
   Then, data generated in the previous step, was loaded into Spark DataFrames (one per file) and given the appropriate schema.
   Afterwards that data was uploaded to our gcs bucket to prepare it for processing in Dataproc.

   ![img.png](doc/figures/workshop2a_task8_bucket.png)

9. Using SparkSQL answer: how many table were created in each layer?

   ![img.png](doc/figures/workshop2a_task9_output.png)

10. Add some 3 more [dbt tests](https://docs.getdbt.com/docs/build/tests) and explain what you are testing. ***Add new tests to your repository.***

   I. Tests whether there are any duplicates in accounts.

   ```
   select
       sk_account_id,
       count(*) cnt
   from {{ ref('dim_account') }}
   group by sk_account_id
   having cnt > 1
   ```

   II. Tests whether there are any transactions that were processed before they were placed.

   ```
   select *
   from {{ ref('fact_watches') }}
   where sk_date_placed > sk_date_removed
   ```

   III. Tests whether there are any transactions with their amount lower than 0.

   ```
   select *
   from {{ source('brokerage', 'cash_transaction') }}
   WHERE ct_amt < 0
   ```

11. In main.tf update
   ```
   dbt_git_repo            = "https://github.com/mwiewior/tbd-tpc-di.git"
   dbt_git_repo_branch     = "main"
   ```
   so dbt_git_repo points to your fork of tbd-tpc-di.

12. Redeploy infrastructure and check if the DAG finished with no errors:

   ![img.png](doc/figures/workshop2a_task12_airflow.png)
