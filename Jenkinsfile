pipeline {
    agent any
    tools {  
        jdk   'JDK11'
        maven MyMaven

    }

parameters {
        string(name: 'ENV', defaultValue: 'Test', description: 'Version to deploy')

        booleanParam(name: 'executetests', defaultValue: true, description: 'decide to run test case')

        choice(name: 'Appversion', choices: ['1.1', '1.2', '1.3'])
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
        }
        stage('package') {
            input {
                message "select the version?"
                ok "version selected"
                parameters {
                    choice(name: 'Appversion', choices: ['1.1', '1.2', '1.3'])
                }
            }

            steps {
                echo 'packaging the code'
                echo "packaging version ${params.Appversion}"
                sh 'mvn compile'
            }
        }
    }
}
