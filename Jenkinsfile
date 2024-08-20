pipeline {

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    } 
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

   agent  any
    stages {
        stage('checkout') {
            steps {
                 script{
                        dir("gitjenkins")
                        {
                            git "https://github.com/yeshwanthlm/Terraform-Jenkins.git"
                        }
                    }
                }
            }
    stages {
        stage('Plan') {
            steps {
                sh 'pwd;cd C:/Users/ashis/OneDrive/Documents/terraform/ecswithjenkins ; terraform init'
                sh "pwd;cd C:/Users/ashis/OneDrive/Documents/terraform/ecswithjenkins ; terraform plan -out tfplan"
                sh 'pwd;cd C:/Users/ashis/OneDrive/Documents/terraform/ecswithjenkins ; terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
           }

           steps {
               script {
                    def plan = readFile 'C:/Users/ashis/OneDrive/Documents/terraform/ecswithjenkins/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            steps {
                sh "pwd;cd C:/Users/ashis/OneDrive/Documents/terraform/ecswithjenkins ; terraform apply -input=false tfplan"
            }
        }
    }

  }
