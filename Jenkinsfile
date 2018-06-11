pipeline {
  agent {
    docker {
      image 'maven:3.5.2-jdk-8'
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
        sh 'cd cucumber_resources'
        sh 'mvn compile'
      }

      post {
        always {
          cucumber '**/target/cucumber/json'
        }
      }
    }

  }
}