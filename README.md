# Devops Docker Services

A Devops Jenkins pipeline that creates an AWS webserver and two two docker containers to it.
Two services are created:
- An Api service, written in Python, that serves a json object
- A web service, written in php, that pulls the info from the api

The Jenkinsfile has multiple choices to either plan, apply or destroy the terraform, as well as configure the ansible playbook.

### Directories:

#### Terraform

The code here creates:

- Key Pair
- Security group for the webserver:
    - Incoming ports 80,22,5000,5001
    - All outgoing traffic
- An EC2 instance

#### Ansible

The code here configures:

- Installs Docker
- Installs Docker Compose
- Copies across the docker files as well as the index and api files for the services
- Starts Docker compose in the background