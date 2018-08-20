pipeline {
    agent { 
        dockerfile{
            args '''
                --network host
                -v /var/run/docker.sock:/var/run/docker.sock
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
                script{
                    docker.withRegistry('', 'docker_login'){
                        def customImage = docker.build("jreedie/clinic_image:latest", "-f Dockerfile-app .")
                        customImage.push()
                    }
                }
                
                
            }
        }
      
        stage('Deploy Kubernetes'){
            steps{
                withCredentials([string(credentialsId: 'vault_token', variable: 'vaultToken')]) {
                    deployK8s '$vaultToken'
                }
            }
        }
        

        stage('Build on Windows') {
            agent{ label 'windows-agent' }
            steps{
                bat 'dir'
                bat 'mvn clean package'
                
                    
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