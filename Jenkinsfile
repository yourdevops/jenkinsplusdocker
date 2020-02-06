pipeline {

  agent any

  parameters {
    booleanParam(name: 'dryRun', defaultValue: params.dryRun ?: true, description: 'Would you like to perform a dry run? [Is used to import parameters when the Pipeline is running for the first time]')
    string(name: 'dockerRegistry', defaultValue: params.dockerRegistry ?: 'registry.hub.docker.com', description: 'DockerHub registry, which will be used in this build.')
    string(name: 'dockerhubRepo', defaultValue: params.dockerhubRepo ?: ' ', description: 'DockerHub repo on the registry, where image will be pushed.')
    string(name: 'imageTag', defaultValue: params.imageTag ?: ' ', description: 'Image tag that will be pushed.')
    string(name: 'gitCreds', defaultValue: params.gitCreds ?: 'jenkins-machine-ssh-key', description: 'GitHub credentials stored in Jenkins UI')
    string(name: 'dockerRegCred', defaultValue: params.dockerRegCred ?: ' ', description: 'Docker Registry credentials stored in Jenkins UI.')
    string(name: 'publishPorts', defaultValue: params.publishPorts ?: ' ', description: 'Ports to be published by a docker container. Potentially dangerous, therefore left blank. Use reverse proxy, e.g. Nginx, to secure the installation.')
    string(name: 'volumesMount', defaultValue: params.volumesMount ?: '-v jenkins-data:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock', description: 'Volumes to be mounted by a docker container when deploying.')
    string(name: 'containersNetwork', defaultValue: params.containersNetwork ?: ' ', description: 'Internal Docker network name, on which docker container will run')
    booleanParam(name: 'autoDeploy', defaultValue: params.autoDeploy ?: false, description: '[Optional] Toggle autodeploy of newly built image in container on the specified server.')
    string(name: 'deployOnServer', defaultValue: params.deployOnServer ?: ' ', description: '[Optional] Server on which container with a new image will be deployed.')
  }

  environment {
    SSH_DEPLOY = "docker run -d --restart unless-stopped ${params.publishPorts} ${params.volumesMount} ${params.containersNetwork} --name ${JOB_BASE_NAME} ${params.dockerRegistry}/${params.dockerhubRepo}:${BUILD_NUMBER}"
  }

if( ${params.dryRun} == true ) {
   currentBuild.result = 'SUCCESS'
   return
}

  stages {
/*
    stage("Parameterizing") {
      when {
        expression {
          return params.dryRun == true;
        }
      }
      steps {
        echo 'Dry run completed. Job parameters were imported. Please set them to the correct values at the Project Configuration UI.'
        script {
          currentBuild.getRawBuild().getExecutor().interrupt(Result.SUCCESS)
          sleep(1)   // Interrupt is not blocking and does not take effect immediately.
        }
      }
    }
  */
    stage('Build image') {
      steps {
        script {
          DOCKER_IMAGE = docker.build("${params.dockerhubRepo}:${BUILD_NUMBER}")
        }
      }
    }
    stage('Push image') {
      steps {
          script {
            docker.withRegistry("https://${params.dockerRegistry}", "${params.dockerRegCred}") {
              DOCKER_IMAGE.push("${params.imageTag}")
            }
          }
      }
    }
    stage('Run Container on PROD Server') {
      when {
        expression {
          return params.autoDeploy == true;
        }
      }
      steps {
        echo 'run image deploy - only if it is enabled'
          sshagent(credentials : ['jenkins-machine-ssh-key']) {
            sh "ssh -o StrictHostKeyChecking=no root@${params.deployOnServer} '${SSH_DEPLOY}'" 
          }
      }
    }
  }
}