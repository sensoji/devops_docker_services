// Vars
def derverip
def username = "ubuntu"

// pipeline
pipeline {
    agent any
    //triggers {}
    parameters {
        choice( name: 'ACTION', 
                choices:['plan', 'apply', 'destroy'], 
                description: 'Run terraform plan / apply / destroy')
        // choice( name: 'CONFIG',
        //         choices: ['No', 'Yes']
        //         description: 'Run Ansible config scripts')
    }
    stages {
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
            }
            script {
                serverip = sh (
                    script: 'terraform output webserver_ip'
                )
            echo "The server IP is ${serverip}"
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
        // stage ('Ansible - Configure') {
        //     when {
        //         expression {
        //             params.CONFIG == 'Yes'
        //         }
        //     }
        //     steps {
        //         dir('ansible') {
        //             sh """
        //             rm -f hosts
        //             """
        //         }
        //     }
        // }
    }
}