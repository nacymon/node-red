pipeline {
  agent any
  parameters {
    booleanParam(name: 'PUBLISH', defaultValue: false)
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Build builder') {
      steps { sh 'docker build -t node-builder -f Dockerfile.builder .' }
    }
    stage('Test') {
      steps { sh 'docker run --rm node-builder' }
    }
    stage('Build deploy') {
      steps { sh 'docker build -t node-deploy -f Dockerfile.deploy .' }
    }
    stage('Run & Verify') {
      steps {
        sh '''
          docker run -d -p 3000:3000 --name node-runner node-deploy
          sleep 5
          curl -f http://localhost:3000 || exit 1
        '''
      }
    }
    stage('Publish') {
      when {
        expression { return params.PUBLISH == true }
      }
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker tag node-deploy youruser/node-red-deploy:latest
            docker push youruser/node-red-deploy:latest
          '''
        }
      }
    }
  }
}
