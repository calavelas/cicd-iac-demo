CICD IAC DEMO
============================
### What is this repository
- This is a demo repository for a simple node application deployment based on docker-compose.
- The integration of this repository is not fully complete yet, as the CICD part is in progress (not in scope of the test).
- The Graphite Dashboard can be accessed through the internet via this URL: http://35.240.221.73/?showTarget=stats.timers.test.core.delay.std&width=586&height=308&target=stats.timers.test.core.delay.std&from=-60minutes
- GCP IAM and Project access will be granted upon request.

### Repository Folder Structure
    .
    ├── ...
    ├── deployment              	# Deployment Folder
    │   ├── docker-compose.yaml 	# docker-compose file for packing deployment
    ├── src                     	# Application Source Code Folder
    │   ├── index.js            	# Node application
    │   ├── dockerfile              # Dockerfile for building containenr
    ├── terraform               	# IAC script to create Infrastructure using Terraform
    │   ├── main.tf             	# Terraform configuration file
    │   ├── gcp-sa.json         	# GCP Service Account file, Excluded by .gitignore
    └── ...

### Suggested Improvement
- I updated index.js to use the metricsServerHost environment variable instead of localhost. This will provide flexibility to use this container in multiple environments and be able to change metricsServerHost according to the environment.
- While this deployment via docker compose is easy to set up in a dev environment, it's not a best practice for a production environment. I suggest using Kubernetes or serverless options like Cloud Run and using cloud-managed metric collectors to collect these metrics instead.
- By using Kubernetes, we will have better application deployment methodologies by default (K8s deployment is better than docker compose).
- The VM instance is currently using an ephemeral IP address, which is not suitable for a production setup.
- Accessing the Graphite dashboard via the HTTP port and public IP address poses a significant security risk. This is just a quick demonstration. In a production setup, I prefer setting up a permanent IP address and registering it. Then, using a load balancer or reverse proxy to set up TLS.
- While running Terraform scripts with a local state is good for setting up a quick environment, it's okay if I'm working alone. But for production or when multiple people access the repository, it should be set up with remote state or using managed Terraform cloud instead.
- For further CI/CD setup, I plan to configure the pipeline to build images upon detecting changes in the src/** directory and push these images to Docker Hub. Then, it will update the docker-compose file.
- For the CD part of the CI/CD, I will ensure that the pipeline checks for any updates in the docker-compose.yaml file. It will then connect to a Compute Engine instance via gcloud ssh and restart the docker-compose setup.
- For Terraform and IaC (Infrastructure as Code) pipelines, I will add the Service Account (SA) file to the repository's secrets. The pipeline will be configured to run terraform init, plan, and apply upon detecting changes in the main.tf file.
- All CI/CD pipelines should be triggered when creating a merge request to the main branch and should not allow direct pushes to the main branch. This is to prevent accidental changes in deployment and IaC provisioning.