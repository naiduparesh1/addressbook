pipeline {
    agent none
    tools{
        jdk 'JDK11'
        maven 'usemaven'
    }

    parameters{
        string(name:'Env',defaultValue:'Test',description:'version to deploy')
        booleanParam(name:'executeTests',defaultValue: true,description:'decide to run tc')
        choice(name:'APPVERSION',choices:['1.1','1.2','1.3'])
    }
    environment{
        BUILD_SERVER_IP='ec2-user@172.31.26.81'
        DEPLOY_SERVER_IP='ec2-user@172.31.18.54'
        IMAGE_NAME='naiduparesh/demo'
    }

    stages {
        stage('Compile') {
            agent any
            steps {
                echo 'Compiling the code'
                echo "Compiling in ${params.Env}"
                sh 'mvn compile'
            }
        }
        stage('UnitTest') {
            agent any
            when{
                expression{
                    params.executeTests == true
                }
            }
            steps {
                echo 'Testing the code'
                sh 'mvn test'
            }
            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('BUILD') {
            agent any       
           
            steps{
            script{
                sshagent(['node1']) {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'Wipro@2023', usernameVariable: 'naiduparesh')]) {
                    echo "Packaging the code"
                    sh "scp -o StrictHostKeyChecking=no server-config.sh  ${BUILD_SERVER_IP}:/home/ec2-user"
                    sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER_IP} 'bash ~/server-config.sh ${IMAGE_NAME} ${BUILD_NUMBER}'"  
                    sh "ssh ${BUILD_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                    sh "ssh ${BUILD_SERVER_IP} sudo docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                                   
                    
                }
            }
            }
        }
        }
        stage('DEPLOY ON TEST SERVER'){
            agent any
             input{
                message "SELECT THE ENVIRONMENT TO DEPLOY"
                ok "DEPLOY"
                parameters{
                    choice(name:'NEWAPP',choices:['ONPREM','EKS','EC2'])

            }
             }
            steps{
                script{
                sshagent(['node1']) {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'Wipro@2023', usernameVariable: 'naiduparesh')]) {
                sh "ssh  -o StrictHostKeyChecking=no ${DEPLOY_SERVER_IP} sudo yum install docker -y"
                sh "ssh  ${DEPLOY_SERVER_IP} sudo systemctl start docker"
                sh "ssh  ${DEPLOY_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                sh "ssh  ${DEPLOY_SERVER_IP} sudo docker run -itd -P ${IMAGE_NAME}:${BUILD_NUMBER}"

                }
            }

        }
    }
}
    }
}