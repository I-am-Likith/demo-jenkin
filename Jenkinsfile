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
                        dir("C:/Users/ashis/OneDrive/Documents/terraform/demo-jenkin")
                        {
                            git "https://github.com/I-am-Likith/demo-jenkin.git"
                        }
                    }
                }
            }

        stage('Plan') {
            steps {
                bat 'cd C:/Users/ashis/OneDrive/Documents/terraform/demo-jenkin && terraform init'
                bat 'cd C:/Users/ashis/OneDrive/Documents/terraform/demo-jenkin && terraform plan -out=tfplan'
                bat 'cd C:/Users/ashis/OneDrive/Documents/terraform/demo-jenkin && terraform show -no-color tfplan > tfplan.txt'
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
                    def plan = readFile 'C:/Users/ashis/OneDrive/Documents/terraform/demo-jenkin/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            steps {
                bat "cd C:/Users/ashis/OneDrive/Documents/terraform/demo-jenkin/ && terraform apply -input=false tfplan"
            }
        }
    }

  }
