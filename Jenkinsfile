pipeline {
    agent any
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
            }
        }
        stage('package') {
            steps {
                echo 'packaging the code'
                echo "packaging version ${params.Appversion}"
            }
        }
    }
}
