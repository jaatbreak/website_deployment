pipeline{
    agent any
    stages{
        stage("Pulling Code from SCM"){
            steps{
                git branch: 'main', url: 'https://github.com/jaatbreak/hacker_web_deploy.git'
            }
        }
        stage("Building a image "){
            steps{
                script{
                    dockerImage = docker.build("private", "-f Dockerfile .")
                    sh 'docker tag private:latest 926156776701.dkr.ecr.ap-south-1.amazonaws.com/private:latest'
                }
            }
        }
        stage( "push the To ECR"){
				steps {
				  withCredentials([string(credentialsId: 'ecr_id', variable: 'ecr_var')]){
  				    sh ' aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin $ecr_var'
			        sh	'docker push 926156776701.dkr.ecr.ap-south-1.amazonaws.com/private:latest'	
			   	}
		      }
        }
        stage("Tesing in Docker Containers"){
            steps{
                sh 'docker run -dit -p 80-100:80 926156776701.dkr.ecr.ap-south-1.amazonaws.com/private:latest '
            }
        }
        stage('Prompt for Deployment'){
		  steps{
		     script{
		       def userInput = input (
		          id: 'DeployingProduction',
		          message: 'Do you want to deploy in production',
		          parameter:[
		               booleanParam(defaultValue: false, description: 'Deploy to production?')
		          ]
		       )
		      if (userInput.DeployingProduction) {
		       // Call the deployment stage for production
                 build job: 'Deploying Production'
		     }else{
		           echo 'Deployment to production environment was skipped.'
		      }
		    }
		  }
		}
        stage("Deploying Production"){
            agent{
                label "dev"
            }
            steps{
                sh "mv /home/ubuntu/deploy_service.yaml  /home/ubuntu/jenkins/workspace/'pipeline jobs'"
                sh 'kubectl apply -f deploy_service.yaml'
                sh 'kubectl get svc'
                sh 'curl ifconfig.me.'
            }
        }
    }
}
