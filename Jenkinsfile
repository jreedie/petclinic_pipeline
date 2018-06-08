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
        sh 'java -jar /home/GitHub/petclinic_pipeline/hellocucumber-1.0.0-SNAPSHOT.jar'
      }

      post {
        always {
          junit 'target/surefire-reports/*.xml'
        }
      }
    }

  }
}