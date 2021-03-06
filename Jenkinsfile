// Vars
def serverip
def username = "ubuntu"

// pipeline
pipeline {
    agent any
    //triggers {}
    parameters {
        choice( name: 'ACTION', 
                choices:['plan', 'apply', 'destroy'], 
                description: 'Run terraform plan / apply / destroy')
        choice( name: 'CONFIG',
                choices: ['No', 'Yes'],
                description: 'Run Ansible config scripts')
    }
    stages {
        stage ('Terraform - Plan') {
            when {
                expression {
                    params.ACTION == 'plan'
                }
            }
            steps {
                dir('terraform') {
                    sh """
                    terraform init
                    terraform plan
                    """
                }
            }
        }
        stage ('Terraform - Apply') {
            when {
                expression {
                    params.ACTION == 'apply'
                }
            }
            steps {
                dir('terraform') {
                    sh """
                    terraform init
                    terraform apply --auto-approve
                    """
                }
                script {
                    dir('terraform'){
                        serverip = sh(
                            script: 'terraform output -raw webserver_ip',
                            returnStdout: true)
                    }
                echo "The server IP is ${serverip}"
                }
            }
        }
        stage ('Terraform - Destroy') {
            when {
                expression {
                    params.ACTION == 'destroy'
                }
            }
            steps {
                dir('terraform') {
                    sh """
                    terraform destroy --auto-approve
                    """
                }
            }
        }
        stage ('Ansible - Configure') {
            when {
                expression {
                    params.CONFIG == 'Yes'
                }
            }
            steps {
                dir('ansible') {
                    sh """
                    rm -f hosts
                    echo "[webserver]\n ${serverip}" > hosts
                    while ! nc -z -w 5 ${serverip} 22; do echo "Waiting for server..."; sleep 5; done
                    ansible-playbook -i hosts deploy.yaml
                    """
                }
            }
        }
    }
}