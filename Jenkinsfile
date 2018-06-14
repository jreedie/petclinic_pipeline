pipeline {
  agent {
      dockerfile {
      args '-v /root/.m2:/root/.m2'
      }
  }
  stages {
    stage('Build') {
      agent {
        dockerfile {
        args '-v /root/.m2:/root/.m2'
        }
      }
      steps {
        sh 'echo $PATH'
        sh 'mvn -B -DskipTests clean package'
      }
    }
    stage('Test') {
      agent {
        dockerfile {
        args '-v /root/.m2:/root/.m2'
        }
      }
      steps {
        sh 'cd cucumber_resources; gradle cucumber'
      }

      post {
        always{
          cucumber '**/target/*.json'
        }
      }

    }

  }
}