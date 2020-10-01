#!/usr/bin/env groovy

def label = "k8sagent-e2e"

podTemplate(label: label,
      containers: [
              containerTemplate(name: 'alpine', image: 'docker:dind', ttyEnabled: true, command: 'cat'),
      ],
      ) {
  node(label) {
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
              apk update \
	      && apk --no-cache add git curl make python3 python3-dev gcc libc-dev libffi-dev py3-pip \
              openssl-dev \
	      && pip3 --no-cache-dir install --upgrade pip \
	      && pip3 --no-cache-dir install docker-compose==1.24.1 \
	      && rm -f /var/cache/apk/* \
	      && rm -rf /root/.cache
            '''
            }
        }          
        stage('Build Container') {
            container('alpine') {
            sh '''
                docker-compose -f docker-compose.jenkins.yml down -v --rmi all
                docker-compose -f docker-compose.jenkins.yml build
                docker-compose -f docker-compose.jenkins.yml up -d
            '''
            }
        }
        stage('SAM Build') {
            container('alpine') {
            sh '''
                docker-compose -f docker-compose.jenkins.yml  exec -T cli bash -c "/app/jenkins/build.sh"
            '''
            }
        }        
        stage('Run tests') {
            container('alpine') {
            sh '''
                docker-compose -f docker-compose.jenkins.yml  exec -T cli bash -c "/app/jenkins/test.sh"
            '''
            }
        }
        stage('Deploy SAM') {
            container('alpine') {
            sh '''
                docker-compose -f docker-compose.jenkins.yml  exec -T cli bash -c "/app/jenkins/deploy.sh"
            '''
            }
        }
    } catch(exc) {
        currentBuild.result = 'FAILURE'
      }
      finally {
            container('alpine') {
            sh '''
                docker-compose -f docker-compose.jenkins.yml down -v --rmi all
            '''
      }
    }
  }
  }
} 
