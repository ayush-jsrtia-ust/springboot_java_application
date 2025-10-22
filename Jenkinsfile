
@Library('my-shared-library') _

pipeline{

    agent any
    
    
    parameters{

        choice(name: 'action' , choices: 'create\ndelete', description: 'choose action to perform')
    }
        

            
        stages{

            stage('Git Checkout'){
                when{expression { params.action == 'create' }}
                   
            steps{
            gitCheckout(
                branch: "main",
                url: "https://github.com/will-chrizt/springboot_java_application.git"
            )
            }
            }
            stage('unit test maven'){
                when{expression { params.action == 'create' }}
                steps{
                   script{
                       mvnTest()
               }       
            }
            }
            stage('mvn integration test'){
                when{expression { params.action == 'create' }}
                steps{
                    script{
                        mvnIntegrationTest()
                    }
                }
            }

            stage('static code analysis: sonarqube'){
                when{expression { params.action == 'create' }}
                steps{
                    script{
                        def ZSonarQubecredentialId = 'sonar-server'
                        statiCodeAnalysis(ZSonarQubecredentialId)

                    }
                }
            }
        }
}

            