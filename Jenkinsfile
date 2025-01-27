pipeline {
    agent any
    
    environment {
        CONTAINER_ID = 'f18834ba10ff8d993bdfb104de298dab7a93d503b1adf332b9eb8440b2d82218'
        SUM_PY_PATH = 'Jenkins/sum.py'
        SUM_DIR = 'Jenkins'
        TEST_FILE_PATH = 'Jenkins/test_variables.txt'
    }
    
    stages {
        stage('Build') {
            steps {
                script {
                    // Construction de l'image Docker
                    docker.build('sum-app', SUM_DIR)
                }
            }
        }
        
        stage('Run Docker Container') {
            steps {
                script {
                    // Exécution du conteneur Docker et stockage de l'ID du conteneur
                    CONTAINER_ID = sh(script: "docker run -d sum-app sh -c 'tail -f /dev/null'", returnStdout: true).trim()
                }
            }
        }
        
        stage('Test sum.py') {
            steps {
                script {
                    // Lire les variables de test depuis le fichier
                    def testVariables = readFile(TEST_FILE_PATH).split("\n")
                    for (def line : testVariables) {
                        def args = line.split(" ")
                        def result = sh(script: "docker exec ${CONTAINER_ID} python ${SUM_PY_PATH} ${args[0]} ${args[1]}", returnStdout: true).trim()
                        echo "Test: ${args[0]} + ${args[1]} = ${result}"
                    }
                }
            }
        }
    }
    
    post {
        always {
            // Arrêter et supprimer le conteneur Docker
            sh "docker stop ${CONTAINER_ID}"
            sh "docker rm ${CONTAINER_ID}"
        }
    }
}
