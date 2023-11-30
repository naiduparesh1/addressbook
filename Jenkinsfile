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
        DEPLOY_ SERVER_IP = 'ec2-user@172.31.26.81'
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
                sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER_IP} rm -Rf server-config.sh"
                sh "scp -o StrictHostKeyChecking=no server-config.sh ${BUILD_SERVER_IP}:/home/ec2-user"
                sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER_IP} 'bash ~/server-config.sh'"
                sh "${BUILD_SERVER_IP} sudo docker login -u naiduparesh -p Wipro@2023"
                sh "${BUILD_SERVER_IP} sudo docker push image"
            }
            }
            }
            }
            stage (Deploy){
                steps{
                script{
                sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_ SERVER_IP} sudo yum install docker -y"
                sh "${DEPLOY_ SERVER_IP} systemctl start docker"
                sh "${DEPLOY_ SERVER_IP} sudo docker login -u naiduparesh -p Wipro@2023"
                sh "${DEPLOY_ SERVER_IP} sudo docker run -itd -P ab:tomdoc"
            }
            }
            }

            }
            


         }
        
    
            
