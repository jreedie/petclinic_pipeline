pipeline {
    agent { 
        dockerfile{
            args '''
                --network host
            '''
        }
    }
    stages {
  	
        stage('Deploy Cluster') {
            steps{
                withCredentials([string(credentialsId: 'vault_token', variable: 'vaultToken')]){
                    sh 'export VAULT_ADDR=http://127.0.0.1:8200; vault status'
                    injectCreds '$vaultToken'
                }
            }
        }

        stage('Build and Sonarqube Analysis'){
            steps{
                withSonarQubeEnv('sonar-pass'){
                    sh 'mvn clean package sonar:sonar'
                }
            }
        }

        stage('Quality Gate') {  
            steps{
                timeout(time: 1, unit: 'HOURS'){
                    waitForQualityGate abortPipeline: true
                }
            }
        }
      
        stage('Test') {
            steps {
                sh 'cd cucumber_resources; gradle cucumber'
            }

            post {
                always{
                    cucumber '**/target/*.json'
                }
                success{
                    emailext(
                        subject: "Build ${currentBuild.fullDisplayName} passed all tests!",
                        body: "Good job! View full results here: ${BUILD_URL}",
                        recipientProviders: [[$class: 'DevelopersRecipientProvider']]
                    )
                }
                failure{
                    emailext(
                        subject: "Build ${currentBuild.fullDisplayName} did not pass all tests",
                        body: "View full results here: ${BUILD_URL}",
                        recipientProviders: [[$class: 'DevelopersRecipientProvider']]
                    )
                }

            }
        }


    }
}