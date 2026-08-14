pipeline{
    agent any
    stages{

        stage('checkout'){
            steps{
                sh 'ls -la'
            }
        }

        stage('docker build'){
            steps{
                sh 'docker build -t ghcr.io/hzdevops52/e-frontend:test  ./frontend'
                sh 'docker build -t ghcr.io/hzdevops52/e-backend:test ./backend'
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

                docker push ghcr.io/hzdevops52/e-frontend:test
                docker push ghcr.io/hzdevops52/e-backend:test
            '''
        }
    }
}

        }
}