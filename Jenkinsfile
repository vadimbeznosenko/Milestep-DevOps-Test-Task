pipeline {
    environment {
        imagename = "192.168.31.10:5000/lavagna:$BUILD_NUMBER"
        dockerImage = ''
    }
  agent { label "agent1" }
  
  stages {
      stage("clonig git") {
      steps {
        git([url: 'https://github.com/vadimbeznosenko/Milestep-DevOps-Test-Task.git', branch: 'main'])
      }
    }
    stage('Prune Docker data') {
      steps {
        sh "docker system prune -a --volumes -f"
      }
    }
    stage("Build image") {
        steps{
      script {
        dockerImage = docker.build imagename
      }
    }
    }
     stage('Push Image') {
      steps{
        script  {
        dockerImage.push("$BUILD_NUMBER")
          }
        }
      }
       stage ('rm service') {
         steps{
		 catchError{
          sshagent(credentials : ['vagrant']) {
            sh 'ssh vagrant@192.168.31.11 -o StrictHostKeyChecking=no docker service  rm lavagna'
        }
    }
         }
		 }
         stage ('Deploy to swarm') {
         steps{
          sshagent(credentials : ['vagrant']) {
            sh 'ssh vagrant@192.168.31.11 -o StrictHostKeyChecking=no docker service create --publish 8080:8080 --name lavagna --replicas=3 $imagename'
        }
    }
         }
         stage("Dell work space in end") {
      steps {
        sh 'rm -rf /var/lid/jenkins/workspace/test/test/ 2> /dev/null'
      }
    }
 }
 }