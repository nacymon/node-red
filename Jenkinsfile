pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "nacymon/node-red-ci"
        CONTAINER_NAME = "node-red-test"
        APP_PORT = "3000"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/nacymon/node-red'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Run container') {
            steps {
                script {
                    sh "docker rm -f ${CONTAINER_NAME} || true"
                    sh "docker run -d --name ${CONTAINER_NAME} -p ${APP_PORT}:${APP_PORT} ${DOCKER_IMAGE}"
                    sleep(time: 10, unit: 'SECONDS') // daj aplikacji czas
                }
            }
        }

        stage('Health check') {
            steps {
                script {
                    // Sprawdź odpowiedź aplikacji
                    sh "curl -f http://localhost:${APP_PORT} || exit 1"
                }
            }
        }

        stage('Publish image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh "docker rm -f ${CONTAINER_NAME} || true"
        }
    }
}
