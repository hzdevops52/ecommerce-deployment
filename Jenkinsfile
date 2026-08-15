pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                sh 'ls -la'
            }
        }

        stage('Get Commit SHA') {
            steps {
                script {
                    env.COMMIT_SHA = sh(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()

                    echo "Commit SHA: ${env.COMMIT_SHA}"
                }
            }
        }

    stage('Docker Build') {
    steps {
        sh 'docker build -t ghcr.io/hzdevops52/e-frontend:$COMMIT_SHA ./frontend'
        sh 'docker tag ghcr.io/hzdevops52/e-frontend:$COMMIT_SHA ghcr.io/hzdevops52/e-frontend:test'

        sh 'docker build -t ghcr.io/hzdevops52/e-backend:$COMMIT_SHA ./backend'
        sh 'docker tag ghcr.io/hzdevops52/e-backend:$COMMIT_SHA ghcr.io/hzdevops52/e-backend:test'
    }
}

        stage('Docker Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'GHCR-push',
                        usernameVariable: 'GHCR_USER',
                        passwordVariable: 'GHCR_TOKEN'
                    )
                ]) {
                    sh '''
                        echo "$GHCR_TOKEN" | docker login ghcr.io \
                            -u "$GHCR_USER" \
                            --password-stdin

                        docker push ghcr.io/hzdevops52/e-frontend:$COMMIT_SHA
                        docker push ghcr.io/hzdevops52/e-frontend:test

                        docker push ghcr.io/hzdevops52/e-backend:$COMMIT_SHA
                        docker push ghcr.io/hzdevops52/e-backend:test
                    '''
                }
            }
        }

        stage('Deploy') {
    steps {
        withCredentials([
            file(
                credentialsId: 'backend-env',
                variable: 'BACKEND_ENV'
            ),
            usernamePassword(
                credentialsId: 'GHCR-push',
                usernameVariable: 'GHCR_USER',
                passwordVariable: 'GHCR_TOKEN'
            )
        ]){
            sh '''
                cp "$BACKEND_ENV" backend/.env

                docker compose pull
                docker compose up -d
            '''
        }
    }
}
    }
}