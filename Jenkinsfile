pipeline {
    agent { dockerfile true }
  
    stages {
  	
        stage('Deploy Cluster') {
            steps{
                withCredentials([string(credentialsId: 'client_id', variable: 'clientID'), string(credentialsId: 'client_secret', variable: 'clientSecret'), 
                string(credentialsId: 'tenant_id', variable: 'tenantID')]){
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve -var-file=k8s.tfvars'
                }
                azureCLI commands: [[exportVariablesString: '', script: 'az group deployment create --name k8s-cluster --resource-group kubegroup --template-file ./$(find _output -name \'azuredeploy.json\') --parameters @./$(find _output -name \'azuredeploy.parameters.json\')']], principalCredentialId: 'kubegroup_sp'
            }
        }

        stage('Build and Sonarqube Analysis'){
            steps{
                withSonarQubeEnv('sonar-pass'){
                    sh 'mvn clean package sonar:sonar'
                }
            }
        }

        stage('Quality Gate') {  
            steps{
                timeout(time: 1, unit: 'HOURS'){
                    waitForQualityGate abortPipeline: true
                }
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