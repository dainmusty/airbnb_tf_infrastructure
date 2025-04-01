# Jenkins project - airbnb_tf_infrastructure

1. new item
2. 

3. open pipeline syntax in a new tab to see how to generate a pipeline script to clone your repo to a jenkins server
for eg. - git branch: 'main', credentialsId: '3ccdcaa2-412b-4793-b15d-dfa4c1c08ee4', url: 'https://github.com/dainmusty/airbnb_tf_infrastructure.git'


# groovy language template or layout(jenkins file)
pipeline {
    agent any

    stages {
        stage('SCM Checkout') {  # this line defines the stage
            steps {                 # steps or commands come below this line.
                echo 'Hello World'  # use the pip syntax to help generate the equilvalent commands in pip
                git branch: 'main'   # this is command for calling your repo in a jenkins file
                sh 'ls'                 # command for using a shell script to list files 
            }
        }
    }
}

# you can either use a pipeline script within jenkins or use a pipeline script from SCM (source code management)
# for automation - use pip script from SCM and specify branch
 # to run terraform commands, we need to setup a terraform environment on jenkins without neccesarily installing terraform on the ec2 instance.

 # to do that, go to jenkins dashboard, manage jenkins, plugins, available plugins, type terraform, install the only option that comes up. go back to the top of the page.

 # go back to your pip and configure, go to the stage indentation in your pip (line 21 above) and hit enter to start type the next stage's commands as seen below

 pipeline {
    agent any

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
    }
}

# though terraform has been installed on jenkins, the pip will fail because it has not been customised for this particular pip

# below are the step to configure
# go to manage jenkins and then tools, add terraform, type Terraform with caps and select terraform 41023 linux amd64 and save

# now you need to configure terraform on your pip
# in your pip script, below agent, hit enter twice and type tools as seen below

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
    }
}

# once terraform init is successful, build terraform plan by going back to configure your pip as seen below
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
    }
}

#if your instance profile has no admin privileges, it will fail. two options; 1. ues iam role 2. use environmnetal variables

# to use env variables
go to manage jenkins, crenditial, global, add crenditials
add your aws crendtials, access and secret access keys
for kind - choose secret
for id - enter AWS_ACCESS_KEY_ID 
for description - enter AWS_ACCESS_KEY_ID
for secret - enter your aws access key id

#do same for secret access key setup
for id - enter AWS_SECRET_ACCESS_KEY_ID 
for description - enter AWS_SECRET_ACCESS_KEY_ID
for secret - enter your aws secret access key id

# add the env variables to your pip environment 
{
        //Credentials for Prod environment
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID') 
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

see below how your final script should look like
pipeline {
    agent any
    
    tools {
        terraform 'Terraform'
    }
    
    environment {
        //Credentials for Prod environment
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID') 
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
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
    }
}

# to parameterize your pip
under configure, stay on general, select 'the project is parameterized'

add parameter and select the parameter you need for eg. lets use the choice parameter in this eg.

give it a name, maybe 'action' and in the choices box, 

type 'apply' on one line and on the next line type 'destroy'

scroll down to pipeline
insert another stage and name it 'terraform action' and under steps add the shell script 
terraform plus the parameter called ${action} plus --auto-approve just as seen below

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

# to add a trigger to automate your builds
under configure, in trigger, select github hook trigger for gitscm polling - so anytime there is 
a git push, it will trigger a build
add the link to your github project

then go to the project repo you are working on in your github to see webhooks; under settings
select 'add webhook', enter your password

under payload URL, paste the link below and change your jenkins server ip
http://54.161.200.183:8080/github-webhook/


# now make changes in your main.tf to confirm the automation
do git add .
git commit -m "test webhook"
git push

# to add pipeline from an SCM say github;
instead of using the 'pipeline script' as your pipeline definition, use 'pipeline from SCM' as your pipeline definition

so choose your 'SCM' = git
provide your repo link, credentials and the branch details and save

now do git add ., git commit and git git push for the jenkinsfile to be picked up




















# to be discussed later
post {
        always {
            echo 'Cleaning up...'
            sh 'terraform destroy --auto-approve'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}








