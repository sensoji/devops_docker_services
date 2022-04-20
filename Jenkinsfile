// Vars
def derverip
def username = "ubuntu"

// pipeline
pipeline {
    agent any
    triggers {}
    parameters {
        choice( name: 'ACTION', 
                choices:['plan', 'apply', 'destroy'], 
                description: 'Run terraform plan / apply / destroy')
    }
    stages {
        stage ('Terraform - Apply') {
            when {
                expression {
                    params.ACTION == 'apply'
                }
            }
            steps {
                dir('terraform')
                sh """
                terraform init
                terraform apply --auto-approve
                """
            }
        }
        stage ('Terraform - Destroy') {
            when {
                expression {
                    params.ACTION == 'destroy'
                }
            }
            steps {
                dir('terraform')
                sh """
                terraform destroy --auto-approve
                """
            }
        }
    }
}