pipeline {
  agent {
        dockerfile {
        args '''-v /root/.m2:/root/.m2
                --network host
      	'''
      }
  }          
  
  stages {
  	stage('vault testing'){
  		steps{
  			withCredentials([
                string(credentialsId: 'role', variable: 'ROLE_ID'),
                string(credentialsId:'vault-token', variable: 'VAULT_TOKEN')
            ]) {
                sh '''
                    cd ~/
                    ls
                    export VAULT_ADDR='http://127.0.0.1:8200'
                    vault login ${VAULT_TOKEN}
                    export SECRET_ID=$(./vault write -field=secret_id -f auth/approle/role/vault-test/secret-id)
                    export TEMP_TOKEN=$(./vault write -field=token auth/approle/login role_id=${ROLE_ID} secret_id=${SECRET_ID})
                    vault login ${TEMP_TOKEN}
                    vault kv get -field=test secret/hello                    

                '''
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