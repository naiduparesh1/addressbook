pipeline { 
    agent any
    tools {  
        jdk   'JDK11'
        maven 'usemaven'
        }

parameters {
        string(name: 'ENV', defaultValue: 'Test', description: 'Version to deploy')

        booleanParam(name: 'executetests', defaultValue: true, description: 'decide to run test case')

        choice(name: 'Appversion', choices: ['1.1', '1.2', '1.3'])
    }
    environment{
        BUILD_SERVER_IP = 'ec2-user@172.31.18.54'
        DEPLOY_SERVER_IP = 'ec2-user@172.31.26.81'
        IMAGE_NAME = 'naiduparesh/demo'
    }

    stages {
        stage('compile') {
            
            steps {
                echo 'compiling the java based code'
                echo "compiling the ${params.ENV}"
                sh 'mvn compile'
            } 
        }
        stage('Unittest') {
          
            when {
                expression{
                    params.executetests == true
                }
            }
            steps {
                echo 'testing the code'
                sh 'mvn test'
            }
            post{
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            
            }
        }
        stage('Build') {
            agent any
            input {
                message "select the version?"
                ok "version selected"
                parameters {
                    choice(name: 'Appversion', choices: ['1.1', '1.2', '1.3'])
                }
            }
            steps{
            script{
                sshagent(['node1']) {
                echo"packaging the code"
                withcredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable : 'Wipro@2023', usernameVaraible : 'naiduparesh')])
                sh "scp -o StrictHostKeyChecking=no server-config.sh ${BUILD_SERVER_IP}:/home/ec2-user"
                sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER_IP} 'bash ~/server-config.sh ${IMAGE_NAME} ${BUILD_NUMBER}'"
                sh "${BUILD_SERVER_IP} sudo docker login -u naiduparesh -p Wipro@2023"
                sh "${BUILD_SERVER_IP} sudo docker push image"
            }
            }
            }
            }
            stage (Deploy){
                agent any
                steps{
                script{
                sshagent(['node1']) {
                sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER_IP} sudo yum install docker -y"
                sh "${DEPLOY_SERVER_IP} systemctl start docker"
                sh "${DEPLOY_SERVER_IP} sudo docker login -u naiduparesh -p Wipro@2023"
                sh "${DEPLOY_SERVER_IP} sudo docker run -itd -P ${IMAGE_NAME}:${BUILD_NUMBER}"
            }}
            }
            }

            }
            


         }
        
    
            
