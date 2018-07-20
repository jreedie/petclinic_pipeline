pipeline {
    agent { label 'linux-pod' }          
  
  stages {
  	
    stage('ACI test'){
        steps{
            sh 'mvn --version'
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