pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    agent any
    stages {
        stage('checkout') {
            steps {
                script {
                    // Print workspace details
                    echo "Workspace: ${env.WORKSPACE}"
                    
                    // Checkout repository
                    dir("s3jenkins") {
                        deleteDir()  // Clean workspace to avoid old files
                        echo "Cloning repository into s3jenkins directory"
                        checkout([$class: 'GitSCM', 
                                  branches: [[name: '*/main']],  // Adjust branch if needed
                                  userRemoteConfigs: [[url: 'https://github.com/I-am-Likith/demo-jenkin.git']]
                        ])
                    }
                }
            }
        }
        stage('Plan') {
            steps {
                dir("s3jenkins") {
                    // Initialize and plan Terraform
                    sh 'terraform init'
                    sh 'terraform plan -out=tfplan'
                    sh 'terraform show -no-color tfplan > tfplan.txt'
                }
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
                    def plan = readFile 's3jenkins/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }
        stage('Apply') {
            steps {
                dir("s3jenkins") {
                    // Apply Terraform plan
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }
    }
}
