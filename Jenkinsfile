pipeline {
    agent any

    environment {
        SSH_SERVER = "jenkins-user@localhost"
        DOCKER_COMPOSE_PATH = "~/react-jenkins-app"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Cloning the project repository..."
                git url: 'https://repo-url.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh 'docker-compose down || true'
                sh 'docker-compose up --build -d'
            }
        }

        stage('Deploy to Ubuntu Server') {
            steps {
                echo "Deploying React app to Ubuntu server..."
                sshagent(['ubuntu-ssh']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no -p 2222 ${SSH_SERVER} << EOF
                        mkdir -p ${DOCKER_COMPOSE_PATH}
                        cd ${DOCKER_COMPOSE_PATH}
                        rm -rf *
                        exit
                    EOF
                    scp -P 2222 -r . ${SSH_SERVER}:${DOCKER_COMPOSE_PATH}
                    ssh -p 2222 ${SSH_SERVER} << EOF
                        cd ${DOCKER_COMPOSE_PATH}
                        docker-compose down || true
                        docker-compose up --build -d
                        exit
                    EOF
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Deployment successful! React app is live."
        }
        failure {
            echo "Deployment failed!"
        }
    }
}
