IMPORTANT ❗ ❗ ❗ Please remember to destroy all the resources after each work session. You can recreate infrastructure by creating new PR and merging it to master.

![img.png](doc/figures/destroy.png)

1. Authors:

   Z11

   https://github.com/kstawarski/tbd-workshop-1

2. Follow all steps in README.md.

3. Select your project and set budget alerts on 5%, 25%, 50%, 80% of 50$ (in cloud console -> billing -> budget & alerts -> create buget; unclick discounts and promotions&others while creating budget).

  ![img.png](doc/figures/discounts.png)

5. From avaialble Github Actions select and run destroy on main branch.

7. Create new git branch and:
    1. Modify tasks-phase1.md file.

    2. Create PR from this branch to **YOUR** master and merge it to make new release.

    ![img.png](doc/figures/workshop1_task6_release.png)


8. Analyze terraform code. Play with terraform plan, terraform graph to investigate different modules.

    Selected module: jupyter_docker_image

    This module is responsible for building a Jupyter docker image and if the SHA1 sum of the `resources` directory change, it uploads the image to registry.

   ![img.png](doc/figures/workshop1_task7_jupyter_module.png)


9. Reach YARN UI

    Command used:
    `gcloud compute ssh tbd-cluster-m --project=tbd-2024z-318729 --zone=europe-west1-d --tunnel-through-iap -- -L 8088:localhost:8088`
   ![img.png](doc/figures/workshop1_task9_yarn.png)


10. Draw an architecture diagram (e.g. in draw.io) that includes:
    1. VPC topology with service assignment to subnets
    2. Description of the components of service accounts
    3. List of buckets for disposal
    4. Description of network communication (ports, why it is necessary to specify the host for the driver) of Apache Spark running from Vertex AI Workbech

   ![img.png](doc/figures/workshop1_task10_arch.png)
    Since the Driver manages the cluster and handles the communication with the clients that submit jobs, it is necessary to set it explicity so the other nodes will know where to check for jobs to run and where to report the status of a finished job.

11. Create a new PR and add costs by entering the expected consumption into Infracost
For all the resources of type: `google_artifact_registry`, `google_storage_bucket`, `google_service_networking_connection`
create a sample usage profiles and add it to the Infracost task in CI/CD pipeline. Usage file [example](https://github.com/infracost/infracost/blob/master/infracost-usage-example.yml)

   ***place the expected consumption you entered here***

   ***place the screenshot from infracost output here***

11.  Create a BigQuery dataset and an external table using SQL

    ***place the code and output here***

    ***why does ORC not require a table schema?***


12. Start an interactive session from Vertex AI workbench:

    ***place the screenshot of notebook here***

13. Find and correct the error in spark-job.py

    ***describe the cause and how to find the error***

14. Additional tasks using Terraform:

    1. Add support for arbitrary machine types and worker nodes for a Dataproc cluster and JupyterLab instance

    ***place the link to the modified file and inserted terraform code***

    3. Add support for preemptible/spot instances in a Dataproc cluster

    ***place the link to the modified file and inserted terraform code***

    3. Perform additional hardening of Jupyterlab environment, i.e. disable sudo access and enable secure boot

    ***place the link to the modified file and inserted terraform code***

    4. (Optional) Get access to Apache Spark WebUI

    ***place the link to the modified file and inserted terraform code***
