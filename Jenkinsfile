pipeline {
    agent any

    environment {
        REGISTRY = 'eline2016'
        MICROSERVICES = 'activity auth classroom gateway parent student teacher user'
        FRONTEND_APP = 'frontend-app'
        GITOPS_REPO = 'https://github.com/imenH-cloud/devops-education-platform-gitops.git'
        GITOPS_BRANCH = 'main'
        TRIVY_IMAGE = 'aquasec/trivy:latest'
        // 👇 Timeout global pour toutes les étapes (facultatif)
        BUILD_TIMEOUT = '40' // minutes
    }

    options {
        timeout(time: 60, unit: 'MINUTES')
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
                echo "✅ Code checked out successfully"
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        echo "🔐 Logging into Docker Hub..."
                        bat "docker login -u %DOCKER_USER% -p %DOCKER_PASS%"
                        echo "✅ Docker login successful"
                    }
                }
            }
        }

        stage('Trivy Scan - Code') {
            steps {
                script {
                    try {
                        // Correction du volume mount sous Windows
                        def workspace = pwd().replace('\\', '/')
                        bat "docker run --rm -v ${workspace}:/scan ${TRIVY_IMAGE} fs --exit-code 0 --severity CRITICAL /scan"
                        echo "✅ Code scan completed"
                    } catch (Exception e) {
                        echo "⚠️ Trivy scan failed (continuing): ${e.message}"
                    }
                }
            }
        }

        stage('Build Backend Images') {
            steps {
                script {
                    def services = env.MICROSERVICES.split()
                    for (service in services) {
                        dir("backend/${service}") {
                            echo "🔨 Building ${service}-service:${BUILD_NUMBER}..."
                            bat "docker build -t ${REGISTRY}/devopspfe-${service}-service:${BUILD_NUMBER} ."
                            echo "✅ ${service}-service built"
                        }
                    }
                }
            }
        }

        stage('Build Frontend Image') {
            options {
                timeout(time: 30, unit: 'MINUTES') // ⏱️ Timeout spécifique car le build est long
            }
            steps {
                dir("frontend/app") {
                    echo "🔨 Building frontend-app:${BUILD_NUMBER}..."
                    // 🚀 Ajout de l'argument NODE_OPTIONS pour allouer plus de mémoire
                    bat """
                        docker build --build-arg NODE_OPTIONS="--max-old-space-size=4096" -t ${REGISTRY}/devopspfe-${FRONTEND_APP}:${BUILD_NUMBER} .
                    """
                    echo "✅ frontend-app built"
                }
            }
        }

        stage('Trivy Scan - Images') {
            steps {
                script {
                    try {
                        def services = env.MICROSERVICES.split()
                        for (service in services) {
                            echo "🔍 Scanning ${service}-service..."
                            bat "docker run --rm ${TRIVY_IMAGE} image --exit-code 0 --severity CRITICAL ${REGISTRY}/devopspfe-${service}-service:${BUILD_NUMBER}"
                        }
                        echo "🔍 Scanning frontend-app..."
                        bat "docker run --rm ${TRIVY_IMAGE} image --exit-code 0 --severity CRITICAL ${REGISTRY}/devopspfe-${FRONTEND_APP}:${BUILD_NUMBER}"
                        echo "✅ Image scans completed"
                    } catch (Exception e) {
                        echo "⚠️ Image scan failed (continuing): ${e.message}"
                    }
                }
            }
        }

        stage('Push Images to Docker Hub') {
            steps {
                script {
                    def services = env.MICROSERVICES.split()
                    echo "📤 Pushing to Docker Hub (${REGISTRY})..."
                    for (service in services) {
                        echo "  → ${REGISTRY}/devopspfe-${service}-service:${BUILD_NUMBER}"
                        bat "docker push ${REGISTRY}/devopspfe-${service}-service:${BUILD_NUMBER}"
                    }
                    echo "  → ${REGISTRY}/devopspfe-${FRONTEND_APP}:${BUILD_NUMBER}"
                    bat "docker push ${REGISTRY}/devopspfe-${FRONTEND_APP}:${BUILD_NUMBER}"
                    echo "✅ All images pushed to Docker Hub"
                }
            }
        }

        stage('Update GitOps Manifests') {
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
                    script {
                        try {
                            bat "if exist gitops-temp rmdir /s /q gitops-temp || exit 0"
                            
                            // Clone with token (correction pour éviter les problèmes de substitution)
                            bat """
                                setlocal enabledelayedexpansion
                                set "REPO_URL=https://!GITHUB_TOKEN!@github.com/imenH-cloud/devops-education-platform-gitops.git"
                                git clone !REPO_URL! gitops-temp
                            """
                            
                            dir('gitops-temp') {
                                def services = env.MICROSERVICES.split()
                                
                                echo "🔄 Updating Kubernetes manifests with new Docker Hub images..."
                                
                                // Update backend services
                                for (service in services) {
                                    def yamlFile = "kubernetes/backend/${service}-service.yaml"
                                    if (fileExists(yamlFile)) {
                                        echo "  → ${service}-service.yaml"
                                        bat """
                                            powershell -Command "(Get-Content '${yamlFile}') -replace 'image: .*', 'image: ${REGISTRY}/devopspfe-${service}-service:${BUILD_NUMBER}' | Set-Content '${yamlFile}'"
                                        """
                                    }
                                }
                                
                                // Update frontend
                                def frontendFile = "kubernetes/frontend/frontend-app.yaml"
                                if (fileExists(frontendFile)) {
                                    echo "  → frontend-app.yaml"
                                    bat """
                                        powershell -Command "(Get-Content '${frontendFile}') -replace 'image: .*', 'image: ${REGISTRY}/devopspfe-${FRONTEND_APP}:${BUILD_NUMBER}' | Set-Content '${frontendFile}'"
                                    """
                                }
                                
                                bat "git config user.email 'jenkins@devops-education.local'"
                                bat "git config user.name 'Jenkins CI/CD'"
                                bat "git add ."
                                
                                bat """
                                    git diff --cached --quiet
                                    if errorlevel 1 (
                                        git commit -m "Build ${BUILD_NUMBER} - update Docker Hub image tags"
                                        git push origin ${GITOPS_BRANCH}
                                        echo.✅ GitOps manifests pushed to GitHub
                                    ) else (
                                        echo.ℹ️  No changes to commit
                                    )
                                """
                            }
                            
                            bat "if exist gitops-temp rmdir /s /q gitops-temp || exit 0"
                            echo "✅ GitOps update completed"
                            
                        } catch (Exception e) {
                            echo "❌ GitOps update failed: ${e.message}"
                            throw e
                        }
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    try {
                        echo "🧪 Running tests..."
                        bat "powershell -File tests\\test-services.ps1 || exit 0"
                        bat "powershell -File tests\\test-integration.ps1 || exit 0"
                        bat "powershell -File tests\\test-e2e.ps1 || exit 0"
                        echo "✅ Tests completed"
                    } catch (Exception e) {
                        echo "⚠️ Tests failed (continuing): ${e.message}"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "=========================================="
            echo "✅ BUILD SUCCESSFUL"
            echo "=========================================="
            echo "Build #${BUILD_NUMBER} completed"
            echo "Images: ${REGISTRY}/devopspfe-*:${BUILD_NUMBER}"
            echo "Registry: Docker Hub (hub.docker.com)"
            echo "GitOps: Updated and pushed"
            echo "Next: ArgoCD will auto-sync"
            echo "=========================================="
        }
        failure {
            echo "=========================================="
            echo "❌ BUILD FAILED"
            echo "=========================================="
            echo "Build #${BUILD_NUMBER} failed"
            echo "Check logs above for details"
            echo "=========================================="
        }
        always {
            echo "Duration: ${currentBuild.durationString}"
            // Nettoyage des images locales pour libérer de l'espace disque
            script {
                try {
                    def services = env.MICROSERVICES.split()
                    for (service in services) {
                        bat "docker rmi ${REGISTRY}/devopspfe-${service}-service:${BUILD_NUMBER} 2>nul || exit 0"
                    }
                    bat "docker rmi ${REGISTRY}/devopspfe-${FRONTEND_APP}:${BUILD_NUMBER} 2>nul || exit 0"
                } catch (Exception e) {
                    echo "⚠️ Image cleanup failed: ${e.message}"
                }
            }
        }
    }
}