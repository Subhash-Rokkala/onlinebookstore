pipeline {
    agent any

    environment {
        IMAGE_NAME = "subhashrokkala/onlinebookstore"
        CONTAINER_NAME = "onlinebookstore"
        PORT = "2805"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'master', credentialsId: 'gitloginCred', url: 'https://github.com/Subhash-Rokkala/onlinebookstore.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                    echo $PASS | docker login -u $USER --password-stdin
                    docker push $IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker stop $CONTAINER_NAME || true
                docker rm $CONTAINER_NAME || true
                docker run -d -p $PORT:8080 --name $CONTAINER_NAME $IMAGE_NAME:latest
                '''
            }
        }

    }
}
