pipeline {
         
  
    stages {
  	
        stage('Deploy Cluster') {
            agent{
                dockerfile{
                    filename 'Dockerfile-terra'
                }
            }
            steps{
                withCredentials([string(credentialsId: 'client_id', variable: 'clientID'), string(credentialsId: 'client_secret', variable: 'clientSecret'), 
                string(credentialsId: 'tenant_id', variable: 'tenantID')]){
                    sh "az login --service-principal -u $clientID -p $clientSecret --tenant $tenantID"
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve -var-file=k8s.tfvars'
                    sh 'ls _ouptut'
                }
            }
        }

        stage('Build and Sonarqube Analysis'){
            agent { dockerfile true }  
            steps{
                withSonarQubeEnv('sonar-pass'){
                    sh 'mvn clean package sonar:sonar'
                }
            }
        }

        stage('Quality Gate') {
            agent { dockerfile true }  
            steps{
                timeout(time: 1, unit: 'HOURS'){
                    waitForQualityGate abortPipeline: true
                }
            }
        }
      
        stage('Test') {
            agent { dockerfile true }  
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