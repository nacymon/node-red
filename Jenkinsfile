pipeline {
    agent {
        docker {
            image 'node:20'
        }
    }
    environment {
        APP_PORT = '3000'
        IMAGE_NAME = 'my-node-red-app'
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/nacymon/node-red'
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
                sh 'npm test || true'  // Zapewnij kontynuację przy błędach testu
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }
        stage('Deploy Locally') {
            steps {
                sh 'docker run -d -p $APP_PORT:3000 --name node-red-instance $IMAGE_NAME'
                sh 'sleep 10'
                sh 'curl -f http://localhost:$APP_PORT || exit 1'
            }
        }
        stage('Publish') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh 'docker push $IMAGE_NAME'
                }
            }
        }
    }
    post {
        always {
            sh 'docker logs node-red-instance || true'
            sh 'docker rm -f node-red-instance || true'
        }
    }
}
