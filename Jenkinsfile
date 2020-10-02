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
            '''
            }
        }
        stage('Yarn Build') {
            container('alpine') {
            sh '''
            '''
            }
        }          
        stage('Run tests') {
            container('alpine') {
            sh '''
            '''
            }
        }
        stage('Build and deploy') {
            container('alpine') {
            def isStartedByUser = currentBuild.rawBuild.getCause(hudson.model.Cause$UserIdCause) != null
            if (env.BRANCH_NAME ==~ /(dev|master)/) {
                sh '''
                    echo "I'm running"
                '''
                }
            if(isStartedByUser) {
                sh '''
                    echo "was started by user"
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
