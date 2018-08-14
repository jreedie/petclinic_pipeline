pipeline {
    agent { 
        dockerfile{
            args '''
                --network host
            '''
        }
    }
    stages {
  	
        
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

        stage('Build image') {
            steps{ 
                sh 'docker build -t jreedie/clinic_image:latest -f Dockerfile-app .'
                withDockerRegistry([credentialsId: "${docker_login}"], url: ""]) {
                    sh 'docker push jreedie/clinic_image:latest'
                }
            }
        }
      
        stage('Deploy Cluster') {
            steps{
                withCredentials([string(credentialsId: 'vault_token', variable: 'vaultToken')]){
                    injectCreds '$vaultToken'
                    
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