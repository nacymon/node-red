pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "nacymon/node-red-ci"
        CONTAINER_NAME = "RED"
        DOCKER_NETWORK = "CI"
        NODE_PORT = "3000"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/nacymon/node-red'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }

        stage('Create Network') {
            steps {
                sh "docker network create $DOCKER_NETWORK || true"
            }
        }

        stage('Run Node-RED') {
            steps {
                sh "docker rm -f $CONTAINER_NAME || true"
                sh "docker run -d --name $CONTAINER_NAME --network $DOCKER_NETWORK -p $NODE_PORT:$NODE_PORT $DOCKER_IMAGE"
                sh "sleep 5"
            }
        }

        stage('Health Check') {
            steps {
                sh """
                    docker run --rm --network $DOCKER_NETWORK curlimages/curl:8.7.1 \
                    curl -f http://$CONTAINER_NAME:$NODE_PORT
                """
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push $DOCKER_IMAGE"
                }
            }
        }
    }

    post {
        always {
            echo 'Cleanup'
            sh "docker rm -f $CONTAINER_NAME || true"
            sh "docker network rm $DOCKER_NETWORK || true"
        }
    }
}
