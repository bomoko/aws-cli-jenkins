#!/usr/bin/env groovy

def label = "k8sagent-e2e"
podTemplate(label: label,
      containers: [
              containerTemplate(name: 'alpine', image: 'alpine', ttyEnabled: true, command: 'cat'),
      ],
      envVars: [
          envVar(key: 'AWS_DEFAULT_REGION', value: 'eu-west-2'),
      ]
      ) {
  node(label) {
   withCredentials([
       string(credentialsId: 'jenkins-aws-secret-key-id', variable: 'AWS_ACCESS_KEY_ID'),
       string(credentialsId: 'jenkins-aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY'),
       ]) { 
   withEnv(['DOCKER_HOST=tcp://docker-host.lagoon.svc:2375']) {
    try {
        stage('Init') {
            timeout(time: 3, unit: 'MINUTES') {
                checkout scm
            }
        }
        stage('env') {
            container('alpine') {            
            sh '''
                apk add --update --no-cache --virtual .build-deps gcc musl-dev python3 python3-dev nodejs-current npm yarn && ln -sf python3 /usr/bin/python
                python3 -m ensurepip
                pip3 install --no-cache --upgrade pip setuptools
                pip install --ignore-installed aws-sam-cli
            '''
            }
        }          
        stage('SAM Build') {
            container('alpine') {
            sh '''
                echo "build"
            '''
            }
        }        
        stage('Run tests') {
            container('alpine') {
            sh '''
                echo "test"
            '''
            }
        }
        stage('Deploy SAM') {
            container('alpine') {
            sh '''
                echo "Deploy"
            '''
            }
        }
    } catch(exc) {
        currentBuild.result = 'FAILURE'
      }
      finally {
            container('alpine') {
            sh '''
                echo "something broke"
            '''
      }
    }
  }
  }
  }
} 
