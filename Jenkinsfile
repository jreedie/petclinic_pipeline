pipeline {
    agent { dockerfile true }
    environment{
        WORKSPACE=/var/lib/jenkins/workspace/pipeline_demo_master-YCLVMIFKQWOHG4NMQXMJVJZU3W6QMPWGKPDBHFPXCCLCPYAAV4UQ/
    }
    stages {
  	
        stage('Deploy Cluster') {
            steps{
                withCredentials([string(credentialsId: 'client_id', variable: 'clientID'), string(credentialsId: 'client_secret', variable: 'clientSecret'), 
                string(credentialsId: 'tenant_id', variable: 'tenantID')]){
                    sh 'terraform state rm ""'
                    sh 'terraform init'
                    sh 'terraform plan -var-file=k8s.tfvars'
                    sh 'terraform apply -auto-approve -var-file=k8s.tfvars'
                }
                azureCLI commands: [[exportVariablesString: '', script: 'az group deployment create --name k8s-cluster --resource-group kubegroup --template-file ${WORKSPACE}_output/kubegroup-k8s-cluster/azuredeploy.json --parameters ${WORKSPACE}_output/kubegroup-k8s-cluster/azuredeploy.parameters.json']], principalCredentialId: 'kubegroup_sp'
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