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
        }

        success {
          mail to: "${env.GIT_COMMITER_EMAIL}",
            subject: "Build ${currentBuild.fullDisplayName} passed all tests!",
            body: "Good job! View results here ${BUILD_URL}"
        }

        failure {
          mail to: 'reedie@galatea-associates.com',
            subject: "Build ${currentBuild.fullDisplayName} did not pass all tests",
            body: "View results here ${BUILD_URL}"
        }
      }
    }
  }
}