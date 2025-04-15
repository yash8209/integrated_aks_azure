pipeline {
    agent any

    environment {
        ACR_NAME = 'yashpacr11'
        AZURE_CREDENTIALS_ID = 'integrated-service-principal'
        ACR_LOGIN_SERVER = "${ACR_NAME}.azurecr.io"
        IMAGE_NAME = 'webapidocker1'
        IMAGE_TAG = 'latest'
        RESOURCE_GROUP = 'int-azure-aks'
        AKS_CLUSTER = 'yashpaks11'
        TF_WORKING_DIR = 'api_azure/terraform'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/yash8209/integrated_aks_azure.git'
            }
        }

        stage('Build .NET App') {
            steps {
                bat 'dotnet publish WebApiJenkins/WebApiJenkins.csproj -c Release -o out'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %ACR_LOGIN_SERVER%/%IMAGE_NAME%:%IMAGE_TAG% -f api_azure/Dockerfile api_azure"
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat """
                    echo "Navigating to Terraform Directory: %TF_WORKING_DIR%"
                    cd %WORKSPACE%\\%TF_WORKING_DIR%
                    echo "Initializing Terraform..."
                    terraform init
                    """
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat """
                    echo "Navigating to Terraform Directory: %TF_WORKING_DIR%"
                    cd %WORKSPACE%\\%TF_WORKING_DIR%
                    terraform plan -out=tfplan
                    """
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat """
                    echo "Navigating to Terraform Directory: %TF_WORKING_DIR%"
                    cd %WORKSPACE%\\%TF_WORKING_DIR%
                    echo "Applying Terraform Plan..."
                    terraform apply -auto-approve tfplan
                    """
                }
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
            echo 'All stages completed successfully!'
        }
        failure {
            echo 'Build failed.'
        }
    }
}
