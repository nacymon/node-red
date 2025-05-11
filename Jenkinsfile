pipeline {
    agent {
        docker {
            image 'docker:24.0.5-cli'   // lekki obraz z klientem docker
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        DOCKER_IMAGE = "nacymon/node-red-ci"
        CONTAINER_NAME = "node-red-test"
    }

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/nacymon/node-red'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Run container') {
            steps {
                sh "docker rm -f $CONTAINER_NAME || true"
                sh "docker run -d --name $CONTAINER_NAME -p 8080:3000 $DOCKER_IMAGE"
                sh "sleep 10"
            }
        }

        stage('Health check (curl)') {
            steps {
                sh 'apk add curl || true' // w Alpine nie ma curl domyślnie
                sh 'curl -f http://localhost:3000 || exit 1'
            }
        }

        stage('Publish image') {
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
            sh "docker rm -f $CONTAINER_NAME || true"
        }
    }
}
