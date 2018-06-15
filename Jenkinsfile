pipeline {
  agent {
      dockerfile {
      args '-v /root/.m2:/root/.m2'
      }
  }
  
  stages {
    stage('Build') {
      steps{
        sh 'mvn -B -DskipTests clean package'
      }
    }
  
    stage('Test') {
      steps {
        dir("/cucumber_resources"){
          sh 'gradle cucumber'
        }
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