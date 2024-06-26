pipeline {
    agent any
    
    environment {
        AWS_CREDENTIALS = 'it-programmatic-user' 
        AWS_REGION = 'us-east-1' 
        AWS_ACCOUNT_ID = '905418303594'
        ECR_REPO_NAME = 'selenium' 
        DOCKER_IMAGE_NAME = 'selenium-chrome:latest' 
        DOCKERFILE_PATH = 'Dockerfile' 
        dkr= 'docker' 
    }

    stages {
        stage('Create ECR Repository') {
            steps {
                script {
                    
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: AWS_CREDENTIALS, secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        
                        try {
                            sh "aws ecr create-repository --repository-name $ECR_REPO_NAME --region $AWS_REGION"
                        } catch (Exception e) {
                           
                            echo "ECR repository already exists"
                        }
                    }
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                   
                    sh "docker build -t $DOCKER_IMAGE_NAME -f $DOCKERFILE_PATH ."
                    
                    sh "docker tag $DOCKER_IMAGE_NAME $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:latest"
                    
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: AWS_CREDENTIALS, secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        sh "aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
                    }
                    
                    sh "docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:latest"
                }
            }
        }
    }
}
