@Library('my-shared-library') _

pipeline{

    agent any

    parameters{

        choice(
            name: 'action',
            choices: 'create\ndelete',
            description: 'Choose create/Destroy'
        )
        string(
            name: 'aws_account_id',
            description: 'AWS Account ID',
            defaultValue: '435951944183'
        )
        string(
            name: 'Region',
            description: 'Region of ECR',
            defaultValue: 'us-west-2'
        )
        string(
            name: 'ECR_REPO_NAME',
            description: 'ECR Repository Name',
            defaultValue: 'ayush_java_env'
        )
    }

    stages{
        
        stage('Git Checkout'){

            when {
                expression { params.action == 'create' }
            }

            steps{

                script{

                    gitCheckout(
                        branch: 'main',
                        url: 'https://github.com/ayush-jsrtia-ust/springboot_java_application.git'
                    )
                }
            }
        }

        stage('Maven Unit Test'){
        
        when {
            expression { params.action == 'create' }
        }

            steps{

                script{

                    mvnTest()
                }
            }
        }

        stage('Maven Integration Test'){

            when {
                expression { params.action == 'create' }
            }

            steps{

                script{

                    mvnIntegration()
                }
            }
        }

        stage('Static Code Analysis: SonarQube'){

            when {
                expression { params.action == 'create' }
            }

            steps{

                script{

                    def SonarQubecredentialsId = 'sonarqube-api'
                    staticCodeAnalysis(SonarQubecredentialsId)
                }
            }
        }

        stage('Quality Gate Status Check: SonarQube'){

            when {
                expression { params.action == 'create' }
            }

            steps{

                script{

                    def SonarQubecredentialsId = 'sonarqube-api'
                    QualityGateStatus(SonarQubecredentialsId)
                }
            }
        }

        stage('Maven Build'){

            when {
                expression { params.action == 'create' }
            }

            steps{

                script{

                    mvnBuild()
                }
            }
        }

        stage('Docker Image Build for ECR'){

            when {
                expression { params.action == 'create' }
            }

            steps{

                script{

                    dockerBuildECR(
                        "${params.aws_account_id}",
                        "${params.Region}",
                        "${params.ECR_REPO_NAME}"
                    )
                }
            }
        }

        stage('Docker Image Scan: Trivy'){

            when {
                expression { params.action == 'create' }
            }

            steps{

                script{

                    dockerImageScanECR(
                        "${params.aws_account_id}",
                        "${params.Region}",
                        "${params.ECR_REPO_NAME}"
                    )
                }
            }
        }

        stage('DockerHub Login and Push'){

            when {
                expression { params.action == 'create' }
            }

            steps{

                script{

                    dockerPushECR(
                        "${params.aws_account_id}",
                        "${params.Region}",
                        "${params.ECR_REPO_NAME}"
                    )
                }
            }
        }

        stage('Docker image cleanup'){

            when {
                expression { params.action == 'create' }
            }

            steps{

                script{

                    dockerImageCleanupECR(
                        "${params.aws_account_id}",
                        "${params.Region}",
                        "${params.ECR_REPO_NAME}"
                    )
                }
            }
        }
    }
}