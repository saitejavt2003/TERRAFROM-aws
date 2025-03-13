pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'autoDestroy', defaultValue: false, description: 'Automatically run destroy after apply?')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    agent any
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/saitejavt2003/TERRAFROM-aws.git'
            }
        }
        stage('Plan') {
            steps {
                dir('terraform') {
                    bat 'terraform init'
                    bat 'terraform plan -out tfplan'
                    bat 'terraform show -no-color tfplan > tfplan.txt'
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
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                          parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }
        stage('Apply') {
            steps {
                dir('terraform') {
                    bat 'terraform apply -input=false tfplan'
                }
            }
        }
        stage('Approval for Destroy') {
            when {
                not {
                    equals expected: true, actual: params.autoDestroy
                }
            }
            steps {
                input message: "Do you want to destroy the resources?"
            }
        }
        stage('Destroy') {
            steps {
                dir('terraform') {
                    bat 'terraform destroy -auto-approve'
                }
            }
        }
    }
}