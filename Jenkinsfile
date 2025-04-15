pipeline {
    agent any

    environment {
        ACR_NAME = 'yashpacr11'
        AZURE_CREDENTIALS_ID = 'integrated-service-principal' // Set this in Jenkins Credentials
        ACR_LOGIN_SERVER = "${ACR_NAME}.azurecr.io"
        IMAGE_NAME = 'webapidocker1'
        IMAGE_TAG = 'latest'
        RESOURCE_GROUP = 'int-azure-aks'
        AKS_CLUSTER = 'yashpaks11'
        TF_WORKING_DIR = 'terraform'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/yash8209/integrated_aks_azure.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %ACR_LOGIN_SERVER%/%IMAGE_NAME%:%IMAGE_TAG% -f api_azure/Dockerfile ."
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat "az login --service-principal -u %AZURE_CLIENT_ID% -p %AZURE_CLIENT_SECRET% --tenant %AZURE_TENANT_ID% && cd %TF_WORKING_DIR% && terraform init"
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                bat "cd %TF_WORKING_DIR% && terraform plan -out=tfplan"
            }
        }

        stage('Terraform Apply') {
            steps {
                bat "cd %TF_WORKING_DIR% && terraform apply -auto-approve tfplan"
            }
        }

        stage('Login to ACR') {
            steps {
                bat "az acr login --name %ACR_NAME%"
            }
        }

        stage('Push Docker Image to ACR') {
            steps {
                bat "docker push %ACR_LOGIN_SERVER%/%IMAGE_NAME%:%IMAGE_TAG%"
            }
        }

        stage('Get AKS Credentials') {
            steps {
                bat "az aks get-credentials --resource-group %RESOURCE_GROUP% --name %AKS_CLUSTER% --overwrite-existing"
            }
        }

        stage('Deploy to AKS') {
            steps {
                bat "kubectl apply -f deployment.yaml"
            }
        }
    }

    post {
        success {
            echo '✅ Deployment complete!'
        }
        failure {
            echo '❌ Build failed.'
        }
    }
}
