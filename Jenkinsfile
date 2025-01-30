pipeline {
    agent any
    
    environment {
        SUM_PY_PATH = './sum.py'
        DIR_PATH = '.'
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                echo 'Building the Docker image...'
                echo "${DIR_PATH}"
                bat "docker build -t python-sum ."
            }
        }
        
        stage('Run Docker Container') {
            steps {
                echo 'Running the Docker container...'
                script {
                    def containerId = bat(
                        script: 'docker run -dit python-sum',
                        returnStdout: true
                    ).trim()
                    env.CONTAINER_ID = containerId
                    echo "Container ID: ${env.CONTAINER_ID}"
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                echo 'Running tests inside the container...'
                bat """
                    docker cp ${env.SUM_PY_PATH} ${env.CONTAINER_ID}:/app/sum.py
                """
                
                bat """
                    @echo off
                    setlocal enabledelayedexpansion
                    for /F "tokens=1,2,3 delims= " %%A in (test_variables.txt) do (
                        set NUM1=%%A
                        set NUM2=%%B
                        set EXPECTED=%%C
                        
                        for /F "tokens=*" %%R in ('docker exec ${env.CONTAINER_ID} python /app/sum.py !NUM1! !NUM2!') do (
                            set RESULT=%%R
                        )
                        
                        if !RESULT! NEQ !EXPECTED! (
                            echo Test failed for inputs !NUM1!, !NUM2!: Expected !EXPECTED!, but got !RESULT!
                            exit /b 1
                        ) else (
                            echo Test passed for inputs !NUM1!, !NUM2!
                        )
                    )
                """
            }
        }
        
        stage('Cleanup') {
            steps {
                echo 'Stopping and removing the container...'
                bat "docker stop ${env.CONTAINER_ID}"
                bat "docker rm ${env.CONTAINER_ID}"
            }
        }
    }
}