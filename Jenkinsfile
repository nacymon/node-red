pipeline {
    agent any

    environment {
      
        DOCKER_HOST = "unix:///var/run/docker.sock"
        DOCKER_IMAGE = "nacymon/node-red-ci"  
        CONTAINER_NAME = "node-red-test"  // Zmieniona nazwa kontenera
    }

    stages {

         stage('Clear') {
            steps {
                script{
                    sh '''
                        if [ "$(docker ps -aq)" ]; then
                          docker rm -f $(docker ps -aq)
                        fi
                        if [ "$(docker images -aq)" ]; then
                          docker rmi -f $(docker images -aq)
                        fi
                    '''
                }
            }
        }
        
        stage('Checkout') {
            steps {
                git 'https://github.com/nacymon/node-red' 
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Run container') {
            steps {
                script {
                    // Zatrzymaj, jeśli przypadkiem działa
                    sh "docker rm -f $CONTAINER_NAME || true"
                    // Uruchom na porcie 3000
                    sh "docker run -d --name $CONTAINER_NAME -p 8081:3000 $DOCKER_IMAGE"
                    // Daj aplikacji czas na odpalenie
                    sh "sleep 10"
                }
            }
        }

        stage('Health check (curl)') {
            steps {
                script {
                    // Sprawdź, czy curl działa — jak nie, zainstaluj
                    sh 'which curl || (apt update && apt install -y curl)'
                    // Sprawdź, czy aplikacja odpowiada na porcie 3000
                    sh 'curl -f http://localhost:3000 || exit 1'
                }
            }
        }

        stage('Publish image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                        sh "docker push $DOCKER_IMAGE"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh "docker rm -f $CONTAINER_NAME || true"
        }
    }
}
