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
        stage('Environment Setup') {
            container('alpine') {            
            sh '''
                apk add --update --no-cache --virtual .build-deps gcc musl-dev alpine-sdk python3 python3-dev nodejs-current npm yarn && ln -sf python3 /usr/bin/python
                python3 -m ensurepip
                pip3 install --no-cache --upgrade pip setuptools
                pip install --ignore-installed aws-sam-cli
            '''
            }
        }
        stage('Yarn Build') {
            container('alpine') {
            sh '''
                yarn install
                yarn build
            '''
            }
        }          
        stage('Run tests') {
            container('alpine') {
            sh '''
                yarn lint
            '''
            }
        }
        stage('Build and deploy') {
            container('alpine') {
            if (env.BRANCH_NAME ==~ /(dev|master)/) {
                sh '''
                    echo "I'm running"
                '''
                }
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
