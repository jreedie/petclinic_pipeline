pipeline {
    agent {
        dockerfile {
        args '''
                -v /root/.m2:/root/.m2
                --network host
      	'''
        }
    }          
  
  stages {
  	stage('vault testing'){
  		steps{
  			withCredentials([
                string(credentialsId:'vault-token', variable: 'VAULT_INIT_TOKEN')
            ]) {
                ssh "${VAULT_INIT_TOKEN}"   
                sh 'cat ~/output.txt'
                sh 'rm ~/output.txt'
                ssh 'af625cbf-1a54-fc57-19d4-28ee49293e12'
                sh 'cat ~/output.txt'
                sh 'rm ~/output.txt'
            }
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