pipeline {
    agent any
    
    tools {
        terraform 'Terraform'
    }
    

    stages {
        stage('SCM Checkout') {
            steps {
                echo 'cloning repo with jenkins server'
                git branch: 'main', credentialsId: '3ccdcaa2-412b-4793-b15d-dfa4c1c08ee4', url: 'https://github.com/dainmusty/airbnb_tf_infrastructure.git'
                sh 'ls'
            }
        }
        
        stage('terraform init') {
            steps {
                sh 'terraform init'
            }
        }  
        
        stage('terraform plan') {
            steps {
                sh 'terraform plan'
            }
        }
        
        stage('terraform action to apply or destroy plan') {
            steps {
                sh 'terraform ${action} --auto-approve'
            }
        }
    }
}
