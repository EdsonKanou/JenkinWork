pipeline {
    agent any
    
    environment {
        
        //f18834ba10ff8d993bdfb104de298dab7a93d503b1adf332b9eb8440b2d82218
        CONTAINER_ID = 'fe535054c007ebd01d02d7b5498f2689d2ab43b9c05682cad3cb96f5ce7f447f' // ID du conteneur sera stocké ici 
        SUM_PY_PATH = './sum.py' // Chemin vers le script sum.py sur la machine locale
        DIR_PATH = '.' // Chemin vers le répertoire contenant le Dockerfile
    }
    
    stages {
        stage('Build') {
            steps {
                echo 'Building Docker image...'
                bat "docker build -t python-sum ${DIR_PATH}"
            }
        }
        
        stage('Run') {
            steps {
                echo 'Running Docker container...'
                script {
                    def output = bat(script: 'docker run -dit python-sum', returnStdout: true)
                    def lines = output.split('\n')
                    env.CONTAINER_ID = lines[-1].trim()
                    echo "Container ID: ${env.CONTAINER_ID}"
                }
            }
        }
    }
}