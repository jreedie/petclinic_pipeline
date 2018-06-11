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
        sh 'java -cp hellocucumber-tests.jar cuketest.RunCukesTest "--glue" "cucumber_resources/src/test/groovy" "--plugin" "html:target/cucumber" "--plugin" "json:target/cucumber/json" "cucumber_resources/src/test/resources"'
      }

      post {
        always {
          cucumber '**/target/*.json'
        }
      }
    }

  }
}