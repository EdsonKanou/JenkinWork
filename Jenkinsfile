pipeline {
    agent any

    environment {
        SUM_PY_PATH = './sum.py'  // Chemin vers le script Python sur la machine locale
        DIR_PATH = '.'  // Répertoire contenant le Dockerfile
    }

    stages {
        // Étape 1 : Construire l'image Docker
        stage('Build Docker Image') {
            steps {
                echo 'Building the Docker image...'
                bat '''
                docker build -t python-sum .
                '''
            }
        }

        // Étape 2 : Lancer le conteneur Docker
        stage('Run Docker Container') {
            steps {
                echo 'Running the Docker container...'
                script {
                    def containerId = bat(script: 'docker run -dit python-sum', returnStdout: true).trim()
                    env.CONTAINER_ID_RUN = containerId.tokenize('\r\n')[0]  // Nettoyage de l'ID
                    echo "Container ID: ${env.CONTAINER_ID_RUN}"
                }
            }
        }

        // Étape 3 : Exécuter les tests
        stage('Run Tests') {
            steps {
                echo 'Running tests inside the container...'
                script {
                    // Copier sum.py dans le conteneur
                    bat "docker cp ${SUM_PY_PATH} ${env.CONTAINER_ID_RUN}:/app/sum.py"

                    // Lire et tester les valeurs depuis test_variables.txt
                    bat '''
                        @echo off
                        setlocal enabledelayedexpansion
                        
                        for /F "tokens=1,2,3 delims= " %%A in (test_variables.txt) do (
                            set NUM1=%%A
                            set NUM2=%%B
                            set EXPECTED=%%C
                            
                            rem Exécuter sum.py et récupérer la sortie
                            for /F %%R in ('docker exec %CONTAINER_ID_RUN% python /app/sum.py !NUM1! !NUM2!') do (
                                set RESULT=%%R
                            )

                            rem Comparer les valeurs en convertissant EXPECTED en format décimal
                            set "EXPECTED_FLOAT=!EXPECTED!.0"

                            if "!RESULT!" == "!EXPECTED_FLOAT!" (
                                echo Test passed for inputs !NUM1!, !NUM2!
                            ) else (
                                echo Test failed for inputs !NUM1!, !NUM2!: Expected !EXPECTED!, but got !RESULT!
                                exit /b 1
                            )
                        )
                    '''
                }
            }
        }

        // Étape 4 : Nettoyage
        stage('Cleanup') {
            steps {
                echo 'Stopping and removing the container...'
                script {
                    bat '''
                    docker stop %CONTAINER_ID_RUN%
                    docker rm %CONTAINER_ID_RUN%
                    '''
                }
            }
        }
    }
}
