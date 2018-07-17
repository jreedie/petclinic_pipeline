pipeline {
    agent {
        dockerfile {
       
        }
    }          
  
  stages {
  	
    stage('sonar'){
        steps{
            withSonarQubeEnv('sonar'){
                sh 'mvn clean package sonar:sonar'
            }
        }
    }

    stage('Build') {
        steps{
            sh 'git show --name-only'
            sh 'mvn -B -DskipTests clean package'
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