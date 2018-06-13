pipeline {
  agent {
      dockerfile {
      args '-v /root/.m2:/root/.m2'
      }
  }
  stages {
    stage('Build') {
      steps {
        sh 'mvn -B -DskipTests clean package'
      }
    }
    stage('Test') {
      steps {
        sh 'ls'
        sh 'cd cucumber_resources'
        sh 'ls'
        sh 'mvn test'
      }


    }

  }
}