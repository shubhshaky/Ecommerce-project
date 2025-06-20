pipeline {
    agent any

    environment {
        IMAGE_NAME = 'shubhshaky/ecommerce-project'
        IMAGE_TAG = 'ecom-img'
        DOCKER_CREDENTIALS_ID = 'DOCKER_HUB_CRED'  // Must be added in Jenkins
    }

    stages {

        stage('Clone Repository') {
            steps {
                git 'https://github.com/shubhshaky/Ecommerce-project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
                }
            }
        }

        stage('DockerHub Login') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: DOCKER_CREDENTIALS_ID,
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    }
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh 'docker push $IMAGE_NAME:$IMAGE_TAG'
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    // Remove old container if running
                    sh 'docker rm -f ecommerce-app || true'

                    // Run updated container
                    sh 'docker run -d -p 3000:80 --name ecommerce-app $IMAGE_NAME:$IMAGE_TAG'
                }
            }
        }
    }
}
