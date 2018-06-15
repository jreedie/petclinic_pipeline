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
        sh 'cd cucumber_resources; gradle cucumber'
      }

      post {
        always{
          cucumber '**/target/*.json'
          emailext(
            subject: "Build ${currentBuild.fullDisplayName} status: ${BUILD_STATUS}"
            body: "View full results here: ${BUILD_URL}"
            recepientProviders: [[$class: 'DevelopersRecipientProver']]
          )
        }

      }
    }
  }
}