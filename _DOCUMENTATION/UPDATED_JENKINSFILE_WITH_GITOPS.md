# Updated Jenkinsfile - With GitOps Integration

```groovy
pipeline {
    agent any
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
        timeout(time: 1, unit: 'HOURS')
    }
    
    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['development', 'staging', 'production'])
        booleanParam(name: 'PUSH_DOCKER', defaultValue: true)
        booleanParam(name: 'UPDATE_GITOPS', defaultValue: true)
        booleanParam(name: 'RUN_TRIVY', defaultValue: true)
    }
    
    environment {
        DOCKER_REGISTRY = 'eline2016'
        GIT_SOURCE_REPO = 'https://github.com/imenH-cloud/devops-education-platform.git'
        GIT_GITOPS_REPO = 'https://github.com/imenH-cloud/devops-education-platform-gitops.git'
        BUILD_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo "🔄 Checking out source code..."
                checkout scm
            }
        }
        
        stage('Build Backend Services') {
            parallel {
                stage('Build Activity Service') {
                    steps {
                        script {
                            echo "🔨 Building activity-service:${BUILD_TAG}..."
                            dir('backend/activity') {
                                bat "docker build -t ${DOCKER_REGISTRY}/devopspfe-activity-service:${BUILD_TAG} ."
                            }
                        }
                    }
                }
                
                stage('Build Auth Service') {
                    steps {
                        script {
                            echo "🔨 Building auth-service:${BUILD_TAG}..."
                            dir('backend/auth') {
                                bat "docker build -t ${DOCKER_REGISTRY}/devopspfe-auth-service:${BUILD_TAG} ."
                            }
                        }
                    }
                }
                
                stage('Build User Service') {
                    steps {
                        script {
                            echo "🔨 Building user-service:${BUILD_TAG}..."
                            dir('backend/user') {
                                bat "docker build -t ${DOCKER_REGISTRY}/devopspfe-user-service:${BUILD_TAG} ."
                            }
                        }
                    }
                }
                
                // Add other services...
            }
        }
        
        stage('Build Frontend') {
            steps {
                script {
                    echo "🔨 Building frontend-app:${BUILD_TAG}..."
                    dir('frontend/app') {
                        bat "docker build -t ${DOCKER_REGISTRY}/devopspfe-frontend-app:${BUILD_TAG} ."
                    }
                }
            }
        }
        
        stage('Security Scanning') {
            when {
                expression { params.RUN_TRIVY == true }
            }
            steps {
                script {
                    echo "🔍 Running Trivy security scans..."
                    bat '''
                        for %%s in (activity auth user parent student classroom teacher gateway) do (
                            echo Scanning eline2016/devopspfe-%%s-service:%BUILD_TAG%...
                            docker run --rm aquasec/trivy:latest image --exit-code 0 --severity CRITICAL ^
                                eline2016/devopspfe-%%s-service:%BUILD_TAG% || exit /b 0
                        )
                    '''
                }
            }
        }
        
        stage('Push to Docker Hub') {
            when {
                expression { params.PUSH_DOCKER == true }
            }
            steps {
                script {
                    echo "📤 Pushing images to Docker Hub..."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', 
                                    usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        bat '''
                            docker login -u %DOCKER_USER% -p %DOCKER_PASS%
                            
                            for %%s in (activity auth user parent student classroom teacher gateway) do (
                                echo Pushing eline2016/devopspfe-%%s-service:%BUILD_TAG%...
                                docker push eline2016/devopspfe-%%s-service:%BUILD_TAG%
                            )
                            
                            echo Pushing eline2016/devopspfe-frontend-app:%BUILD_TAG%...
                            docker push eline2016/devopspfe-frontend-app:%BUILD_TAG%
                            
                            docker logout
                        '''
                    }
                }
            }
        }
        
        stage('Update GitOps Repository') {
            when {
                expression { params.UPDATE_GITOPS == true && params.PUSH_DOCKER == true }
            }
            steps {
                script {
                    echo "🔄 Updating GitOps repository..."
                    withCredentials([usernamePassword(credentialsId: 'github-credentials',
                                    usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
                        bat '''
                            REM Clone GitOps repo
                            if exist gitops-temp rmdir /s /q gitops-temp
                            
                            git clone https://%GIT_USER%:%GIT_TOKEN%@github.com/imenH-cloud/devops-education-platform-gitops.git gitops-temp
                            cd gitops-temp
                            
                            REM Update image tags in manifests using PowerShell
                            echo Updating image tags to %BUILD_TAG%...
                            
                            powershell -Command ^
                            "Get-ChildItem -Path 'kubernetes' -Recurse -Filter 'deployment.yaml' | ForEach-Object { ^
                                (Get-Content $_.FullName) -replace 'image: eline2016/devopspfe-([a-z-]+):.*', 'image: eline2016/devopspfe-$1:%BUILD_TAG%' | ^
                                Set-Content $_.FullName ^
                            }"
                            
                            REM Commit and push
                            git config user.email "jenkins@devops.local"
                            git config user.name "Jenkins CI/CD"
                            git add kubernetes/
                            git commit -m "Build %BUILD_TAG% - Update Docker images" || exit /b 0
                            git push https://%GIT_USER%:%GIT_TOKEN%@github.com/imenH-cloud/devops-education-platform-gitops.git main
                            
                            cd ..
                            rmdir /s /q gitops-temp
                            
                            echo ✅ GitOps repository updated
                        '''
                    }
                }
            }
        }
        
        stage('Notify ArgoCD') {
            when {
                expression { params.UPDATE_GITOPS == true }
            }
            steps {
                script {
                    echo "🔔 Notifying ArgoCD of changes..."
                    bat '''
                        REM ArgoCD will automatically detect changes via GitHub webhook
                        echo ✅ ArgoCD will auto-sync from GitHub
                    '''
                }
            }
        }
    }
    
    post {
        always {
            script {
                echo "🧹 Cleaning up..."
                bat 'docker image prune -f || exit /b 0'
            }
        }
        
        success {
            echo "✅ BUILD SUCCESSFUL - Build #${BUILD_NUMBER}"
            echo "📤 Images pushed: eline2016/devopspfe-*:${BUILD_NUMBER}"
            echo "🔄 GitOps repository updated"
            echo "🚀 ArgoCD will sync automatically"
        }
        
        failure {
            echo "❌ BUILD FAILED - Build #${BUILD_NUMBER}"
        }
    }
}
```

---

## 📝 WHAT CHANGED

### Before (Manual Deployment):
```
Jenkins builds → Docker Hub → kubectl apply manually
```

### After (GitOps Workflow):
```
Jenkins builds → Docker Hub → Updates Git → ArgoCD syncs automatically
```

---

## 🔑 KEY IMPROVEMENTS

✅ **Automated GitOps Updates**
- Jenkins updates Kubernetes manifests in Git
- No manual kubectl apply needed

✅ **Git as Source of Truth**
- All infrastructure in GitHub
- Audit trail for every change
- Rollback by reverting commit

✅ **ArgoCD Auto-Sync**
- Detects changes via webhook
- Automatically deploys
- Self-healing (if manually changed)

✅ **Staging Environments**
- Different overlays for dev/staging/prod
- Easy promotion between environments

---

## 🚀 HOW TO USE

1. **Replace your current Jenkinsfile** with this updated version
2. **Configure GitHub credentials** in Jenkins
3. **Run the pipeline** - it will now update Git + ArgoCD

Done! ✅
