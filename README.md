# Devops Docker Services

A Devops Jenkins pipeline that creates an AWS webserver and two two docker containers to it.

### Directories:

#### Terraform

The code here creates:

- Key Pair
- Security group for the webserver:
    - Incomming ports 80 and 22
    - All outgoing traffic
- An EC2 instance

#### Ansible

The code here configures:

- Installs Docker
- Installs Docker Compose