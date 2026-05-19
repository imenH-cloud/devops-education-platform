pipeline {
    agent any
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
        timeout(time: 1, unit: 'HOURS')
    }
    
    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['development', 'staging', 'production'], description: 'Deployment environment')
        booleanParam(name: 'PUSH_DOCKER', defaultValue: false, description: 'Push images to Docker Hub?')
    }
    
    environment {
        DOCKER_REGISTRY = 'eline2016'
        DOCKER_CREDENTIALS = credentials('docker-hub-credentials')
        JIRA_SITE = 'imen-hamada'
        GIT_REPO = 'https://github.com/imenH-cloud/devops-education-platform.git'
        KUBE_NAMESPACE = 'education'
    }
    
    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "🔄 Checking out source code..."
                    checkout scm
                }
            }
        }
        
        stage('Build') {
            parallel {
                stage('Build Frontend') {
                    steps {
                        script {
                            echo "🏗️ Building Frontend (Angular)..."
                            dir('frontend') {
                                sh '''
                                    docker build -t ${DOCKER_REGISTRY}/horizons-frontend:${BUILD_NUMBER} \
                                        -t ${DOCKER_REGISTRY}/horizons-frontend:latest \
                                        -f Dockerfile.prod .
                                '''
                            }
                        }
                    }
                }
                
                stage('Build Activity Service') {
                    steps {
                        script {
                            echo "🏗️ Building Activity Service..."
                            dir('backend/activity') {
                                sh '''
                                    docker build -t ${DOCKER_REGISTRY}/devopspfe-activity-service:${BUILD_NUMBER} \
                                        -t ${DOCKER_REGISTRY}/devopspfe-activity-service:latest .
                                '''
                            }
                        }
                    }
                }
                
                stage('Build Teacher Service') {
                    steps {
                        script {
                            echo "🏗️ Building Teacher Service..."
                            dir('backend/teacher') {
                                sh '''
                                    docker build -t ${DOCKER_REGISTRY}/devopspfe-teacher-service:${BUILD_NUMBER} \
                                        -t ${DOCKER_REGISTRY}/devopspfe-teacher-service:latest .
                                '''
                            }
                        }
                    }
                }
                
                stage('Build Gateway') {
                    steps {
                        script {
                            echo "🏗️ Building Gateway..."
                            dir('backend/gateway') {
                                sh '''
                                    docker build -t ${DOCKER_REGISTRY}/devopspfe-gateway-backend:${BUILD_NUMBER} \
                                        -t ${DOCKER_REGISTRY}/devopspfe-gateway-backend:latest .
                                '''
                            }
                        }
                    }
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    echo "✅ Running tests..."
                    // Add your tests here
                    sh 'echo "Tests would run here"'
                }
            }
        }
        
        stage('Push to Docker Hub') {
            when {
                expression { params.PUSH_DOCKER == true }
            }
            steps {
                script {
                    echo "🚀 Pushing images to Docker Hub..."
                    sh '''
                        echo ${DOCKER_CREDENTIALS_PSW} | docker login -u ${DOCKER_CREDENTIALS_USR} --password-stdin
                        
                        docker push ${DOCKER_REGISTRY}/horizons-frontend:${BUILD_NUMBER}
                        docker push ${DOCKER_REGISTRY}/horizons-frontend:latest
                        
                        docker push ${DOCKER_REGISTRY}/devopspfe-activity-service:${BUILD_NUMBER}
                        docker push ${DOCKER_REGISTRY}/devopspfe-activity-service:latest
                        
                        docker push ${DOCKER_REGISTRY}/devopspfe-teacher-service:${BUILD_NUMBER}
                        docker push ${DOCKER_REGISTRY}/devopspfe-teacher-service:latest
                        
                        docker push ${DOCKER_REGISTRY}/devopspfe-gateway-backend:${BUILD_NUMBER}
                        docker push ${DOCKER_REGISTRY}/devopspfe-gateway-backend:latest
                        
                        docker logout
                    '''
                }
            }
        }
        
        stage('Update Jira') {
            steps {
                script {
                    echo "📋 Updating Jira..."
                    // Jira integration example
                    sh '''
                        echo "Build ${BUILD_NUMBER} completed for ${DEPLOY_ENV} environment"
                    '''
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            when {
                expression { params.DEPLOY_ENV != '' }
            }
            steps {
                script {
                    echo "📦 Deploying to Kubernetes (${params.DEPLOY_ENV})..."
                    sh '''
                        kubectl set image deployment/frontend-app-deployment \
                            -n ${KUBE_NAMESPACE} \
                            frontend-app=${DOCKER_REGISTRY}/horizons-frontend:${BUILD_NUMBER} \
                            --record
                        
                        kubectl set image deployment/activity-service-deployment \
                            -n ${KUBE_NAMESPACE} \
                            activity-app=${DOCKER_REGISTRY}/devopspfe-activity-service:${BUILD_NUMBER} \
                            --record
                        
                        kubectl set image deployment/teacher-service-deployment \
                            -n ${KUBE_NAMESPACE} \
                            teacher-app=${DOCKER_REGISTRY}/devopspfe-teacher-service:${BUILD_NUMBER} \
                            --record
                        
                        kubectl set image deployment/gateway-backend-deployment \
                            -n ${KUBE_NAMESPACE} \
                            gateway-app=${DOCKER_REGISTRY}/devopspfe-gateway-backend:${BUILD_NUMBER} \
                            --record
                    '''
                }
            }
        }
        
        stage('Verify Deployment') {
            when {
                expression { params.DEPLOY_ENV != '' }
            }
            steps {
                script {
                    echo "✅ Verifying deployment..."
                    sh '''
                        kubectl rollout status deployment/frontend-app-deployment -n ${KUBE_NAMESPACE} --timeout=5m
                        kubectl get pods -n ${KUBE_NAMESPACE}
                    '''
                }
            }
        }
    }
    
    post {
        always {
            script {
                echo "🧹 Cleaning up..."
                sh 'docker image prune -f'
            }
        }
        
        success {
            script {
                echo "✅ Pipeline succeeded!"
            }
        }
        
        failure {
            script {
                echo "❌ Pipeline failed!"
            }
        }
    }
}
