pipeline {
  agent {
        dockerfile {
        args '''-v /root/.m2:/root/.m2
                --network host
      	'''
      }
  }          
  
  stages {
  	stage('detect vault server check'){
  		steps{
  			sh 'curl http://127.0.0.1:8200/v1/sys/init'
  		}
  	}

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