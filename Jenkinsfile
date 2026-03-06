pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "subhashrokkala/onlinebookstore"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/Subhash-Rokkala/onlinebookstore.git'
            }
        }

        stage('Build Maven Package') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:latest .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                credentialsId: 'dockerhub-creds',
                usernameVariable: 'DOCKER_USER',
                passwordVariable: 'DOCKER_PASS')]) {

                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $DOCKER_IMAGE:latest'
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker stop onlinebookstore || true
                docker rm onlinebookstore || true
                docker run -d -p 2805:8080 --name onlinebookstore $DOCKER_IMAGE:latest
                '''
            }
        }
    }
}
